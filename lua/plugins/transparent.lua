return {
  "xiyaowong/transparent.nvim",
  lazy = false,
  priority = 900,
  config = function()
    require("transparent").setup({
      extra_groups = {},
      exclude_groups = {},
    })

    vim.cmd("TransparentEnable")
  end,
}
