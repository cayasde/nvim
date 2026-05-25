local group = vim.api.nvim_create_augroup("codex_format_on_save", { clear = true })

local stylua = vim.fn.stdpath("data") .. "/mason/bin/stylua.cmd"

local function format_with_stylua(args)
  if vim.fn.executable(stylua) ~= 1 then
    return
  end

  local bufnr = args.buf
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local text = table.concat(lines, "\n")

  if vim.bo[bufnr].endofline then
    text = text .. "\n"
  end

  local result = vim.system({
    stylua,
    "--stdin-filepath",
    vim.api.nvim_buf_get_name(bufnr),
    "-",
  }, { stdin = text, text = true }):wait()

  if result.code ~= 0 or not result.stdout then
    vim.notify(result.stderr or "stylua failed", vim.log.levels.ERROR)
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

vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  pattern = { "*.lua", "*.luau" },
  callback = format_with_stylua,
})
