return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = function()
    local base16_theme = {
      normal = {
        a = { fg = "#0d1117", bg = "#79c0ff" },
        b = { fg = "#c9d1d9", bg = "#30363d" },
        c = { fg = "#8b949e", bg = "#161b22" },
      },
      insert = {
        a = { fg = "#0d1117", bg = "#56d364" },
        b = { fg = "#c9d1d9", bg = "#30363d" },
      },
      visual = {
        a = { fg = "#0d1117", bg = "#d2a8ff" },
        b = { fg = "#c9d1d9", bg = "#30363d" },
      },
      replace = {
        a = { fg = "#0d1117", bg = "#ffa657" },
        b = { fg = "#c9d1d9", bg = "#30363d" },
      },
      command = {
        a = { fg = "#0d1117", bg = "#f2cc60" },
        b = { fg = "#c9d1d9", bg = "#30363d" },
      },
      inactive = {
        a = { fg = "#6e7681", bg = "#161b22" },
        b = { fg = "#6e7681", bg = "#161b22" },
        c = { fg = "#6e7681", bg = "#161b22" },
      },
    }

    return {
      options = {
        theme = base16_theme,
        globalstatus = true,
        section_separators = { left = "", right = "" },
        component_separators = { left = "|", right = "|" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "lazy", "mason", "oil", "quickfix", "toggleterm" },
    }
  end,
}
