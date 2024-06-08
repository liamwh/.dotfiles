-- Pull in the wezterm API
local wezterm = require("wezterm")
local config = wezterm.config_builder and wezterm.config_builder() or {}

config.color_scheme = "ayu"
config.font = wezterm.font("JetBrains Mono")
config.harfbuzz_features = { "liga=1" }

local os_name = wezterm.target_triple
if os_name:find("linux") then
	config.enable_wayland = false
	config.default_prog = { "zellij" }
elseif os_name:find("windows") then
	config.default_prog = { "wsl.exe" }
elseif os_name:find("apple") then
	config.default_prog = { "zellij" }
end

config.keys = {
	{ key = "Space", mods = "SHIFT", action = wezterm.action({ SendString = " " }) },
}
config.use_dead_keys = false
config.adjust_window_size_when_changing_font_size = false
-- Set to window decorations to "NONE" if enabled wayland is set to false on linux when actually using wayland and getting weird text glitching
-- config.window_decorations = "NONE"
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true

-- finally, return the configuration to wezterm
return config
