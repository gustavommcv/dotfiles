# Changelog

This repository tracks two long-lived branches (`main` for desktop, `notebook` for laptop) rather than
sequential releases, so this log is organized by branch and date rather than by version number. Entries
below start at the branches' last full sync point.

## main

- **2026-07-31** — Added MIT License.
- **2026-07-25** — Migrated the Hyprland configuration from classic `hyprland.conf` / `conf.d/*.conf`
  (hyprlang) to native Lua (`hyprland.lua` + `config/*.lua`), ahead of hyprlang's planned deprecation.
- **2026-02-23** — Added MangoHud overlay config; switched the autostarted polkit agent from
  `hyprpolkitagent` to a direct `polkit-gnome-authentication-agent-1` exec; disabled window rounding.
- **2026-02-08** — Documented the desktop/notebook branch split in the README.
- **2026-01-26** — Added `install.sh` with the full `yay` package list; expanded README dependency docs.
- **2026-01-24** — Branch point: `notebook` diverges from `main` here (commit `cb2e671`).

## notebook

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
