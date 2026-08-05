#!/usr/bin/env bash

# List of packages to install via yay
PACKAGES=(
    # Core & Window Manager
    hyprland hyprlock hypridle hyprpolkitagent xdg-desktop-portal-hyprland xdg-desktop-portal-gtk

    # Terminal & System Monitor
    foot btop

    # Bar, Notifications & UI
    waybar swaync
    wttrbar aylurs-gtk-shell-git # AUR

    # Launcher
    rofi rofi-power-menu

    # Audio & Media
    pavucontrol playerctl
    swayosd # stable release since v0.2.0, no need for the -git AUR package

    # Clipboard
    wl-clipboard wl-clip-persist clipse # AUR

    # Screenshots
    hyprshot hyprpicker # AUR

    # Connectivity
    network-manager-applet bluetui # AUR

    # Applications
    nautilus gnome-system-monitor brightnessctl evolution telegram-desktop discord
    google-chrome # AUR

    # Theming (dark mode across GTK/Qt, see hypr/README.md)
    adw-gtk3 papirus-icon-theme qt6ct kvantum nwg-look # adw-gtk3, kvantum, nwg-look are AUR

    # Shell & Developer Tools
    zsh tmux go psmisc procps-ng git
    bun-bin arduino-cli # AUR (bun-bin) — Node tooling on this machine uses Bun, not NVM

    # Fonts
    ttf-jetbrains-mono-nerd ttf-font-awesome noto-fonts-cjk

    # Login Manager
    greetd greetd-tuigreet
)

echo "Installing dotfiles dependencies..."
yay -S --needed "${PACKAGES[@]}"

echo "Linking dotfiles into place..."
for dir in hypr waybar rofi foot; do
    [ -d "$dir" ] && ln -sfn "$(pwd)/$dir" "$HOME/.config/$dir"
done
ln -sf "$(pwd)/tmux/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$(pwd)/zsh/.zshrc" "$HOME/.zshrc"
