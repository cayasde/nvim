local group = vim.api.nvim_create_augroup("codex_format_on_save", { clear = true })

local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/"
local prettierd = mason_bin .. "prettierd.cmd"
local prettier = mason_bin .. "prettier.cmd"

local function stdin_filepath_args(bufname, needs_dash)
  local args = { "--stdin-filepath", bufname }
  if needs_dash then
    table.insert(args, "-")
  end
  return args
end

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

local function resolve_executable(formatter)
  if formatter.exe then
    return vim.fn.executable(formatter.exe) == 1 and formatter.exe or nil
  end

  for _, exe in ipairs(formatter.exes or {}) do
    if vim.fn.executable(exe) == 1 then
      return exe
    end
  end

  return nil
end

local function format_buffer(args)
  local bufnr = args.buf
  local formatter = formatters[vim.bo[bufnr].filetype]
  if not formatter then
    return
  end

  local exe = resolve_executable(formatter)
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

vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  pattern = "*",
  callback = format_buffer,
})
