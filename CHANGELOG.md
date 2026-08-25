# Changelog

This repository tracks three long-lived branches (`main` for desktop, `notebook` for laptop, `wsl`
for Arch-on-WSL2) rather than sequential releases, so this log is organized by branch and date
rather than by version number. `wsl` has its own section in its branch's copy of this file (it
forked from `main` on 2026-08-05, long after `main`/`notebook` split). Entries below start at the
`main`/`notebook` split point.

## main

- **2026-08-06** — `install.sh` now clones and installs [minimal-neovim](https://github.com/gustavommcv/minimal-neovim)
  (own repo, not vendored here) into `~/.config/nvim`, plus its dependencies
  (`neovim`, `ripgrep`, `tree-sitter-cli`, `unzip`, `gcc`, `nodejs`, `npm`).
- **2026-08-05** — Filled in the actual repo URL in the README clone instructions.
- **2026-08-05** — Replaced `ly` with `greetd`/`greetd-tuigreet` as the login manager.
- **2026-08-05** — Unified the mic-mute hardware key with `Alt+M`: both now route through
  `toggle-mic.sh` instead of the hardware key calling `swayosd-client` directly.
- **2026-08-04** — Removed dead `cpu`/`memory` Waybar module definitions (never activated in
  `config.jsonc`); documented the `ags` (Aylur's GTK Shell) dependency behind the clock's
  ActivityCenter widget, including its upstream-deprecated status.
- **2026-08-04** — `install.sh` now also installs `xdg-desktop-portal-gtk` and `google-chrome`
  (the configured default browser was never actually installed), and symlinks every config
  directory into `~/.config`/`$HOME` instead of only installing packages.
- **2026-08-04** — Reverted the autostarted polkit agent back to `hyprpolkitagent` (a February
  commit had switched it to `polkit-gnome`, a package `install.sh` never installed); fixed
  `refresh-waybar.sh`, which only started a *stopped* bar instead of restarting a running one;
  removed a hardcoded `/home/gustavo` path from `env.lua` in favor of `$HOME`.
- **2026-08-04** — Added `README.md` prerequisites/install docs, `CHANGELOG.md`, `.gitignore`;
  fixed `install.sh`'s executable bit (it was tracked as a non-executable file).
- **2026-07-31** — Added MIT License.
- **2026-07-25** — Migrated the Hyprland configuration from classic `hyprland.conf` / `conf.d/*.conf`
  (hyprlang) to native Lua (`hyprland.lua` + `config/*.lua`), ahead of hyprlang's planned deprecation.
- **2026-02-23** — Added MangoHud overlay config; switched the autostarted polkit agent from
  `hyprpolkitagent` to a direct `polkit-gnome-authentication-agent-1` exec; disabled window rounding.
- **2026-02-08** — Documented the desktop/notebook branch split in the README.
- **2026-01-26** — Added `install.sh` with the full `yay` package list; expanded README dependency docs.
- **2026-01-24** — Branch point: `notebook` diverges from `main` here (commit `cb2e671`).

## notebook

- **2026-08-06** — `install.sh` now clones and installs [minimal-neovim](https://github.com/gustavommcv/minimal-neovim)
  (own repo, not vendored here) into `~/.config/nvim`, plus its dependencies
  (`neovim`, `ripgrep`, `tree-sitter-cli`, `unzip`, `gcc`, `nodejs`, `npm`).
- **2026-08-05** — Filled in the actual repo URL in the README clone instructions.
- **2026-08-05** — Replaced `ly` with `greetd`/`greetd-tuigreet` as the login manager.
- **2026-08-05** — Backported the expanded root `README.md`, `CHANGELOG.md`, and the `waybar/README.md`
  `ags` dependency note from `main`.
- **2026-08-05** — Added the `keep-nautilus-and-pinentry-focused` window rule (present on `main`,
  lost here during the Lua migration — GPG/pinentry prompts were losing focus); set
  `disable_hyprland_logo = true` (had reverted to the migration template's `false` default).
- **2026-08-04** — Created this branch's own `install.sh` (previously had none at all); expanded
  `.gitignore` with the editor/OS-noise entries `main` already had; fixed `hypr/README.md`'s
  "GTK hard override" row, which still documented a `GTK_THEME` env var removed on 2026-07-30.
- **2026-08-04** — Restored `SUPER+SHIFT+H/J/K/L` (move window) keybindings, lost during the Lua
  migration; fixed `refresh-waybar.sh`, which only started a *stopped* bar instead of restarting
  a running one; dropped a hardcoded `/home/gustavo` path from `.zshrc`'s Bun `PATH` entry; removed
  a dead, typo'd local variable (`broser`) from `programs.lua`.
- **2026-07-31** — Added `.gitignore` (`.luarc.json`).
- **2026-07-30** — Removed the stale `GTK_THEME` environment override.
- **2026-07-29** — Removed NVM shell configuration; Node.js tooling moved to Bun.
- **2026-07-26** — Removed unused files; rewrote `hypr/README.md` with full dependency, theming and
  troubleshooting documentation; zsh updates (XDG-style `$ZCOMPDUMP` cache path, Bun PATH, arduino-cli alias).
- **2026-07-25** — Migrated the Hyprland configuration from classic hyprlang to native Lua (same day as
  the equivalent migration on `main`).
- **2026-02-08** — Simplified the Waybar refresh script; switched default browser to Google Chrome;
  documented the branch split; switched the mic-mute hardware key to the custom toggle script.
- **2026-01-25** — Enabled `hyprpolkitagent` + `nm-applet` autostart; added the Waybar Bluetooth module
  with an rfkill-unblock wrapper script.
- **2026-01-24** — Merged `main` into `notebook` (last full sync point, commit `699a099`).
- **2026-01-11** — Initial notebook-specific Hyprland and Waybar configs.

---

*Earlier history is shared between both branches — see `git log` prior to 2026-01-24 for the common base.*
