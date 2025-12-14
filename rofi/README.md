# Rofi Configuration

This directory contains my Rofi configuration, customized to match the system's aesthetic.

## dependencies

- **Rofi**: The application launcher itself.
- **Fonts**: `JetBrains Mono Nerd Font` (or as defined in `shared/fonts.rasi`).

## Configuration

The configuration is modular:

- **`config.rasi`**: The main configuration file. Sets the mode to `drun` (application launcher), enables icons, and defines the window layout (fullscreen, transparent background).
- **`shared/colors.rasi`**: Defines the color palette (referencing the system theme).
- **`shared/fonts.rasi`**: Centralized font definition.

## Usage

- **Launch**: `Super+Space` (configured in Hyprland) triggers the `toggle-menu.sh` script, which opens Rofi.
- **Search**: Type to filter applications.
- **Navigate**: Use arrow keys or mouse to select an entry.

## Customization

- To change colors, edit `shared/colors.rasi`.
- To adjust the layout (size, transparency), modify the `window` and `element` sections in `config.rasi`.
