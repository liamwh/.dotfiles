-- Pull in the wezterm API
local wezterm = require("wezterm")
local config = wezterm.config_builder and wezterm.config_builder() or {}

config.font = wezterm.font("JetBrains Mono")
config.harfbuzz_features = { "liga=1" }
config.color_scheme = "Dracula"
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

local os_name = wezterm.target_triple
if os_name:find("linux") then
	config.enable_wayland = false
	config.default_prog = { "zellij" }
elseif os_name:find("windows") then
	config.default_prog = { "wsl.exe" }
elseif os_name:find("apple") then
	config.set_environment_variables = {
		PATH = os.getenv("PATH") .. ":/opt/homebrew/bin",
	}
	config.default_prog = { "zellij" }
end

config.keys = {
	{ key = "Space", mods = "SHIFT", action = wezterm.action({ SendString = " " }) },
	{
		key = "e",
		mods = "SUPER|SHIFT",                       -- SUPER is CMD on macOS
		action = wezterm.action.SendString("\x1b[13;5u"), -- This sends a special escape sequence
	},
}
config.use_dead_keys = false
config.adjust_window_size_when_changing_font_size = false
-- Set to window decorations to "NONE" if enabled wayland is set to false on linux when actually using wayland and getting weird text glitching
-- config.window_decorations = "NONE"
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true

-- finally, return the configuration to wezterm
return config
