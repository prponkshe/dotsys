return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
			if ok_cmp then
				capabilities = cmp_lsp.default_capabilities(capabilities)
			end

			local servers = {
				"bashls",
				"clangd",
				"pyright",
				"lua_ls",
				"rust_analyzer",
			}

			for _, server in ipairs(servers) do
				local opts = { capabilities = capabilities }
				if server == "lua_ls" then
					opts.settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
							workspace = {
								checkThirdParty = false,
								library = vim.api.nvim_get_runtime_file("", true),
							},
							telemetry = { enable = false },
						},
					}
				end
				vim.lsp.config(server, opts)
			end

			vim.lsp.enable(servers)
		end,
	},
}
