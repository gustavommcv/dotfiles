# Waybar Configuration

My personal Waybar configuration, featuring a partitioned layout (left, center, right) and custom styling.

## Dependencies

- **Fonts**: `JetBrains Mono Nerd Font` (General), `Martian Mono` (Workspaces/Windows)
- **Icons**: FontAwesome (or compatible Nerd Font)
- **Tools**:
  - `pavucontrol` (Audio control)
  - `wttrbar` (Weather module)
  - `swaync-client` (Notification center)

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
- **Clock**: Date and time.

### Right
- **Language**: Current keyboard layout (US/BR).
- **Tray**: System tray for background apps.
- **PulseAudio**: Volume control with mute toggle. Click opens `pavucontrol`.
- **Notifications**: SwayNC notification indicator.
- **Idle Inhibitor**: Toggle to prevent screen sleep (`eye` icon).

## Customization

To change colors or fonts, edit `style.css`. The bar is currently styled with a dark background (`#121212`) and light text (`#cdd6f4`).