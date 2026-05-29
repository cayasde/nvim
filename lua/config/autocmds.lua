local group = vim.api.nvim_create_augroup("codex_core_autocmds", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
  group = group,
  callback = function()
    if vim.fn.argc() ~= 0 or vim.bo.modified or vim.api.nvim_buf_get_name(0) ~= "" then
      return
    end

    vim.schedule(function()
      vim.cmd("Telescope find_files")
    end)
  end,
})
