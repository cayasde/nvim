local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map({ "i", "v", "s", "o" }, "<Esc>", "<Esc>", opts)
map("n", "<Esc>", "<cmd>nohlsearch<CR><Esc>", opts)
map("t", "<Esc>", [[<C-\><C-n>]], opts)
