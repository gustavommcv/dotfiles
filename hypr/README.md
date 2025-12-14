# Hyprland Configuration

This directory contains my personal Hyprland configuration.

## Dependencies

The following packages are required for the full experience:

- **Core**: `hyprland`, `hyprpolkitagent`, `xdg-desktop-portal-hyprland`
- **Terminal**: `ghostty`
- **Bar & Notifications**: `waybar`, `swaync`, `wttrbar`
- **Launcher**: `rofi`
- **Lock & Idle**: `hyprlock`, `hypridle`
- **Audio & Media**: `pavucontrol`, `playerctl`, `swayosd`
- **Clipboard**: `wl-clipboard`, `wl-clip-persist`, `clipse`
- **Screenshots**: `grim`, `slurp`, `satty`
- **System**: `nautilus`, `gnome-system-monitor`, `brightnessctl`
- **Fonts**: `font-awesome`, `noto-fonts-cjk`
- **Login**: `ly`

## Scripts

Custom scripts are located in `scripts/`. Ensure they are executable (`chmod +x scripts/*.sh`).

- **`toggle-mic.sh`** (`Alt+M`):
  Toggles the default microphone mute state. triggers a visually distinct OSD notification via `swayosd` and plays a custom audio cue.

- **`toggle-menu.sh`** (`Super+Space`):
  Toggles the Rofi application launcher. If Rofi is already running, it closes it; otherwise, it opens the drun mode.
