local keymap = require("util.keymap")

local M = {}

function M.setup()
  keymap.map("n", "<leader>e", "<cmd>Oil .<CR>")
  keymap.map("n", "<leader><leader>", "<cmd>Telescope find_files<CR>")
  keymap.map("n", "<leader>ms", "<cmd>Spotify<CR>")
  keymap.map(
    "n",
    "<C-p>",
    "<cmd>Telescope buffers sort_mru=true ignore_current_buffer=true previewer=false<CR>"
  )
  keymap.map("n", "<leader>g", "<cmd>Telescope live_grep<CR>")

  keymap.map({ "i", "v", "s", "o" }, "<Esc>", "<Esc>")
  keymap.map("n", "<Esc>", "<cmd>nohlsearch<CR><Esc>")
end

return M
