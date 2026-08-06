#!/usr/bin/env bash

# Installer for the `wsl` branch of this dotfiles repo — targets WSL2 running the
# official Arch Linux distro (`wsl --install archlinux`), not a bare-metal/VM install.
# See: https://wiki.archlinux.org/title/Install_Arch_Linux_on_WSL
#
# Unlike main/notebook, this script uses only the official pacman repositories — a
# fresh WSL Arch image has no AUR helper installed, and this environment doesn't need
# one for anything below. If you later need an AUR package, install `base-devel` (already
# in the list) plus `git`, then build it manually:
#   git clone https://aur.archlinux.org/<pkg>.git && cd <pkg> && makepkg -si

# List of packages to install via pacman
PACKAGES=(
    # Shell & core tools
    zsh tmux git base-devel

    # Remote access, sync, monitoring
    openssh rsync htop btop fastfetch

    # Opens URLs/files with the Windows-side default app (e.g. links from the terminal
    # open in the Windows browser) — essential for a GUI-less guest.
    xdg-utils

    # GPU acceleration through WSLg (Vulkan via the Dozen/DirectX12 translation layer).
    # Optional — skip if you don't run anything that benefits from it.
    mesa vulkan-dzn vulkan-icd-loader

    # Clipboard integration for any GUI app launched through WSLg
    wl-clipboard

    # Fonts
    ttf-jetbrains-mono-nerd
)

echo "Installing dotfiles dependencies..."
sudo pacman -S --needed "${PACKAGES[@]}"

echo "Linking dotfiles into place..."
for dir in wsl scripts; do
    [ -d "$dir" ] && ln -sfn "$(pwd)/$dir" "$HOME/.config/$dir"
done
ln -sf "$(pwd)/tmux/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$(pwd)/zsh/.zshrc" "$HOME/.zshrc"

cat <<'EOF'

Package install and symlinks done. Two files still need a manual copy — see README.md
for details, they can't be symlinked from a user-owned repo:
  - wsl/wsl.conf     -> /etc/wsl.conf              (root-owned, Linux side)
  - wsl/.wslconfig   -> %USERPROFILE%\.wslconfig   (Windows side, outside this filesystem)
EOF
