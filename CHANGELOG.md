# Changelog

## docker-alpine

- **2026-08-06** — Initial branch: forked from `wsl`, removed everything WSL/audio-specific
  (`scripts/`, `wsl/`, `install.sh`). Added a `Dockerfile` that bakes a full
  [minimal-neovim](https://github.com/gustavommcv/minimal-neovim) install (Lazy sync, Mason LSPs/
  formatters, Treesitter parsers) at image build time instead of on first container start;
  `entrypoint.sh` for host UID/GID remapping via `su-exec`; a `dev` launcher script; and
  `.github/workflows/docker-build.yml` publishing to `ghcr.io/gustavommcv/dotfiles-docker-alpine`
  on push, weekly cron, and manual dispatch. Resolved two musl/glibc incompatibilities
  (`tree-sitter-cli`, verified Mason's `lua-language-server` musl asset) by using Alpine-native
  `apk` packages instead of the npm/Mason paths the other branches use.

---

*This branch's history starts here — see `main`'s, `notebook`'s, and `wsl`'s own `CHANGELOG.md` for
history prior to this fork.*
