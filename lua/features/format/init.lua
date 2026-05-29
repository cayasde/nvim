local executable = require("util.executable")
local registry = require("features.format.registry")

local M = {}

local group = vim.api.nvim_create_augroup("codex_format_on_save", { clear = true })
local formatters = registry.build()

local function format_buffer(args)
  local bufnr = args.buf
  local formatter = formatters[vim.bo[bufnr].filetype]
  if not formatter then
    return
  end

  local exe = executable.first(formatter.exes or {})
  if not exe then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local text = table.concat(lines, "\n")

  if vim.bo[bufnr].endofline then
    text = text .. "\n"
  end

  local command = { exe }
  vim.list_extend(command, formatter.args(vim.api.nvim_buf_get_name(bufnr)))

  local result = vim.system(command, { stdin = text, text = true }):wait()
  if result.code ~= 0 or not result.stdout then
    vim.notify(
      (result.stderr and result.stderr ~= "") and result.stderr or (formatter.name .. " failed"),
      vim.log.levels.ERROR
    )
    return
  end

  local view = vim.fn.winsaveview()
  local new_lines = vim.split(result.stdout, "\n", { plain = true })
  if new_lines[#new_lines] == "" then
    table.remove(new_lines, #new_lines)
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
  vim.fn.winrestview(view)
end

function M.setup()
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    pattern = "*",
    callback = format_buffer,
  })
end

return M
