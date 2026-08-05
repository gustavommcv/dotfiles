# Hyprland Configuration

My personal Hyprland setup for an AMD laptop running Arch Linux. The configuration is written in
**Lua** (supported natively since Hyprland 0.5x) rather than the classic `hyprland.conf` syntax.

Tested against **Hyprland 0.56.0**.

## Structure

```
~/.config/hypr/
├── hyprland.lua          # Entry point — requires every module below
├── config/
│   ├── monitors.lua      # Display layout (auto-detect)
│   ├── programs.lua      # Default apps, exported for keybindings
│   ├── autostart.lua     # Processes launched on hyprland.start
│   ├── env.lua           # Environment variables (cursor, theming)
│   ├── look_and_feel.lua # Gaps, borders, decoration, layouts
│   ├── misc.lua          # Wallpaper / splash behaviour
│   ├── input.lua         # Keyboard layouts, touchpad, gestures
│   ├── keybindings.lua   # All binds
│   └── windows_and_workspaces.lua  # Window rules
├── hypridle.conf         # Idle / suspend timeouts
├── hyprlock.conf         # Lock screen
├── scripts/              # Helper scripts bound to keys
└── audios/               # Sound cues for the mic toggle
```

Modules are plain Lua and are loaded in order by [hyprland.lua](hyprland.lua). `config/programs.lua`
is the only one that **returns** a table — the others configure Hyprland via the `hl` API directly.

## Dependencies

- **Core**: `hyprland`, `hyprpolkitagent`, `xdg-desktop-portal-hyprland`, `xdg-desktop-portal-gtk`
- **Terminal**: `foot` (runs as `foot --server` / `footclient`)
- **Bar & Notifications**: `waybar`, `swaync`, `wttrbar`
- **Launcher**: `rofi`, `rofi-power-menu`
- **Lock & Idle**: `hyprlock`, `hypridle`
- **Audio & Media**: `pavucontrol`, `playerctl`, `swayosd`
- **Clipboard**: `wl-clipboard`, `wl-clip-persist`, `clipse`
- **Screenshots**: `hyprshot`, `hyprpicker`
- **Network**: `network-manager-applet`
- **Bluetooth**: `bluetui`
- **System**: `nautilus`, `gnome-system-monitor`, `btop`, `brightnessctl`
- **Browser / Mail**: `google-chrome`, `evolution`
- **Theming**: `adw-gtk3`, `papirus-icon-theme`, `qt6ct`, `kvantum`, `nwg-look`
- **Fonts**: `font-awesome`, `noto-fonts-cjk`
- **Login**: `greetd`, `greetd-tuigreet` (default greeter config, not tracked in this repo)
- **Optional**: `discord`, `telegram-desktop` (autostarted, see below)

## Dark theme

Getting **every** toolkit to honour dark mode takes three independent layers. Two of them live
outside this repository (`~/.config/gtk-*`, `~/.config/qt6ct`) and are **not versioned here** — on a
fresh machine they have to be recreated.

| Layer | Where | Value |
|---|---|---|
| GTK theme + icons | `~/.config/gtk-3.0/settings.ini`, `gtk-4.0/settings.ini`, `~/.gtkrc-2.0` | `adw-gtk3-dark` / `Papirus-Dark` |
| GTK via gsettings | `org.gnome.desktop.interface` | `color-scheme=prefer-dark`, `gtk-theme=adw-gtk3-dark` |
| Qt | [config/env.lua](config/env.lua) | `QT_QPA_PLATFORMTHEME=qt6ct`, `QT_STYLE_OVERRIDE=kvantum` |

The gsettings values can be restored with:

```bash
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3-dark"
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
```

A previous revision of this config also forced `GTK_THEME=adw-gtk3-dark` in `env.lua` to catch
XWayland clients and GTK context menus (notably the `nm-applet` tray right-click menu) that ignore
gsettings — that override was deliberately removed; if those surfaces render light again, that's
the first thing to reintroduce. Changes to `env.lua` require a **full Hyprland restart**, not a reload.

Electron apps (Discord, Claude Desktop) do **not** follow system theming — each has its own
in-app appearance setting.

## Idle, lock & suspend

Timeouts are defined in [hypridle.conf](hypridle.conf), each cumulative from the last input event:

