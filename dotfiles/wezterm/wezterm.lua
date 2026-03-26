-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font_size = 11
config.font = wezterm.font("JetBrainsMonoNLNerdFont")
config.color_scheme = 'Kanagawa (Gogh)'

config.window_decorations = "RESIZE"
config.enable_tab_bar = false


config.default_prog = { 'zellij' }

-- Finally, return the configuration to wezterm:
return config
