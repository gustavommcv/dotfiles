![image](https://github.com/user-attachments/assets/7a38bd7b-7745-42ba-b098-1b8956c6a236)

# Script Security Note
**Always review scripts before granting execute permissions!**  
Never run `chmod +x` on scripts without first:
1. Checking their contents (`cat ~/.config/hypr/scripts/script.sh`)
2. Understanding what they do

## Permission Requirements
```bash
# Grant execute permission AFTER reviewing:
chmod +x ~/.config/hypr/scripts/*
```

## Waybar settings
https://github.com/gustavommcv/WaybarSettings-Hyprland

## Rofi settings
https://github.com/gustavommcv/Rofi-Settings

## My dependencies:
- hyprland
- pavucontrol
- xdg-desktop-portal-hyprland
- wl-clipboard
- nautilus
- kitty
- rofi
- waybar
- hyprpaper
- swaync
- hypridle
- clipse
- hyprspace (optional - inactive by default)
- hyprshot
- hyprlock
- gnome-system-monitor
- brightnessctl
- playerctl
- font-awesome
- noto-fonts-cjk
