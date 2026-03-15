vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set("n", "-", vim.cmd.Ex) -- netrw

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv") -- move line up or down

vim.keymap.set("n", "J", "mzJ`z") -- join with line below, but keep cursor at start
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz") -- scroll but remain in center
vim.keymap.set("n", "n", "nzzzv") -- center after search
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "=ap", "ma=ap'a") -- auto indent para to default tabwidth
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

vim.keymap.set("x", "<leader>p", [["_dP]]) -- paste clipboard onto selected text without yanking it
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d') -- delete without yanking

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz") -- quickfix navigation
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")

vim.keymap.set("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]) -- search and replace current word
vim.keymap.set("n", "<leader>exec", "<cmd>!chmod +x %<CR>", { silent = true }) -- make current file executable. Useful for bash
