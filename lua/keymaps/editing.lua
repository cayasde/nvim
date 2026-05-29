local keymap = require("util.keymap")

local M = {}

local function delete_code_chunk_backward()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  if col == 0 then
    return
  end

  local line = vim.api.nvim_get_current_line()
  local before = line:sub(1, col)
  local after = line:sub(col + 1)
  local start_col

  for _, pattern in ipairs({
    "%s+$",
    "[%a_][%w_]*$",
    "0[xX][%da-fA-F]+$",
    "%d+%.?%d*$",
    "[%]%)}]+$",
    "[%[%({]+$",
    "[\"'`]+$",
    "[%.:,;]+$",
    "[%+%-%*%/%=<>!&|%^~?]+$",
    "[^%s%w_]+$",
  }) do
    local match_start = before:find(pattern)
    if match_start then
      start_col = match_start
      break
    end
  end

  if not start_col then
    start_col = col
  end

  vim.api.nvim_set_current_line(before:sub(1, start_col - 1) .. after)
  vim.api.nvim_win_set_cursor(0, { row, start_col - 1 })
end

function M.setup()
  keymap.map("x", "<BS>", '"_d')
  keymap.map({ "n", "x" }, "<C-BS>", 'vb"_d')
  keymap.map({ "n", "x" }, "<C-h>", 'vb"_d')

  keymap.map("i", "<C-BS>", delete_code_chunk_backward)
  keymap.map("i", "<C-h>", delete_code_chunk_backward)
  keymap.map("i", "<C-w>", delete_code_chunk_backward)
end

return M
