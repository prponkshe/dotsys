return {
	"neanias/everforest-nvim",
	name = "everforest",
	lazy = false,
	priority = 1000,

	init = function()
		vim.g.everforest_background = "hard"
	end,

	config = function()
		vim.cmd("colorscheme everforest")

		local hl = vim.api.nvim_set_hl

		hl(0, "Normal", { bg = "#1f2528" })
		hl(0, "NormalNC", { bg = "#1f2528" })

		-- Match all UI surfaces
		hl(0, "SignColumn", { bg = "#1f2528" })
		hl(0, "EndOfBuffer", { bg = "#1f2528", fg = "#1f2528" })
		hl(0, "NormalFloat", { bg = "#232a2e" })

		-- Cursor line (slightly above base)
		hl(0, "CursorLine", { bg = "#2a3135" })

		-- Visual selection
		hl(0, "Visual", { bg = "#3a2f38" })

		-- Optional: darker split borders
		hl(0, "VertSplit", { fg = "#2e383c" })
	end,
}
