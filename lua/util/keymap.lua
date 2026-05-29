local M = {}

M.opts = { noremap = true, silent = true }

function M.map(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts or M.opts)
end

return M
