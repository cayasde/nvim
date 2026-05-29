local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/"
local prettierd = mason_bin .. "prettierd.cmd"
local prettier = mason_bin .. "prettier.cmd"

local M = {}

local function stdin_filepath_args(bufname, needs_dash)
  local args = { "--stdin-filepath", bufname }
  if needs_dash then
    table.insert(args, "-")
  end
  return args
end

function M.build()
  local formatters = {
    lua = {
      exes = { "stylua", mason_bin .. "stylua.cmd" },
      name = "stylua",
      args = function(bufname)
        return stdin_filepath_args(bufname, true)
      end,
    },
    luau = {
      exes = { "stylua", mason_bin .. "stylua.cmd" },
      name = "stylua",
      args = function(bufname)
        return stdin_filepath_args(bufname, true)
      end,
    },
  }

  for _, filetype in ipairs({
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "json",
    "jsonc",
    "css",
    "scss",
    "less",
    "html",
    "markdown",
    "yaml",
  }) do
    formatters[filetype] = {
      exes = { prettierd, prettier },
      name = "prettierd",
      args = function(bufname)
        return stdin_filepath_args(bufname, false)
      end,
    }
  end

  return formatters
end

return M
