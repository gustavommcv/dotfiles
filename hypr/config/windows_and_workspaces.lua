--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	name = "round-foot-windows",
	match = { class = "foot" },
	rounding = 10,
})

hl.window_rule({
	name = "tag-foot-windows",
	match = { class = "foot" },
	tag = "+term",
})

hl.window_rule({
	name = "keep-nautilus-and-pinentry-focused",
	match = { class = "(nautilus|pinentry-.*)" },
	stay_focused = true,
})
