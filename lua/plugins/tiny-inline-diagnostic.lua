return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  priority = 1000,
  config = function()
    require("tiny-inline-diagnostic").setup({
      preset = "modern",
      transparent_bg = true,
      transparent_cursorline = true,
      options = {
        show_source = {
          enabled = false,
        },
        show_code = true,
        throttle = 20,
        softwrap = 30,
        multilines = {
          enabled = true,
          always_show = true,
        },
        show_all_diags_on_cursorline = false,
        show_diags_only_under_cursor = false,
        enable_on_insert = false,
        overflow = {
          mode = "wrap",
          padding = 0,
        },
        override_open_float = true,
      },
    })

    vim.diagnostic.config({
      virtual_text = false,
    })
  end,
}
