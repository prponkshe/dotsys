local wezterm = require("wezterm")

return {
  enable_wayland = true,
  font_size = 13,

  -- UI
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = false,
  window_decorations = "NONE",
  window_padding = { left = 6, right = 6, top = 6, bottom = 6 },
  color_scheme = 'Gruvbox Dark (Gogh)',

  -- Cursor
  default_cursor_style = "BlinkingBlock",
  cursor_blink_rate = 500,

  -- Clipboard
  keys = {
    { key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
    { key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
  },

  use_ime = false,
}
