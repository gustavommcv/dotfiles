# Dotfiles

![License](https://img.shields.io/badge/license-MIT-2E6E71)
![Platform](https://img.shields.io/badge/platform-Arch%20Linux-1793D1)
![WM](https://img.shields.io/badge/WM-Hyprland-58E1FF)

Welcome to my personal dotfiles configuration. This repository contains the configuration files for my Linux environment, centered around Hyprland.

## Branches

This repository maintains three configurations in separate branches, one per machine/environment:

- **`main`** *(this branch)*: Dedicated to my **Desktop** configuration — full Hyprland desktop.
- **`notebook`**: Dedicated to my **Notebook** configuration — see its own README for hardware-specific notes (touchpad gestures, battery/idle timers, dark-theme forcing for Qt/GTK apps).
- **`wsl`**: Arch Linux under **WSL2** — no display server of its own (WSLg handles GUI passthrough), so the entire Hyprland/Waybar/Rofi stack is dropped in favor of a terminal-only setup. See its own README for what's kept and why.

`main` and `notebook` share the same base layout; differences are limited to files that genuinely depend on the machine (touchpad input, power management, monitor layout) and are kept in sync otherwise. `wsl` is structurally different — it forked from `main` and removed everything that needs a compositor.

## Prerequisites

- **Distro**: Arch Linux or an Arch-based derivative (the package list in [install.sh](install.sh) assumes `pacman` + [`yay`](https://github.com/Jguer/yay) for AUR packages).
- **Hyprland ≥ 0.55.0** — this repo's config is written in Hyprland's native Lua format (`hyprland.lua`), which requires that version or newer. Classic `hyprland.conf`/hyprlang users would need to port these files first.
- `git` and `yay` installed before running the installer.

## Installation

```bash
git clone https://github.com/gustavommcv/dotfiles.git ~/dotfiles
cd ~/dotfiles
git checkout main   # or: notebook / wsl, depending on the machine — see Branches above
chmod +x install.sh # already tracked as executable, but harmless if re-run
./install.sh        # installs every package via yay, then symlinks configs into place
```

`install.sh` installs every package via `yay` and then symlinks each directory to its target —
no manual linking needed. For reference, this is what it links:

| Repo path | Target |
|---|---|
| `hypr/` | `~/.config/hypr/` |
| `waybar/` | `~/.config/waybar/` |
| `rofi/` | `~/.config/rofi/` |
| `foot/` | `~/.config/foot/` |
| `MangoHud/` (main only) | `~/.config/MangoHud/` |
| `tmux/.tmux.conf` | `~/.tmux.conf` |
| `zsh/.zshrc` | `~/.zshrc` |

## Structure

- **[Hyprland](hypr/)**: Window manager configuration, including keybindings, window rules, and startup scripts.
- **[Waybar](waybar/)**: Status bar configuration.
- **[Rofi](rofi/)**: Application launcher and menu configuration.
- **[Foot](foot/)**: Terminal emulator configuration.
- **[Tmux](tmux/)**: Terminal multiplexer configuration.
- **[Zsh](zsh/)**: Shell configuration.
- **[MangoHud](MangoHud/)** *(main only)*: Vulkan/OpenGL performance overlay for gaming.

## Editor

Neovim isn't tracked in this repo — `install.sh` clones the config from its own repo,
[minimal-neovim](https://github.com/gustavommcv/minimal-neovim), into `~/.config/nvim`, along
with `neovim`, `ripgrep`, `tree-sitter-cli`, `unzip`, `gcc`, and `nodejs`/`npm` (needed for several
LSP servers/formatters regardless of `nvm`, since Neovim spawns them outside any login shell).
Kept separate so the editor config can be versioned and updated on its own; see that repo for
plugins, keymaps, and full dependency docs. Only clones if `~/.config/nvim` doesn't already
exist — re-running `install.sh` never overwrites local edits there.

## Key Features

- **Hyprland Window Manager**: A dynamic tiling window manager with fluid animations.
- **Custom Scripts**:
    - **Microphone Toggle**: `Alt+M` (and the hardware mic-mute key) toggles the microphone with an audio cue.
    - **Toggle Menu**: `Super+Space` launches the application menu (Rofi).
- **SwayOSD Integration**: Elegant on-screen display for volume, brightness, and toggle states.
- **Foot Terminal**: A fast, lightweight and minimalistic Wayland terminal emulator.

## Look and feel

Dark throughout (`#111111`–`#161616` backgrounds), `JetBrains Mono Nerd Font` everywhere for UI chrome, `dwindle` tiling layout. `main` runs with animations, blur-free shadows off, and 2px borders on a 5/10px gap; `notebook` disables animations entirely to save battery. Waybar is split into left (workspaces, media), center (weather, clock) and right (tray, bluetooth, volume, notifications, power) partitions.
