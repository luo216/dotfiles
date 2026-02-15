local wezterm = require("wezterm")
local config = {
	font_size = 18,
	font = wezterm.font("Hack Nerd Font", { weight = "Regular" }),
	color_scheme = "Gruvbox dark, soft (base16)",

	use_fancy_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,
	window_decorations = "RESIZE",
	show_new_tab_button_in_tab_bar = false,
	adjust_window_size_when_changing_font_size = false,

	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},

	-- 设置启动时运行的命令
	default_prog = { "/bin/sh", "-c", "tmux a || fastfetch && exec $SHELL" },

	-- 添加快捷键配置
	keys = {
		-- 放大字体
		{
			key = "K",
			mods = "CTRL",
			action = wezterm.action.IncreaseFontSize,
		},
		-- 缩小字体
		{
			key = "J",
			mods = "CTRL",
			action = wezterm.action.DecreaseFontSize,
		},
		-- 重置字体大小
		{
			key = "O",
			mods = "CTRL",
			action = wezterm.action.ResetFontSize,
		},
	},
}

return config
