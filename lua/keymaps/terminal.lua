local keymap = require("util.keymap")
local terminal = require("features.terminal")

local M = {}

function M.setup()
  keymap.map("t", "<Esc>", [[<C-\><C-n>]])

  for _, lhs in ipairs({ "<C-\\>", "<C-`>", "<Nul>", "<C-Space>", "<C-@>" }) do
    keymap.map({ "n", "t" }, lhs, terminal.toggle_last)
  end

  keymap.map("n", "<leader>tn", terminal.new)
  keymap.map("n", "<leader>ts", terminal.select)
  keymap.map("n", "<leader>tk", terminal.close_last)
end

return M
