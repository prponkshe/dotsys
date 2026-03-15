return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		local wk = require("which-key")

		wk.setup({})
		wk.add({
			{ "<leader>c", group = "code" },
			{ "<leader>g", group = "goto" },
			{ "<leader>s", group = "search" },
			{ "<leader>t", group = "trouble" },
			{ "<leader>u", group = "undo" },
			{ "<leader>z", group = "lsp" },
			{ "<leader>e", group = "exec" },
		})
	end,
}
