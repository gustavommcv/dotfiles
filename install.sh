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
    swayosd-git # AUR
    
    # Clipboard
    wl-clipboard wl-clip-persist clipse # AUR
    
    # Screenshots
    hyprshot hyprpicker # AUR
    
    # Connectivity
    nm-applet bluetui # AUR
    
    # Applications
    nautilus gnome-system-monitor brightnessctl evolution telegram-desktop
    google-chrome # AUR
    
    # Shell & Developer Tools
    zsh tmux nvm go psmisc procps-ng git

    # Neovim (config cloned separately below, from its own repo) + its
    # dependencies. nodejs/npm are needed even though nvm is already listed
    # above: nvm only puts node on PATH inside an interactive login shell via
    # lazy-loaded functions, but Neovim spawns LSP servers as raw subprocesses
    # that never go through that shell init, so they need a real system node.
    neovim ripgrep tree-sitter-cli unzip gcc nodejs npm

    # Fonts
    ttf-jetbrains-mono-nerd ttf-font-awesome noto-fonts-cjk
    
    # Login Manager
    greetd greetd-tuigreet
)

echo "Installing dotfiles dependencies..."
yay -S --needed "${PACKAGES[@]}"

echo "Linking dotfiles into place..."
for dir in hypr waybar rofi foot MangoHud; do
    [ -d "$dir" ] && ln -sfn "$(pwd)/$dir" "$HOME/.config/$dir"
done
ln -sf "$(pwd)/tmux/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$(pwd)/zsh/.zshrc" "$HOME/.zshrc"

# Neovim config lives in its own repo (not this one) so it can be versioned and
# updated independently — see https://github.com/gustavommcv/minimal-neovim.
# Only clone if absent, so this script never overwrites local edits or an
# in-progress `:Lazy sync`.
NVIM_CONFIG_DIR="$HOME/.config/nvim"
if [ ! -d "$NVIM_CONFIG_DIR" ]; then
    echo "Cloning minimal-neovim config..."
    git clone https://github.com/gustavommcv/minimal-neovim.git "$NVIM_CONFIG_DIR"
else
    echo "$NVIM_CONFIG_DIR already exists, skipping clone (update manually with git -C \"$NVIM_CONFIG_DIR\" pull)."
fi
