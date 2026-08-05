#!/usr/bin/env bash

# List of packages to install via yay
PACKAGES=(
    # Core & Window Manager
    hyprland hyprlock hypridle hyprpolkitagent xdg-desktop-portal-hyprland
    
    # Terminal & System Monitor
    foot btop
    
    # Bar, Notifications & UI
    waybar swaync 
    wttrbar aylurs-gtk-shell-git # AUR
    
    # Launcher
    rofi rofi-power-menu
    
    # Audio & Media
    pavucontrol playerctl
    swayosd-git # AUR
    
    # Clipboard
    wl-clipboard wl-clip-persist clipse # AUR
    
    # Screenshots
    hyprshot hyprpicker # AUR
    
    # Connectivity
    nm-applet bluetui # AUR
    
    # Applications
    nautilus gnome-system-monitor brightnessctl evolution telegram-desktop
    
    # Shell & Developer Tools
    zsh tmux nvm go psmisc procps-ng git
    
    # Fonts
    ttf-jetbrains-mono-nerd ttf-font-awesome noto-fonts-cjk
    
    # Login Manager
    ly
)

echo "Installing dotfiles dependencies..."
yay -S --needed "${PACKAGES[@]}"
