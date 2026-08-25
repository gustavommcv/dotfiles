# Dotfiles — `docker-alpine` branch

![License](https://img.shields.io/badge/license-MIT-2E6E71)
![Platform](https://img.shields.io/badge/platform-Alpine%20Linux%20%2F%20Docker-1793D1)

A portable dev environment — Neovim ([minimal-neovim](https://github.com/gustavommcv/minimal-neovim)) +
zsh + tmux on Alpine — packaged as a Docker image so it can run on machines where installing
anything isn't an option (university lab PCs), as long as Docker is available. Unlike `main`,
`notebook`, and `wsl`, this isn't "clone the repo and run `install.sh` on your own machine" — the
environment is pre-built once by CI and pulled ready-to-use.

## Quick start

```bash
git clone https://github.com/gustavommcv/dotfiles.git ~/dotfiles
cd ~/dotfiles
git checkout docker-alpine
./dev
```

`./dev` pulls `ghcr.io/gustavommcv/dotfiles-docker-alpine:latest` if it isn't cached locally yet,
then drops you into zsh at `/workspace` — a bind mount of whatever directory you ran it from — with
Neovim, LSPs, formatters, and Treesitter parsers already installed. `nvim` is ready immediately,
no `:Lazy sync` wait.

Don't want to clone the whole repo first? `./dev` is a single self-contained file:

```bash
curl -fsSL https://raw.githubusercontent.com/gustavommcv/dotfiles/docker-alpine/dev -o dev
chmod +x dev
./dev
```

Or skip the script and run Docker directly:

```bash
docker pull ghcr.io/gustavommcv/dotfiles-docker-alpine:latest
docker run --rm -it \
    -e HOST_UID="$(id -u)" -e HOST_GID="$(id -g)" \
    -v "$(pwd):/workspace" \
    -v "$HOME/.ssh:/home/dev/.ssh:ro" \
    -v "$HOME/.gitconfig:/home/dev/.gitconfig:ro" \
    ghcr.io/gustavommcv/dotfiles-docker-alpine:latest
```

`./dev` exists mainly to get the `HOST_UID`/`HOST_GID` env vars and the conditional mounts right
without having to remember them — see [Persistence & host integration](#persistence--host-integration).

## Why a pre-built image, not a local build

The whole point of this branch is a university lab PC: Docker is there, nothing else is, and the
next class starts in ten minutes. A local build (`docker build` from `Dockerfile`) has to run every
step below — `apk add` the language toolchains, clone `minimal-neovim`, `Lazy! sync`, install every
LSP server/formatter through Mason, compile every Treesitter parser — on *that* machine, every time.
None of that is cached from a previous session, because you're not going to be on the same lab PC
twice in a row.

A pre-built image moves all of that to CI, once, per change — `docker pull` is just fetching
already-compiled layers. Reproducibility is a side benefit, not the main reason: whichever lab PC
you're on gets the exact same environment, pinned to a specific `minimal-neovim` commit at build
time (see [Updating](#updating)).

## What's essential vs. installed on demand

| Category | Packages | Why |
|---|---|---|
| **Essential** | `neovim` `git` `openssh-client` `zsh` `tmux` `bash` `curl` `wget` `ca-certificates` `ripgrep` `fd` `unzip` | Editor, VCS, shell, and what Telescope/Mason need to function at all. `bash` matters even though the shell is zsh — several npm postinstall scripts and the Oh My Zsh installer hardcode `#!/bin/bash`, which doesn't exist on a stock Alpine image. `wget` matters because Mason downloads at least some GitHub-release assets with it specifically, not `curl` — confirmed by the build failing without it, not assumed. |
| **musl compat** | `tree-sitter-cli` `lua-language-server` `gcompat` `shadow` `su-exec` | See [Alpine/musl compatibility](#alpinemusl-compatibility) below — these exist specifically because this is Alpine, not Arch. |
| **Development** | `nodejs` `npm` `go` `python3` `build-base` | What `minimal-neovim`'s 8 default LSP servers need to run (5 are npm packages, `gopls`/`goimports` need Go only at install time, `build-base` compiles Treesitter parsers) — see that repo's own README for the exact breakdown. |
| **Not included** | `texlive`, `zathura`, `arduino-cli`, `clangd` | LaTeX and Arduino support are opt-in even in `minimal-neovim` itself (see its docs) — no reason to bake them into a generic image. Add with a plain `apk add` inside a running container if you ever need them for one session; they won't persist across containers unless you rebuild the image with them added. |

Every package above was checked against what the pinned `minimal-neovim` commit's
`lua/plugins/mason.lua` and `treesitter.lua` actually declare — and two of them (`wget`,
`lua-language-server`) were found by actually running the build in CI and reading the failure, not
by reading docs. See [What's verified vs. what CI verifies](#whats-verified-vs-what-ci-verifies).

## Alpine/musl compatibility

Alpine uses musl libc, not glibc — most of `main`/`notebook`/`wsl`'s dependencies don't care (Neovim,
git, zsh, tmux, ripgrep, fd, Go, Node.js, Python all have proper musl-native Alpine packages), but
two things in the Neovim stack specifically ship **glibc-linked** binaries by default and needed a
different install path:

- **`tree-sitter-cli`** — the npm package's prebuilt binary is glibc-linked and won't run under
  musl. Alpine packages it natively (`apk add tree-sitter-cli`), so the Dockerfile uses that instead
  of the `npm install -g tree-sitter-cli` the other branches' READMEs mention.
- **`lua-language-server`** — installed via `apk` instead of Mason, and this one has a real story:
  mason-registry's `package.yaml` *declares* a `linux_x64_musl` asset for it, which looked like
  reason enough to trust Mason's own platform detection and skip special-casing it. Running the
  actual build proved that wrong — the upstream 3.19.1 release currently only publishes
  `linux-x64`/`linux-arm64` (glibc) tarballs, no `-musl` variant, so `MasonInstall` failed with a
  literal 404 against the exact URL it requested (reproduced independently with a plain `curl`
  against that URL). Registry metadata can drift from what's actually published upstream; this is
  now excluded from the `MasonInstall` list in the Dockerfile and satisfied by Alpine's native
  package instead — `vim.lsp.enable("lua_ls")` resolves `cmd = {"lua-language-server"}` via `$PATH`
  regardless of whether Mason "installed" it, so this works identically from Neovim's perspective.
- **`gcompat`** — installed as a blanket safety net for anything else Mason might resolve to a
  glibc binary (candidates: `stylua`, `ruff` — both ship prebuilt GitHub-release binaries whose
  exact musl/glibc asset matrix wasn't independently verified the way `lua_ls`'s was). Costs about
  2MB; if everything above already has a musl-native path, it's simply unused.
- **`gopls`/`goimports`** — no musl concern at all: Mason builds these via `go install`, which by
  default produces a static binary with no libc dependency either way.
- The 5 npm-based LSP servers (`html`, `cssls`, `emmet_ls`, `ts_ls`, `pyright`) and 3
  npm-based formatters/linters (`prettierd`, `prettier`, `eslint_d`) run through `node`, so they're
  libc-agnostic as long as Node itself works — which Alpine's own `nodejs`/`npm` packages do,
  natively, extremely well-trodden (`node:alpine` is one of the most-used Docker base images that
  exists).
- **LaTeX (`vimtex`) is not wired up** — `zathura` and a LaTeX distribution aren't installed. Not an
  Alpine-specific issue, just not part of this environment's scope (see the table above).

If a future `minimal-neovim` plugin/tool turns out to need something not covered above, the fix is
almost always "check if Alpine packages it natively first, fall back to `gcompat` only if not."

## Persistence & host integration

| What | How | Why |
|---|---|---|
| Your project files | `-v "$(pwd):/workspace"` | Bind mount — edits happen on the host filesystem, the container is disposable. |
| `~/.ssh` | `-v "$HOME/.ssh:/home/dev/.ssh:ro"`, read-only | `git push`/SSH auth work without ever copying a private key into the image. |
| `~/.gitconfig` | `-v "$HOME/.gitconfig:/home/dev/.gitconfig:ro"`, read-only | Commits get your real identity without reconfiguring it every container. |
| Neovim plugin/LSP state | 3 named volumes (`dotfiles-nvim-data`/`-cache`/`-state`) | The image already ships everything pre-installed — these just mean anything you add *interactively* in one session (`:MasonInstall` something extra) survives to the next container **on that same machine**. Docker seeds a named volume from the image's own directory contents the first time it's mounted, so this doesn't undo the pre-baking. |
| File ownership | `entrypoint.sh` remaps the container's `dev` user to `HOST_UID`/`HOST_GID` via `usermod`/`groupmod`, then `su-exec dev` | Without this, anything the container writes to `/workspace` would show up **root-owned** on the host the moment the container's internal UID doesn't match yours. `./dev` passes your real `id -u`/`id -g` in automatically. |

The container never runs as root for anything you do — `entrypoint.sh` starts as root only long
enough to do the UID/GID remap, then drops privileges and `exec`s your shell/command as `dev`.

## Updating

The image doesn't rebuild itself when you change local files — it's built by
[`.github/workflows/docker-build.yml`](.github/workflows/docker-build.yml) and pushed to
`ghcr.io/gustavommcv/dotfiles-docker-alpine`, triggered by:

- a push to this branch touching `Dockerfile`, `entrypoint.sh`, `dev`, `zsh/.zshrc`, or
  `tmux/.tmux.conf`;
- a weekly cron (Mondays), so the image periodically re-pulls `minimal-neovim@main` even when
  nothing in *this* repo changed;
- manually, via the Actions tab (`workflow_dispatch`).

Tags: `latest` (always the most recent successful build) and `<git-sha>` (immutable — pin to one if
you need to roll back: `DOTFILES_IMAGE=ghcr.io/gustavommcv/dotfiles-docker-alpine:abc1234 ./dev`).
`./dev` uses whatever's cached locally by default — pass `--pull` to force a fresh pull, or
`--build` to build from your own local `Dockerfile` instead (useful while testing changes to this
branch itself before pushing).

## Structure

| Repo path | Role |
|---|---|
| [`Dockerfile`](Dockerfile) | Builds the image: system packages, non-root user, dotfiles, Oh My Zsh, `minimal-neovim` clone + full headless bootstrap (Lazy/Mason/Treesitter). |
| [`entrypoint.sh`](entrypoint.sh) | Container-start UID/GID remap + privilege drop, described above. |
| [`dev`](dev) | Host-side launcher script — the primary way to use this branch. |
| `zsh/.zshrc`, `tmux/.tmux.conf` | Same role as on `main`/`notebook`/`wsl`, copied (not symlinked — there's no persistent `~/dotfiles` checkout inside the running container) into the image at build time. |
| `.github/workflows/docker-build.yml` | CI: builds and pushes the image to GHCR. |

## What's verified vs. what CI verifies

This branch was built and reviewed without a local Docker daemon available — everything below was
checked as rigorously as possible without actually running it:

- `dev` and `entrypoint.sh` — syntax-validated (`bash -n` / `sh -n`), logic traced by hand.
- Every `apk`/Mason/npm package name — cross-checked against Alpine's package index and, for the
  trickier ones, the actual `mason-registry` `package.yaml` source (not memory) — see
  [Alpine/musl compatibility](#alpinemusl-compatibility) above for what that turned up.
- The headless bootstrap commands (`Lazy! sync`, `MasonInstall`, `MasonToolsInstallSync`,
  `nvim-treesitter`'s `:wait()`) — each chosen because it's *documented* to block until done, not
  guessed. This is the least testable part of the Dockerfile: whether it actually completes cleanly
  in a real Alpine container can only be confirmed by an actual `docker build`, which is exactly what
  the first CI run does. If it fails, `Actions` → the failed run's log will show which step; that's
  the fastest path to a fix, faster than trying to fully simulate Docker locally.
- What CI *doesn't* cover: `arm64` (workflow only builds the default `amd64` runner architecture —
  see the Dockerfile's own note on this), and the actual UID/GID remap + bind-mount behavior in
  `entrypoint.sh`/`dev`, which needs a real `docker run` on a real machine with a real `$HOME` to
  exercise meaningfully.

## What's not here (and why)

Same reasoning as `wsl`, one step further — there isn't even a host display server passthrough
(WSLg) to consider, since this is a plain Linux container:

| Removed | Reason |
|---|---|
| `hypr/`, `waybar/`, `rofi/`, `foot/`, `MangoHud/` | No compositor at all inside a container — same as `wsl`, minus WSLg. |
| `install.sh` | Replaced by the `Dockerfile` — installation now happens once, at image build time, not per-machine. |
| `scripts/` (`toggle-mic.sh` + audio cues) | No audio device inside a container — `wsl` kept this because WSLg passes through a PulseAudio-compatible socket; plain Docker has nothing equivalent. |
| `wsl/` (`wsl.conf`, `.wslconfig`) | WSL-specific, not applicable to any other environment. |
| `greetd`/`ly`, `xdg-desktop-portal-*`, `swaync`/`swayosd`, `bluetui`, `clipse`/`wl-clip-persist`, AGS | All GUI/session-manager concerns — never applicable to a container, same as `wsl`. |
