local keymap = require("util.keymap")

local M = {}

function M.setup()
  keymap.map({ "n", "x" }, "<Left>", "h")
  keymap.map({ "n", "x" }, "<Down>", "gj")
  keymap.map({ "n", "x" }, "<Up>", "gk")
  keymap.map({ "n", "x" }, "<Right>", "l")

  keymap.map({ "n", "x" }, "<Home>", "^")
  keymap.map({ "n", "x" }, "<End>", "$")
  keymap.map({ "n", "x" }, "<C-Left>", "b")
  keymap.map({ "n", "x" }, "<C-Right>", "w")
  keymap.map("n", "<C-S-Left>", "vb")
  keymap.map("n", "<C-S-Right>", "vw")
  keymap.map("n", "<C-S-Up>", "vgk")
  keymap.map("n", "<C-S-Down>", "vgj")
  keymap.map("x", "<C-S-Left>", "b")
  keymap.map("x", "<C-S-Right>", "w")
  keymap.map("x", "<C-S-Up>", "gk")
  keymap.map("x", "<C-S-Down>", "gj")

  keymap.map("i", "<Home>", "<C-o>^")
  keymap.map("i", "<End>", "<End>")
  keymap.map("i", "<C-Left>", "<C-o>b")
  keymap.map("i", "<C-Right>", "<C-o>w")
  keymap.map("i", "<C-S-Left>", "<C-o>vb")
  keymap.map("i", "<C-S-Right>", "<C-o>vw")
  keymap.map("i", "<C-S-Up>", "<C-o>vgk")
  keymap.map("i", "<C-S-Down>", "<C-o>vgj")
end

return M
