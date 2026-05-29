local M = {}

function M.first(executables)
  for _, exe in ipairs(executables) do
    if vim.fn.executable(exe) == 1 then
      return exe
    end
  end

  return nil
end

return M
