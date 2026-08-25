# Changelog

## wsl

- **2026-08-06** — `install.sh` now clones and installs [minimal-neovim](https://github.com/gustavommcv/minimal-neovim)
  (own repo, not vendored here) into `~/.config/nvim`, plus its dependencies
  (`neovim`, `ripgrep`, `tree-sitter-cli`, `unzip`, `nodejs`, `npm`, `go` — `gcc` was
  already covered by `base-devel`).
- **2026-08-05** — Documented `KEEP_ZSHRC=yes` as required on the Oh My Zsh install command — without
  it, the installer clobbers the `.zshrc` symlink `install.sh` already put in place with its own
  template; added the recovery command for anyone who already hit this.
- **2026-08-05** — Documented the Oh My Zsh + `zsh-autosuggestions`/`zsh-syntax-highlighting` install
  step — none of the three are pacman/AUR packages, so `install.sh` deliberately doesn't install them,
  but `.zshrc` errors without them.
- **2026-08-05** — `install.sh`'s `chsh` call now hardcodes `/usr/bin/zsh` instead of `command -v zsh`,
  which could resolve to `/usr/sbin/zsh` on Arch's merged-usr layout — same binary, but `chsh` matches
  `/etc/shells` by exact string and only `/usr/bin/zsh` is listed there.
- **2026-08-05** — `install.sh` now actually sets zsh as the login shell via `chsh` — installing the
  package alone never did.
- **2026-08-05** — Fixed the `.wslconfig` copy instructions: the previous `copy` command assumed
  running from PowerShell with a Windows-side path, but the repo lives inside the WSL filesystem;
  replaced with a plain `cp` through `/mnt/c/`, runnable from the same WSL shell as every other step.
- **2026-08-05** — Filled in the actual repo URL in the README clone instructions.
- **2026-08-05** — Initial WSL branch: forked from `main` (commit `64d7b49`), removed the
  entire GUI/compositor stack (Hyprland, Waybar, Rofi, foot, MangoHud, and everything that
  only existed to serve them — portals, greetd, SwayNC/SwayOSD, bluetui, clipse, AGS), relocated
  the one script that's still genuinely generic (`toggle-mic.sh` + its audio cues) to a new
  top-level `scripts/` directory, added WSL-specific configs (`wsl/wsl.conf`, `wsl/.wslconfig`),
  and rewrote `install.sh` around the official pacman repositories instead of `yay`/AUR.

---

*This branch's history starts here — see `main`'s and `notebook`'s own `CHANGELOG.md` for their
history prior to this fork.*
