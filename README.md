# Dotfiles — `wsl` branch

![License](https://img.shields.io/badge/license-MIT-2E6E71)
![Platform](https://img.shields.io/badge/platform-WSL2%20Arch%20Linux-1793D1)

This is the WSL2 branch of my personal dotfiles. `main` and `notebook` target real Hyprland
desktops with their own display server; this branch targets **Arch Linux running inside WSL2**,
which has no display server, compositor, or login manager of its own — [WSLg](https://github.com/microsoft/wslg)
handles GUI passthrough and Windows manages the session. Everything here is terminal/shell-only.

## Prerequisites

- **Windows 11** (or Windows 10 with a recent WSL update) with WSL2 enabled.
- **Official Arch Linux WSL image**, installed with:
  ```powershell
  wsl --install archlinux
  ```
  (or `wsl --install --from-file <rootfs>` for a manual image — see the
  [Arch Wiki](https://wiki.archlinux.org/title/Install_Arch_Linux_on_WSL)).
- `git` (to clone this repo) and `sudo` access (for `pacman`) inside the guest — everything else,
  including `base-devel`, is installed by `install.sh` itself, since a fresh Arch WSL image ships
  with a minimal package set.

## Installation

```bash
git clone https://github.com/gustavommcv/dotfiles.git ~/dotfiles
cd ~/dotfiles
git checkout wsl
chmod +x install.sh # already tracked as executable, but harmless if re-run
./install.sh         # installs packages via pacman, symlinks configs, sets zsh as your login shell
```

`install.sh` also runs `chsh` to make zsh your default login shell (only if it isn't already, so
re-running the script won't re-prompt for your password) — open a new terminal afterward, or
`wsl --shutdown` from PowerShell then reopen the distro, for it to take effect.

`install.sh` only uses the official pacman repositories — see [`install.sh`](install.sh) for why,
and how to build an AUR package manually if you ever need one. That means it deliberately does
**not** install Oh My Zsh (no official pacman/AUR package for it, just an upstream curl-pipe-to-shell
script) even though `.zshrc` requires it — do that manually, then grab the two plugins `.zshrc`
also expects:

```bash
KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

`--unattended` stops the installer from launching its own shell or touching your login shell —
`install.sh` already handled that via `chsh`. **`KEEP_ZSHRC=yes` is not optional here**: by
default the OMZ installer backs up and *replaces* any existing `~/.zshrc` with its own template —
since `install.sh` already symlinked ours into place, running the installer without this flag
clobbers the symlink with OMZ's default `.zshrc` (you'd get its stock content back instead of this
repo's config). If that already happened to you, re-run `ln -sf "$(pwd)/zsh/.zshrc" "$HOME/.zshrc"`
from inside `~/dotfiles` to restore it — no data lost, the original backup OMZ makes
(`~/.zshrc.pre-oh-my-zsh-*`) is just a copy of the same symlink anyway.

Skipping the Oh My Zsh install entirely doesn't break the shell, but you'll see
`.zshrc:79: no such file or directory: .oh-my-zsh/oh-my-zsh.sh` on every prompt until it's done.

Two files can't be part of the symlink loop and need a one-time manual copy. Run both from
**inside WSL** (where you already are for the steps above) — `/mnt/c/` is how WSL sees your
Windows `C:` drive, so there's no need to switch to PowerShell or deal with `\\wsl$\` paths:

```bash
sudo cp wsl/wsl.conf /etc/wsl.conf

# Replace <win-username> with your Windows account name (the folder name under C:\Users\).
# Not sure what it is? Run: cmd.exe /c echo %USERNAME%
cp wsl/.wslconfig "/mnt/c/Users/<win-username>/.wslconfig"
```

`.wslconfig` changes only take effect after a full WSL restart — run `wsl --shutdown` from
PowerShell (not just closing the terminal window), then reopen your distro.

## Structure

| Repo path | Target | Notes |
|---|---|---|
| `zsh/.zshrc` | `~/.zshrc` | Shell config — same as main/notebook, no GUI dependency |
| `tmux/.tmux.conf` | `~/.tmux.conf` | Terminal multiplexer — same as main/notebook |
| `scripts/` | `~/.config/scripts/` | `toggle-mic.sh` (pactl/paplay only — works over WSLg's PulseAudio-compatible socket) + its two audio cues |
| `wsl/` | `~/.config/wsl/` (reference copy) | `wsl.conf` and `.wslconfig` — see below, both need a manual copy to their *real* location too |
| `LICENSE`, `CHANGELOG.md` | — | Not deployed, just repo metadata |

## Editor

Neovim isn't tracked in this repo — `install.sh` clones the config from its own repo,
[minimal-neovim](https://github.com/gustavommcv/minimal-neovim), into `~/.config/nvim`, along with
`neovim`, `ripgrep`, `tree-sitter-cli`, `unzip`, `nodejs`/`npm`, and `go` (`gcc` is already covered
by `base-devel`, listed above). Same reasoning as `main`/`notebook`: kept separate so the editor
config can be versioned and updated on its own, and only clones if `~/.config/nvim` doesn't already
exist. Purely terminal-based, so it needs nothing WSL-specific to work — confirmed working under
WSL by the config's own docs.

## What's not here (and why)

Everything below exists on `main`/`notebook` to serve a Wayland compositor that doesn't exist in
WSL2 — WSLg provides GUI passthrough to the Windows host directly, so none of it has a role to play:

| Removed | Reason |
|---|---|
| `hypr/` (Hyprland, hypridle, hyprlock, hyprshot, hyprpicker, hyprpolkitagent) | No Wayland compositor in WSL2 — Windows is the compositor via WSLg. |
| `waybar/` | Status bar reads Hyprland's IPC socket; meaningless without Hyprland. |
| `rofi/` | GUI launcher depends on a running compositor; use the Windows Start menu or a terminal launcher instead. |
| `foot/` | Wayland-only terminal; use Windows Terminal, WezTerm, or any GUI terminal via WSLg. |
| `MangoHud/` | Vulkan/OpenGL performance overlay — no native GPU games run inside the WSL guest. |
| `xdg-desktop-portal-hyprland`, `xdg-desktop-portal-gtk` | Portals broker access to the host's screen/files for sandboxed apps; WSL has no sandboxing story that needs them, and the Arch Wiki explicitly recommends skipping `xdg-desktop-portal-gtk` here (heavy, unnecessary dependency chain). |
| `greetd`/`greetd-tuigreet`, `ly` | No login manager — Windows starts the WSL session directly. |
| `swaync`, `swayosd` | Notification daemon and on-screen-display both require a Wayland compositor to render layer-shell surfaces into. |
| `bluetui` + `bluetooth-wrapper.sh` | Bluetooth hardware is owned and managed by Windows, not passed through to the WSL guest. |
| `clipse`, `wl-clip-persist` | WSL already bridges the clipboard with Windows natively; a Wayland clipboard history manager has nothing to listen to. |
| `aylurs-gtk-shell` (AGS) | GTK widget shell rendered by a compositor that isn't running here. |
| `wttrbar` | Weather module for Waybar, which is gone. |
| `toggle-menu.sh`, `refresh-waybar.sh` | Controlled Rofi/Waybar specifically — nothing left for them to control. |

`toggle-mic.sh` is the one script that survived: it only calls `pactl`/`paplay`, and WSLg exposes a
PulseAudio-compatible socket, so it still works. It moved to `scripts/` since `hypr/` is gone.

## WSL-specific configs

Two files in [`wsl/`](wsl/) aren't deployed by the usual symlink loop because they don't live
in `$HOME` on the Linux side at all:

- **[`wsl/wsl.conf`](wsl/wsl.conf)** → `/etc/wsl.conf` inside the guest (root-owned). Enables
  systemd, sets interop/automount options. Copy with `sudo cp`.
- **[`wsl/.wslconfig`](wsl/.wslconfig)** → `%USERPROFILE%\.wslconfig` on the **Windows** side.
  Optional, global to every WSL2 distro on the machine (not just this one) — memory/processor
  limits, WSLg GPU passthrough. Left fully commented out; uncomment only values you've decided
  on for your own hardware.

`install.sh` still symlinks `wsl/` into `~/.config/wsl/` for convenient reference/editing, but
that symlink is not what WSL/Windows actually read from — the manual copies above are what takes
effect.
