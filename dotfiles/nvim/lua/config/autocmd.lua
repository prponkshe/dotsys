local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local code_group = augroup("CodeHabits", {})
local yank_group = augroup("HighlightYank", {})

autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

autocmd({ "BufWritePre" }, {
	group = code_group,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

autocmd("LspAttach", {
	group = code_group,
	callback = function(e)
		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = e.buf, desc = desc })
		end

		map("n", "K", function()
			vim.lsp.buf.hover()
		end, "Hover documentation")

		map("n", "<leader>cd", function()
			vim.diagnostic.open_float()
		end, "Line diagnostics")

		map("n", "<leader>ca", function()
			vim.lsp.buf.code_action()
		end, "Code action")

		map("n", "<leader>cr", function()
			vim.lsp.buf.rename()
		end, "Rename symbol")

		map("i", "<C-h>", function()
			vim.lsp.buf.signature_help()
		end, "Signature help")

		map("n", "[d", function()
			vim.diagnostic.goto_next()
		end, "Next diagnostic")

		map("n", "]d", function()
			vim.diagnostic.goto_prev()
		end, "Prev diagnostic")
	end,
})
