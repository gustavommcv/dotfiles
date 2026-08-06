# Changelog

## wsl

- **2026-08-05** — Initial WSL branch: forked from `main` (commit `64d7b49`), removed the
  entire GUI/compositor stack (Hyprland, Waybar, Rofi, foot, MangoHud, and everything that
  only existed to serve them — portals, greetd, SwayNC/SwayOSD, bluetui, clipse, AGS), relocated
  the one script that's still genuinely generic (`toggle-mic.sh` + its audio cues) to a new
  top-level `scripts/` directory, added WSL-specific configs (`wsl/wsl.conf`, `wsl/.wslconfig`),
  and rewrote `install.sh` around the official pacman repositories instead of `yay`/AUR.

---

*This branch's history starts here — see `main`'s and `notebook`'s own `CHANGELOG.md` for their
history prior to this fork.*
