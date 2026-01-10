return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			panel = { enabled = false },
			suggestion = { enabled = false },
		},
	},

	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "zbirenbaum/copilot.lua" },
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		build = "make tiktoken",
		opts = {
			prompts = {
				Rename = {
					prompt = "Please rename the variable correctly in given selection based on context",
					selection = function(source)
						local select = require("CopilotChat.select")
						return select.visual(source)
					end,
				},
				MdDoc = {
					prompt = [[
Write mdbook documentation explaining the working of this program using the template below:
# <md Title><file_name>
## Overview
## Initialization
## Main Logic / Execution Flow
## Core Components / Subsystems
## Input / Output Handling
## Configuration and Parameters
## Exit Conditions
## Dependencies
## Usage
## Future Work
  ]],
					selection = function(source)
						local select = require("CopilotChat.select")
						return select.buffer(source)
					end,
				},
			},
		},
		keys = {
			{ "<leader>zb", ":CopilotChatMdDoc<CR>", mode = { "n", "v" }, desc = "Genearate MdBook documentation" },
			{ "<leader>zn", ":CopilotChatRename<CR>", mode = "v", desc = "Rename the variable" },
			{ "<leader>zc", ":CopilotChat<CR>", mode = { "n", "v" }, desc = "Chat with Copilot" },
			{ "<leader>ze", ":CopilotChatExplain<CR>", mode = "v", desc = "Explain Code" },
			{ "<leader>zr", ":CopilotChatReview<CR>", mode = "v", desc = "Review Code" },
			{ "<leader>zf", ":CopilotChatFix<CR>", mode = "v", desc = "Fix Code Issues" },
			{ "<leader>zo", ":CopilotChatOptimize<CR>", mode = "v", desc = "Optimize Code" },
			{ "<leader>zd", ":CopilotChatDocs<CR>", mode = "v", desc = "Generate Docs" },
			{ "<leader>zt", ":CopilotChatTests<CR>", mode = "v", desc = "Generate Tests" },
			{ "<leader>zm", ":CopilotChatCommit<CR>", mode = "n", desc = "Generate Commit Message" },
			{ "<leader>zs", ":CopilotChatCommit<CR>", mode = "v", desc = "Generate Commit for Selection" },
		},
	},
}
