local wezterm = require("wezterm")
local config = wezterm.config_builder()

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

config.color_scheme = "Catppuccin Mocha"
config.colors = {
	background = "#11111b",
	tab_bar = {
		background = "#11111b",
		active_tab = {
			bg_color = "#11111b",
			fg_color = "#cdd6f4",
			intensity = "Bold",
		},
		inactive_tab = {
			bg_color = "#11111b",
			fg_color = "#585b70",
		},
		inactive_tab_hover = {
			bg_color = "#181825",
			fg_color = "#a6adc8",
		},
		new_tab = {
			bg_color = "#11111b",
			fg_color = "#585b70",
		},
		new_tab_hover = {
			bg_color = "#18111b",
			fg_color = "#a6adc8",
		},
	},
}
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
	left = "1%",
	right = "1%",
	top = "1%",
	bottom = "1%",
}
config.window_close_confirmation = "NeverPrompt"

if wezterm.target_triple:find("darwin") then
	config.default_prog = { "/bin/zsh", "-l" }
	config.font_size = 13.0
	config.font = wezterm.font_with_fallback({
		"JetBrains Mono",
		"JetBrainsMono Nerd Font",
		"PingFang TC",
		"Sarasa Gothic TC",
	})
	config.window_background_opacity = 0.8
elseif wezterm.target_triple:find("windows") then
	config.default_prog = { "powershell.exe", "-NoLogo" }
	config.font_size = 11.0
	config.font = wezterm.font_with_fallback({
		"JetBrains Mono",
		"JetBrainsMono Nerd Font",
		"Sarasa Gothic TC",
		"Microsoft JhengHei",
		"Noto Sans Mono",
	})
	config.window_background_opacity = 0.8
elseif wezterm.target_triple:find("bsd") then
	config.default_prog = { "/bin/bash", "-l" }
	config.font_size = 10.0
	config.font = wezterm.font_with_fallback({
		"JetBrains Mono",
		"JetBrainsMono Nerd Font",
		"Sarasa Gothic TC",
		"Noto Sans Mono",
	})
	config.window_background_opacity = 1.0
else
	config.default_prog = { "/bin/bash", "-l" }
	config.font_size = 9.0
	config.font = wezterm.font_with_fallback({
		"JetBrains Mono",
		"JetBrainsMono Nerd Font",
		"Sarasa Gothic TC",
		"Noto Sans Mono",
	})
	config.window_background_opacity = 1.0
end

return config
