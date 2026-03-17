return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				c = { "clang-format" },
				cpp = { "clang-format" },
				lua = { "stylua" },
				nix = { "nixfmt" },
				yaml = { "yaml-language-server" },
			},
			formatters = {
				["clang-format"] = {
					prepend_args = {
						"-style=file",
						"-fallback-style=LLVM",
					},
				},
			},
		})

		vim.keymap.set("n", "<leader>cf", function()
			require("conform").format({ bufnr = 0 })
		end, { desc = "Format buffer" })
	end,
}
