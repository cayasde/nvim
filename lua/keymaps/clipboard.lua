local keymap = require("util.keymap")

local M = {}

function M.setup()
  keymap.map({ "n", "x" }, "<C-x>", '"+d')
  keymap.map({ "n", "x" }, "<C-c>", '"+y')
  keymap.map("n", "<C-v>", '"+p')
  keymap.map("x", "<C-v>", '"+p')

  keymap.map("n", "<C-z>", "u")
  keymap.map("x", "<C-z>", "u")
  keymap.map("n", "<C-y>", "<C-r>")
  keymap.map("x", "<C-y>", "<C-r>")

  keymap.map("n", "<C-s>", "<cmd>w<CR>")
  keymap.map("i", "<C-s>", "<C-o><cmd>w<CR>")
  keymap.map("x", "<C-s>", "<Esc><cmd>w<CR>")

  keymap.map("n", "<C-a>", "ggVG")
  keymap.map("i", "<C-a>", "<Esc>ggVG")
end

return M
