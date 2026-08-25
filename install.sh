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

    # Neovim (config cloned separately below, from its own repo) + its
    # dependencies. gcc comes from base-devel above, already covering the C
    # compiler requirement; go, nodejs and npm still need to be listed
    # explicitly for gopls/goimports and several Mason-installed LSP
    # servers/formatters.
    neovim ripgrep tree-sitter-cli unzip nodejs npm go

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

# Installing the zsh package doesn't make it your login shell — that's a separate
# /etc/passwd change. Hardcoded to /usr/bin/zsh instead of `command -v zsh`: on Arch's
# merged-usr layout /usr/sbin is just a symlink to /usr/bin, so PATH order can make
# `command -v` resolve to /usr/sbin/zsh — same file, but chsh matches /etc/shells by
# exact string, and only /usr/bin/zsh is listed there (added by the zsh package itself).
# Only touch it if it isn't already set, so re-running this script doesn't re-prompt for
# a password every time.
zsh_path="/usr/bin/zsh"
current_shell="$(getent passwd "$USER" | cut -d: -f7)"
if [ "$current_shell" != "$zsh_path" ]; then
    echo "Setting zsh as your login shell (you'll be prompted for your password)..."
    chsh -s "$zsh_path"
fi

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

cat <<'EOF'

Package install and symlinks done. Two files still need a manual copy — see README.md
for details, they can't be symlinked from a user-owned repo:
  - wsl/wsl.conf     -> /etc/wsl.conf              (root-owned, Linux side)
  - wsl/.wslconfig   -> %USERPROFILE%\.wslconfig   (Windows side, outside this filesystem)

If your shell just changed to zsh, open a new terminal (or `wsl --shutdown` from
PowerShell then reopen the distro) for it to take effect.
EOF
