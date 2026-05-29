return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = true,
    },
    messages = {
      enabled = true,
    },
    notify = {
      enabled = true,
      view = "notify",
    },
    popupmenu = {
      enabled = true,
      backend = "nui",
    },
    cmdline = {
      enabled = true,
      view = "cmdline_popup",
    },
    views = {
      mini = {
        timeout = 2500,
      },
    },
  },
}
