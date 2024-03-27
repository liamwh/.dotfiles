-- Pull in the wezterm API
local wezterm = require("wezterm")
local config = wezterm.config_builder and wezterm.config_builder() or {}

config.color_scheme = "ayu"
config.font = wezterm.font("JetBrains Mono")
config.harfbuzz_features = { "liga=1" }

local os_name = wezterm.target_triple
if os_name:find("linux") then
	config.enable_wayland = false
elseif os_name:find("windows") then
	config.default_prog = { "wsl.exe" }
end

config.keys = {
	{ key = "Space", mods = "SHIFT", action = wezterm.action({ SendString = " " }) },
}
config.use_dead_keys = false
config.adjust_window_size_when_changing_font_size = false
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true

-- finally, return the configuration to wezterm
return config
