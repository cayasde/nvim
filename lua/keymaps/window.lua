local keymap = require("util.keymap")

local M = {}

function M.setup()
  keymap.map("n", "<C-q>", "<cmd>bdelete<CR>")
  keymap.map("n", "<leader>v", "<cmd>vsplit<CR>")
  keymap.map("n", "<leader>h", "<cmd>split<CR>")
  keymap.map("n", "<leader>q", "<cmd>close<CR>")
  keymap.map("n", "<leader>o", "<cmd>only<CR>")
  keymap.map("n", "<leader><Left>", "<C-w>h")
  keymap.map("n", "<leader><Down>", "<C-w>j")
  keymap.map("n", "<leader><Up>", "<C-w>k")
  keymap.map("n", "<leader><Right>", "<C-w>l")
end

return M
