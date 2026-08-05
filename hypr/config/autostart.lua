-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
	-- Default apps
	hl.exec_cmd("waybar")
	hl.exec_cmd("swaync")
	hl.exec_cmd("hypridle")

	-- Custom apps
	hl.exec_cmd("Telegram -startintray")

	-- OSD server
	hl.exec_cmd("swayosd-server")

	-- Clipboard history
	hl.exec_cmd("wl-clip-persist --clipboard regular")
	hl.exec_cmd("clipse -listen")

	-- Polkit
	hl.exec_cmd("systemctl --user start hyprpolkitagent")

	-- Applets
	hl.exec_cmd("nm-applet")
end)
