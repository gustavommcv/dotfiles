---------------
---- INPUT ----
---------------

-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input
hl.config({
	input = {
		kb_layout = "us,br",
		kb_variant = ",abnt2",
		kb_model = "",
		kb_options = "ctrl:nocaps,grp:alt_shift_toggle",
		kb_rules = "",
		follow_mouse = 1,
		accel_profile = "flat",
		sensitivity = 0,
		touchpad = {
			natural_scroll = false,
		},
	},
})

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/
hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})
