---------------------
---- KEYBINDINGS ----
---------------------

local programs = require("config.programs")

local mainMod = "SUPER"
local mainModShift = "SUPER + SHIFT"
local shiftCtrl = "SHIFT + CTRL"

-- Screenshots
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind(mainModShift .. " + PRINT", hl.dsp.exec_cmd("hyprshot -z -m output"))
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -z -m region"))

-- Lock screen and power menu
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainModShift .. " + ESCAPE", hl.dsp.exec_cmd("rofi -show power-menu -modi power-menu:rofi-power-menu"))

-- Applications and custom scripts
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(programs.terminal .. " -e clipse"))
hl.bind(shiftCtrl .. " + ESCAPE", hl.dsp.exec_cmd(programs.systemMonitor))
hl.bind("ALT + M", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-mic.sh"))
hl.bind(mainModShift .. " + W", hl.dsp.exec_cmd("~/.config/hypr/scripts/refresh-waybar.sh"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(programs.browser))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(programs.emailClient))
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(programs.terminal))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(programs.fileManager))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-menu.sh"))

-- Window and layout actions
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + G", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + S", hl.dsp.layout("togglesplit"))

-- Move focus with Super + H/J/K/L
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))

-- Move windows with Super + Shift + H/J/K/L
hl.bind(mainModShift .. " + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainModShift .. " + J", hl.dsp.window.move({ direction = "d" }))
hl.bind(mainModShift .. " + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainModShift .. " + L", hl.dsp.window.move({ direction = "r" }))

-- Switch workspaces and move the active window with Super + [0-9].
for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainModShift .. " + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scroll through existing workspaces.
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with Super + LMB/RMB and dragging.
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Multimedia keys.
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("swayosd-client --output-volume raise"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("swayosd-client --output-volume lower"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-mic.sh"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd("swayosd-client --brightness raise"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd("swayosd-client --brightness lower"),
	{ locked = true, repeating = true }
)

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
