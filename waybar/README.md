# Waybar Configuration

My personal Waybar configuration, featuring a partitioned layout (left, center, right) and custom styling.

## Dependencies

- **Fonts**: `JetBrains Mono Nerd Font` (General), `Martian Mono` (Workspaces/Windows)
- **Icons**: FontAwesome (or compatible Nerd Font)
- **Tools**:
  - `pavucontrol` (Audio control)
  - `bluetui` (Bluetooth TUI)
  - `wttrbar` (Weather module)
  - `swaync-client` (Notification center)
  - `ags` (Aylur's GTK Shell, `aylurs-gtk-shell-git` on the AUR) — powers the `ActivityCenter` widget opened from the clock. ⚠️ Upstream AGS v1 (what this AUR package tracks) was superseded by a v2 scaffolding tool for the Astal framework in late 2024; v1 now survives only through community forks. Revisit this dependency if `ags -t ActivityCenter` stops working after a system update.

## Configuration

The configuration is split into:
- **`config.jsonc`**: Defines the layout and active modules. Imports `modules.json`.
- **`modules.json`**: Detailed configuration for each module (icons, intervals, scripts).
- **`style.css`**: CSS styling for the bar and modules.

## Modules

### Left
- **Workspaces**: Hyprland workspaces with active/urgent indicators.
- **MPRIS**: Media player controls (`play-pause`, `next`, `prev`) with blinking animation when playing.

### Center
- **Weather**: Displays temperature using `wttrbar`.
- **Clock**: Date and time. Click opens the `ags`-powered ActivityCenter widget.

### Right
- **Language**: Current keyboard layout (US/BR).
- **Tray**: System tray for background apps.
- **Bluetooth**: Status indicator (on/off/connected). Click opens `bluetui`.
- **PulseAudio**: Volume control with mute toggle. Click opens `pavucontrol`.
- **Notifications**: SwayNC notification indicator.
- **Idle Inhibitor**: Toggle to prevent screen sleep (`eye` icon).

## Customization

To change colors or fonts, edit `style.css`. The bar is currently styled with a dark background (`#121212`) and light text (`#cdd6f4`).