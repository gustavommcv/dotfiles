# Hyprland Configuration

This directory contains my personal Hyprland configuration.

## Dependencies

The following packages are required for the full experience:

- **Core**: `hyprland`, `hyprpolkitagent`, `xdg-desktop-portal-hyprland`
- **Terminal**: `foot`
- **Bar & Notifications**: `waybar`, `swaync`, `wttrbar`
- **Launcher**: `rofi`
- **Lock & Idle**: `hyprlock`, `hypridle`
- **Audio & Media**: `pavucontrol`, `playerctl`, `swayosd`
- **Clipboard**: `wl-clipboard`, `wl-clip-persist`, `clipse`
- **Screenshots**: `hyprshot`, `hyprpicker`
- **Wifi**: `nm-applet`
- **Bluetooth**: `bluetui`
- **System**: `nautilus`, `gnome-system-monitor`, `brightnessctl`
- **Fonts**: `font-awesome`, `noto-fonts-cjk`
- **Login**: `ly`

## Scripts

Custom scripts are located in `scripts/`. Ensure they are executable (`chmod +x scripts/*.sh`).

- **`toggle-mic.sh`** (`Alt+M`):
  Toggles the default microphone mute state. triggers a visually distinct OSD notification via `swayosd` and plays a custom audio cue.

- **`toggle-menu.sh`** (`Super+Space`):
  Toggles the Rofi application launcher. If Rofi is already running, it closes it; otherwise, it opens the drun mode.

## Troubleshooting

### SwayOSD Caps Lock Popup
If you use Caps Lock as a modifier (e.g., Ctrl) and want to disable the OSD popup when pressing it, disable the backend service:
```bash
sudo systemctl disable --now swayosd-libinput-backend.service
```
