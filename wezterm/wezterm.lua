local wezterm = require("wezterm")
local config = wezterm.config_builder()
local platform = wezterm.target_triple

if platform:find("windows") then
	config.default_prog = { "powershell.exe", "-NoLogo" }
	config.font_size = 10.0
	config.font = wezterm.font_with_fallback({
		"JetBrains Mono",
		"JetBrainsMono Nerd Font",
		"Noto Sans CJK TC",
		"Noto Color Emoji",
	})
elseif platform:find("apple") then
	config.default_prog = { "/bin/zsh", "-l" }
	config.font_size = 13.0
	config.font = wezterm.font_with_fallback({
		"Monaco",
		"PingFang TC",
		"Apple Color Emoji",
	})
elseif platform:find("linux") then
	config.default_prog = { "/bin/bash", "-l" }
	config.font_size = 11.0
	config.font = wezterm.font_with_fallback({
		"JetBrains Mono",
		"JetBrainsMono Nerd Font",
		"Noto Sans CJK TC",
		"Noto Color Emoji",
	})
else
	config.default_prog = { "/bin/bash", "-l" }
	config.font_size = 11.0
	config.font = wezterm.font_with_fallback({
		"JetBrains Mono",
		"Noto Sans CJK TC",
		"Noto Color Emoji",
	})
end

config.default_cwd = wezterm.home_dir
config.line_height = 1.2
config.cursor_blink_rate = 0
config.default_cursor_style = "SteadyBar"
config.color_scheme = "Catppuccin Mocha"
config.colors = {
	background = "#11111b",
}
config.scrollback_lines = 5000
config.window_padding = {
	left = 20,
	right = 20,
	top = 20,
	bottom = 20,
}
config.initial_cols = 120
config.initial_rows = 40
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.window_close_confirmation = "NeverPrompt"

return config
