return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("features.terminal").setup()
  end,
}
