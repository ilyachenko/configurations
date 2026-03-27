local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- Theme
config.color_scheme = "Catppuccin Macchiato"

-- Opacity
config.window_background_opacity = 0.75
config.macos_window_background_blur = 20

-- Font (inherits system default; set explicitly if needed)
-- config.font = wezterm.font("JetBrains Mono")
-- config.font_size = 13.0

-- Padding (matches ghostty: 10px x, 10px top, 0 bottom)
config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 0,
}

-- Window chrome
config.window_decorations = "RESIZE" -- borderless but resizable on macOS

-- Scrollback
config.scrollback_lines = 100000

-- Bell
config.audible_bell = "SystemBeep"

-- Tab bar
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- Restore window state on startup
config.native_macos_fullscreen_mode = true

-- Ctrl+Click to open links (works inside tmux)
config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = act.OpenLinkAtMouseCursor,
		mouse_reporting = true,
	},
}

-- Keybindings
config.keys = {
	-- Shift+Enter → ESC + Enter (same as ghostty keybind)
	{
		key = "Enter",
		mods = "SHIFT",
		action = act.SendString("\x1b\r"),
	},
	-- Toggle always-on-top (mirrors cmd+alt+T in ghostty)
	{
		key = "t",
		mods = "CMD|ALT",
		action = wezterm.action_callback(function(window)
			local overrides = window:get_config_overrides() or {}
			if overrides.always_on_top then
				overrides.always_on_top = false
			else
				overrides.always_on_top = true
			end
			window:set_config_overrides(overrides)
		end),
	},
	-- Pane splits preserving cwd
	{
		key = "%",
		mods = "LEADER|SHIFT",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = '"',
		mods = "LEADER|SHIFT",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	-- Pane resize (mirrors tmux prefix+H/J/K/L concept, but direct in wezterm)
	{ key = "LeftArrow", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
	{ key = "RightArrow", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },
	{ key = "UpArrow", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
	{ key = "DownArrow", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
}

return config
