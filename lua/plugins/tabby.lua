return {
  "nanozuki/tabby.nvim",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    vim.o.showtabline = 2

    local theme = {
      fill = { fg = "#8b949e", bg = "#161b22" },
      head = { fg = "#0d1117", bg = "#79c0ff", style = "bold" },
      current = { fg = "#0d1117", bg = "#79c0ff", style = "bold" },
      buffer = { fg = "#c9d1d9", bg = "#21262d" },
      tail = { fg = "#0d1117", bg = "#30363d" },
    }

    require("tabby").setup({
      line = function(line)
        return {
          {
            { "  アニメ ", hl = theme.head },
            line.sep("", theme.head, theme.fill),
          },
          line
            .bufs()
            .filter(function(buf)
              return vim.bo[buf.id].buflisted and vim.bo[buf.id].buftype == ""
            end)
            .foreach(function(buf)
              local hl = buf.is_current() and theme.current or theme.buffer
              local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf.id), ":t")
              if name == "" then
                name = "[No Name]"
              end

              return {
                line.sep("", hl, theme.fill),
                buf.is_current() and " " or "󰆣 ",
                buf.file_icon(),
                " ",
                name,
                buf.is_changed() and " [+]" or "",
                " ",
                line.sep("", hl, theme.fill),
                hl = hl,
                margin = " ",
              }
            end),
          line.spacer(),
          {
            line.sep("", theme.tail, theme.fill),
            "  ",
            hl = theme.tail,
          },
          hl = theme.fill,
        }
      end,
    })
  end,
}
