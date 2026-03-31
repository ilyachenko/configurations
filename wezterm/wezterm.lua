local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- Persist and restore window geometry across restarts
local state_file = os.getenv("HOME") .. "/.local/state/wezterm/window_state.json"

local function save_window_state(window)
	local dims = window:get_dimensions()
	local ok, json = pcall(wezterm.json_encode, {
		width = dims.pixel_width,
		height = dims.pixel_height,
		is_full_screen = dims.is_full_screen,
	})
	if ok then
		os.execute("mkdir -p " .. os.getenv("HOME") .. "/.local/state/wezterm")
		local f = io.open(state_file, "w")
		if f then
			f:write(json)
			f:close()
		end
	end
end

local function load_window_state()
	local f = io.open(state_file, "r")
	if f then
		local data = f:read("*a")
		f:close()
		local ok, state = pcall(wezterm.json_parse, data)
		if ok then
			return state
		end
	end
	return nil
end

wezterm.on("gui-startup", function(cmd)
	local state = load_window_state()
	local tab, pane, window
	if state then
		local mux = wezterm.mux
		tab, pane, window = mux.spawn_window(cmd or {
			width = math.floor(state.width / 8),
			height = math.floor(state.height / 16),
		})
		window:gui_window():set_inner_size(state.width, state.height)
		if state.is_full_screen then
			window:gui_window():toggle_fullscreen()
		end
	end
end)

wezterm.on("window-resized", function(window)
	save_window_state(window)
end)

-- Theme
config.color_scheme = "Kanagawa (Gogh)"

-- Opacity
config.window_background_opacity = 0.85
config.macos_window_background_blur = 25

-- Font
config.font_size = 13.0

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
	-- Cmd+Left/Right → beginning/end of line (Home/End equivalent)
	{ key = "LeftArrow", mods = "CMD", action = act.SendKey({ key = "a", mods = "CTRL" }) },
	{ key = "RightArrow", mods = "CMD", action = act.SendKey({ key = "e", mods = "CTRL" }) },
	-- Option+Left/Right → jump by word
	{ key = "LeftArrow", mods = "OPT", action = act.SendString("\x1bb") },
	{ key = "RightArrow", mods = "OPT", action = act.SendString("\x1bf") },
	-- Copy and clear selection
	{
		key = "c",
		mods = "CTRL|SHIFT",
		action = act.Multiple({
			act.CopyTo("Clipboard"),
			act.ClearSelection,
		}),
	},
	-- Pane resize (mirrors tmux prefix+H/J/K/L concept, but direct in wezterm)
	{ key = "LeftArrow", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
	{ key = "RightArrow", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },
	{ key = "UpArrow", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
	{ key = "DownArrow", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
}

return config
