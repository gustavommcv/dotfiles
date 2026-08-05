---------------------
---- KEYBINDINGS ----
---------------------

local programs = require("config.programs")

local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local shiftMod = "SUPER + SHIFT"
local shiftCtrl = "SHIFT + CTRL"

---------------------
-- Custom bindings --
---------------------

-- Screenshot
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind(shiftMod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -z -m output"))
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -z -m region"))

-- Lock screen
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd("hyprlock"))

-- Power menu
hl.bind(shiftMod .. " + ESCAPE", hl.dsp.exec_cmd("rofi -show power-menu -modi power-menu:rofi-power-menu"))

-- Clipboard history
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(programs.terminal .. " -e clipse"))

-- System monitor
hl.bind(shiftCtrl .. " + ESCAPE", hl.dsp.exec_cmd(programs.systemMonitor))

-- Mute mic
hl.bind("ALT + M", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-mic.sh"))

-- Refresh waybar
hl.bind(shiftMod .. " + W", hl.dsp.exec_cmd("~/.config/hypr/scripts/refresh-waybar.sh"))

-- Browser
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(programs.browser))

-- Email client
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(programs.emailClient))

---------------------
--- Example binds -----> see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
---------------------

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(programs.terminal))

hl.bind(mainMod .. " + Q", hl.dsp.window.close())

hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(programs.fileManager))
hl.bind(mainMod .. " + G", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-menu.sh"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + S", hl.dsp.layout("togglesplit")) -- dwindle only

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Move windows with shiftMod + arrow keys
hl.bind(shiftMod .. " + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(shiftMod .. " + L", hl.dsp.window.move({ direction = "r" }))
hl.bind(shiftMod .. " + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(shiftMod .. " + J", hl.dsp.window.move({ direction = "d" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
-- hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
-- hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
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

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
