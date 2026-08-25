# syntax=docker/dockerfile:1
#
# Portable dev environment: Alpine + Neovim (github.com/gustavommcv/minimal-neovim),
# fully bootstrapped at BUILD time so `docker run` gives an instantly-ready editor —
# no `:Lazy sync` / Mason / Treesitter wait on a fresh machine. See README.md for the
# full reasoning, including why specific packages below are apk-native instead of
# npm/Mason-installed (musl vs. glibc).
#
# x86_64 only — every university-lab-PC assumption behind this branch is Intel/AMD.
# arm64 would need re-checking the musl-asset availability noted in README.md.

FROM alpine:3.24

ARG NVIM_CONFIG_REF=main
ARG DEV_UID=1000
ARG DEV_GID=1000

LABEL org.opencontainers.image.source="https://github.com/gustavommcv/dotfiles" \
      org.opencontainers.image.description="Portable Alpine dev environment: Neovim (minimal-neovim) + zsh + tmux, pre-baked at build time." \
      org.opencontainers.image.licenses="MIT"

# --- System packages -----------------------------------------------------
#
# Essential: base shell/editor/vcs stack, always needed regardless of language.
# Development: what minimal-neovim's default 8 LSP servers + treesitter parsers
#   need to actually run (see its README's "Languages supported out of the box").
# Compat: musl vs. the mostly-glibc world Mason/npm binaries assume.
#   - tree-sitter-cli and (as a fallback path) lua-language-server ship glibc-linked
#     binaries via npm/Mason; Alpine packages both natively for musl, so apk wins
#     over letting Mason/npm try to fetch their own.
#   - gcompat is a small safety net for any other Mason-downloaded binary that
#     turns out to be glibc-linked (gopls/goimports are static Go binaries and the
#     npm-based LSP servers run through node either way, so this mainly covers
#     stylua/ruff if their registry entry ever lacks a musl asset).
#   - bash: several npm postinstall scripts and installers (including Oh My Zsh's)
#     hardcode `#!/bin/bash`; Alpine's default shell is busybox ash, not bash.
#   - shadow: Alpine's busybox usermod can't change an existing user's UID/GID —
#     needed by entrypoint.sh's host UID/GID remap.
RUN apk add --no-cache \
        # Essential
        bash git openssh-client zsh tmux curl ca-certificates \
        ripgrep fd tree-sitter-cli unzip neovim \
        su-exec shadow gcompat \
        # Development (languages the default Neovim config supports out of the box)
        nodejs npm go python3 build-base

# --- Non-root user ---------------------------------------------------------
# Fixed UID/GID at build time; entrypoint.sh remaps both to match the host user
# at container start, so bind-mounted files never end up root-owned. DEV_UID/GID
# only matter as the *starting point* before that remap.
RUN addgroup -g "$DEV_GID" dev \
    && adduser -D -u "$DEV_UID" -G dev -s /bin/zsh -h /home/dev dev \
    && mkdir -p /workspace \
    && chown dev:dev /workspace

# --- Dotfiles (this repo's own tmux/zsh config) -----------------------------
COPY --chown=dev:dev tmux/.tmux.conf /home/dev/.tmux.conf
COPY --chown=dev:dev zsh/.zshrc /home/dev/.zshrc

USER dev
WORKDIR /home/dev
ENV HOME=/home/dev \
    PATH="/home/dev/go/bin:${PATH}"

# --- Oh My Zsh + the 2 plugins .zshrc expects --------------------------------
# KEEP_ZSHRC=yes: the installer backs up and replaces ~/.zshrc with its own
# template otherwise, clobbering the one just copied above (same gotcha
# documented in the wsl branch's README).
RUN KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
    && git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" \
    && git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"

# --- Neovim config (separate repo, same pattern as main/notebook/wsl's install.sh) ---
RUN git clone --branch "$NVIM_CONFIG_REF" --depth 1 \
        https://github.com/gustavommcv/minimal-neovim.git "$HOME/.config/nvim"

# --- Bake plugins, LSP servers/formatters/linters, and treesitter parsers ---
# Each step below is chosen specifically because it's documented to block until
# done — the plain async commands (:MasonInstall without qa chained badly,
# :MasonToolsInstall, ts.install() without :wait()) return before their
# background jobs finish, which would silently ship a half-installed image:
#   - `:Lazy! sync` itself blocks in headless mode (bootstraps lazy.nvim, then
#     installs every plugin, including nvim-treesitter's own `:TSUpdate` build
#     hook — belt-and-suspenders with the explicit :wait() below).
#   - `:MasonInstall <list>` as a direct headless `-c` command blocks, unlike
#     the same call wrapped in `vim.cmd()`. Installs mason-lspconfig's
#     `ensure_installed` list (lua_ls/gopls/html/cssls/emmet_ls/ts_ls/texlab/
#     pyright) from mason.lua.
#   - `:MasonToolsInstallSync` is mason-tool-installer's own documented
#     blocking command, for its separate ensure_installed list (formatters/
#     linters: stylua/prettierd/prettier/goimports/ruff/eslint_d).
#   - `require('nvim-treesitter').install(...):wait(ms)` is nvim-treesitter's
#     documented pattern for synchronous parser installs in a script context.
# This is the least testable step in this Dockerfile without a real Docker
# daemon — see README.md's note on what CI verifies that this environment
# couldn't.
RUN nvim --headless "+Lazy! sync" +qa \
    && nvim --headless -c "MasonInstall lua-language-server gopls html-lsp css-lsp emmet-ls typescript-language-server texlab pyright" -c "qa" \
    && nvim --headless "+MasonToolsInstallSync" +qa \
    && nvim --headless -c "lua require('nvim-treesitter').install({ \
            'lua','vim','vimdoc','query','markdown','markdown_inline', \
            'javascript','typescript','tsx','html','css','json','yaml', \
            'bash','python','go','c','cpp','latex' \
        }):wait(300000)" -c "qa"

# --- Entrypoint --------------------------------------------------------------
# Back to root: the container must START as root so entrypoint.sh can remap the
# dev user's UID/GID to match the host user (passed in as HOST_UID/HOST_GID by
# the `dev` launcher script) before dropping privileges via su-exec. Everything
# above ran as `dev` on purpose — that's what makes $HOME resolve correctly for
# Neovim/Oh My Zsh during the bake.
USER root
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /workspace
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["zsh"]
