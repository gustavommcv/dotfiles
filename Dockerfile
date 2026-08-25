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
# Compat: musl vs. the mostly-glibc world Mason/npm binaries assume, plus two
#   things found only by actually running this (not by reading docs):
#   - tree-sitter-cli ships a glibc-linked binary via npm; Alpine packages it
#     natively for musl, so apk wins over letting npm fetch its own.
#   - lua-language-server: mason-registry's package.yaml *declares* a
#     linux_x64_musl asset, but the upstream 3.19.1 release currently only
#     publishes linux-x64/linux-arm64 (glibc) tarballs — confirmed with a
#     direct curl against the exact URL Mason requests: 404. Registry
#     metadata can drift from what's actually published upstream; apk's
#     native package sidesteps the whole question. See the [2/4] MasonInstall
#     layer below for how this is wired up (or rather, deliberately isn't).
#   - gcompat is a small safety net for any other Mason-downloaded binary that
#     turns out to be glibc-linked (gopls/goimports are static Go binaries and
#     the npm-based LSP servers run through node either way, so this mainly
#     covers stylua/ruff if their registry entry has the same drift problem).
#   - bash: several npm postinstall scripts and installers (including Oh My
#     Zsh's) hardcode `#!/bin/bash`; Alpine's default shell is busybox ash.
#   - shadow: Alpine's busybox usermod can't change an existing user's UID/GID
#     — needed by entrypoint.sh's host UID/GID remap.
#   - wget: Mason downloads at least some GitHub-release assets with `wget`
#     specifically, not `curl` (which was already in the list) — without it,
#     installs fail with "spawn: wget failed" before ever reaching the actual
#     HTTP response, which is what the lua-language-server 404 above needed
#     `wget` present to even reveal.
RUN apk add --no-cache \
        # Essential
        bash git openssh-client zsh tmux curl wget ca-certificates \
        ripgrep fd tree-sitter-cli unzip neovim lua-language-server \
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
# Split into 4 separate RUN layers deliberately (not chained with &&): if one
# fails, the build log/CI annotation points at that exact step instead of a
# 4-command blob, and each layer is independently cacheable. Each command was
# chosen specifically because it's documented to block until done — the plain
# async forms (:MasonInstall via vim.cmd(), :MasonToolsInstall,
# ts.install() without :wait()) return before their background jobs finish,
# which would silently ship a half-installed image. `echo` markers below and
# a trailing `:messages` dump make each layer's own log self-explanatory even
# without re-deriving which nvim invocation is running.

# 1) Plugins. Bootstraps lazy.nvim itself (see lua/config/lazy.lua), then
# installs every plugin. `:Lazy! sync` blocks in headless mode. This also
# runs nvim-treesitter's own `build = ":TSUpdate"` hook as a side effect —
# step 4 below re-confirms with an explicit :wait() as belt-and-suspenders.
RUN echo "=== [1/4] Lazy! sync ===" \
    && nvim --headless "+Lazy! sync" -c "messages" -c "qa"

# 2) LSP servers. `mason-lspconfig`'s own `ensure_installed` (mason.lua's
# `lsp_servers` table) is what actually triggers Mason installs on Lazy sync,
# but that path installs asynchronously with no headless-safe wait primitive
# of its own — so these are re-installed here explicitly via `:MasonInstall`
# as a direct `-c` command, which (unlike the same call wrapped in
# `vim.cmd()`) is documented to block. Names are Mason *package* names, not
# lspconfig server names — verified against mason-registry's package.yaml
# `neovim.lspconfig` field, not assumed: gopls shares its lspconfig name,
# html->html-lsp, cssls->css-lsp, emmet_ls->emmet-ls, ts_ls->typescript-
# language-server, texlab/pyright share their lspconfig name as-is.
#
# lua-language-server is deliberately NOT in this list, installed via apk
# instead (see the system-packages layer above) — found by actually running
# this: mason-registry's package.yaml *declares* a linux_x64_musl asset for
# it, which is why the earlier musl-compat research trusted Mason to handle
# it, but the upstream 3.19.1 release currently only publishes
# lua-language-server-3.19.1-linux-{x64,arm64}.tar.gz (no -musl variant) —
# confirmed with a direct curl against the exact URL Mason requests, 404.
# Registry declarations can drift from what's actually published upstream;
# vim.lsp.enable("lua_ls") resolves `cmd = {"lua-language-server"}` via
# $PATH regardless of whether Mason "installed" it, so the apk package
# satisfies it exactly the same way.
RUN echo "=== [2/4] MasonInstall (LSP servers) ===" \
    && nvim --headless \
        -c "MasonInstall gopls html-lsp css-lsp emmet-ls typescript-language-server texlab pyright" \
        -c "messages" -c "qa"

# 3) Formatters/linters. Separate plugin (mason-tool-installer.nvim), separate
# ensure_installed list, separate documented-blocking command.
RUN echo "=== [3/4] MasonToolsInstallSync (formatters/linters) ===" \
    && nvim --headless "+MasonToolsInstallSync" -c "messages" -c "qa"

# 4) Treesitter parsers. require('nvim-treesitter').install(...):wait(ms) is
# nvim-treesitter's own documented pattern for synchronous installs in a
# script/CI context. List mirrors lua/plugins/treesitter.lua's `parsers`
# table exactly — keep the two in sync if that file changes upstream.
RUN echo "=== [4/4] Treesitter parsers ===" \
    && nvim --headless -c "lua require('nvim-treesitter').install({ \
            'lua','vim','vimdoc','query','markdown','markdown_inline', \
            'javascript','typescript','tsx','html','css','json','yaml', \
            'bash','python','go','c','cpp','latex' \
        }):wait(300000)" -c "messages" -c "qa"

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