| Timeout | Action |
|---|---|
| 2.5 min | Dim backlight to minimum (`brightnessctl -s set 10`) |
| 5 min | Lock session (`hyprlock`) |
| 5.5 min | Turn off displays (`dpms off`) |
| 8 min | `systemctl suspend` |

`hypridle` is started by [config/autostart.lua](config/autostart.lua), not by systemd — its user
unit is intentionally left disabled. If suspend stops working, check that exactly one instance is
alive (`pgrep -a hypridle`) and restart it with `setsid -f hypridle`.

## Keybindings

`SUPER` is the main modifier.

### Applications

| Bind | Action |
|---|---|
| `SUPER + RETURN` | Terminal (`footclient`) |
| `SUPER + B` | Browser |
| `SUPER + M` | Email client |
| `SUPER + F` | File manager |
| `SUPER + SPACE` | Toggle Rofi launcher |
| `SUPER + V` | Clipboard history (`clipse`) |
| `SHIFT + CTRL + ESCAPE` | System monitor (`btop`) |

### Session

| Bind | Action |
|---|---|
| `SUPER + ESCAPE` | Lock screen |
| `SUPER + SHIFT + ESCAPE` | Power menu |
| `SUPER + SHIFT + W` | Restart Waybar |

### Windows

| Bind | Action |
|---|---|
| `SUPER + Q` | Close window |
| `SUPER + G` | Toggle floating |
| `SUPER + P` | Pseudo tile |
| `SUPER + S` | Toggle split (dwindle) |
| `SUPER + H/J/K/L` | Move focus (vim directions) |
| `SUPER + LMB / RMB` | Drag / resize window |

### Workspaces

| Bind | Action |
|---|---|
| `SUPER + [0-9]` | Switch to workspace |
| `SUPER + SHIFT + [0-9]` | Move window to workspace |
| `SUPER + scroll` | Cycle workspaces |
| 3-finger swipe | Cycle workspaces |

### Screenshots

| Bind | Action |
|---|---|
| `PRINT` | Region (copied to clipboard) |
| `SUPER + PRINT` | Active window |
| `SUPER + SHIFT + PRINT` | Full output (clipboard) |

Saved to `$HYPRSHOT_DIR` (`~/Pictures/Screenshots`).

### Media

Standard `XF86` keys drive volume, mic, brightness and playback through `swayosd-client` and
`playerctl`. All are `locked`, so they keep working on the lock screen.

## Input

- Layouts: `us` and `br` (abnt2) — toggle with `ALT + SHIFT`
- Caps Lock acts as **Ctrl** (`ctrl:nocaps`)
- Natural scrolling enabled; typing does *not* disable the touchpad

## Look and feel

Deliberately minimal: **animations, blur, shadows and rounding are all disabled**, borders are 2px
with 5px inner / 10px outer gaps. Layout is `dwindle` with `preserve_split`.

## Scripts

Located in `scripts/`. Ensure they are executable (`chmod +x scripts/*.sh`).

- **`toggle-mic.sh`** (`Alt+M`, `XF86AudioMicMute`) — toggles the default source mute state and
  plays a Discord-style audio cue from `audios/`.
- **`toggle-menu.sh`** (`Super+Space`) — opens Rofi in drun mode, or closes it if already running.
- **`refresh-waybar.sh`** (`Super+Shift+W`) — restarts the bar.

## Troubleshooting

### SwayOSD Caps Lock popup

If you use Caps Lock as a modifier (as this config does) and want to suppress the OSD popup:

```bash
sudo systemctl disable --now swayosd-libinput-backend.service
```

### An app is still light-themed

Check which toolkit it uses. GTK apps should respond to `GTK_THEME`; Qt apps need `qt6ct` to have an
actual configuration file (`~/.config/qt6ct/qt6ct.conf`) with a dark style selected — the
environment variable alone does nothing if qt6ct was never opened and configured. Electron apps are
themed in-app.

### System does not suspend on idle

`hypridle` may have died — it is not supervised by systemd. Verify with `pgrep -a hypridle`.
Note that applications can hold idle inhibitors; inspect them with `systemd-inhibit --list` and
`hyprctl clients -j | grep inhibitingIdle`.

### Keyboard backlight listener fails

[hypridle.conf](hypridle.conf) contains a listener targeting `rgb:kbd_backlight`. This device does
not exist on every machine (`brightnessctl -l` will tell you). When absent, the command simply
fails without side effects — comment the block out to silence it.
