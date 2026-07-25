-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:

hl.on("hyprland.start", function ()
  -- Default apps
  hl.exec_cmd("waybar")
  hl.exec_cmd('swaync')
  hl.exec_cmd('hypridle')
  hl.exec_cmd('foot --server')
  hl.exec_cmd('swayosd-server')
  hl.exec_cmd('wl-clip-persist')
  hl.exec_cmd('clipse -listen')
  hl.exec_cmd('systemctl --user start hyprpolkitagent')
  hl.exec_cmd('nm-applet')

  -- Custom apps
  hl.exec_cmd('discord --start-minimized')
  hl.exec_cmd('Telegram -startintray')
end)
