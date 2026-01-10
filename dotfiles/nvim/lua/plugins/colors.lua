-- return {
-- 	"neanias/everforest-nvim",
-- 	lazy = false,
-- 	priority = 1000,
--
-- 	config = function()
-- 		vim.cmd("colorscheme everforest")
-- 		vim.g.everforest_enable_italic = 1 -- Italic keywords and comments
-- 		vim.g.everforest_disable_italic_comment = 0
-- 		vim.g.everforest_better_performance = 1 -- Disable some features for speed
-- 		vim.g.everforest_background = "hard"
-- 		vim.cmd([[
--   highlight Normal guibg=#1e2326
--   highlight NormalFloat guibg=#1e2326
--   highlight FloatBorder guibg=#1e2326
-- ]])
-- 	end,
-- }
return {
	"ellisonleao/gruvbox.nvim",
	lazy = false,
	priority = 1000,

	config = function()
		vim.cmd("colorscheme gruvbox")
		vim.g.gruvbox_italic = 1 -- Italic keywords and comments
		vim.g.gruvbox_contrast_dark = "hard"
		vim.g.gruvbox_bold = 1
		vim.cmd([[
  highlight Normal guibg=#1d2021
  highlight NormalFloat guibg=#1d2021
  highlight FloatBorder guibg=#1d2021
  ]])
	end,
}
