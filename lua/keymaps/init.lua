local M = {}

function M.setup()
  require("keymaps.navigation").setup()
  require("keymaps.editing").setup()
  require("keymaps.clipboard").setup()
  require("keymaps.window").setup()
  require("keymaps.ui").setup()
  require("keymaps.terminal").setup()
end

return M
