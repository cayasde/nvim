return {
  "neovim/nvim-lspconfig",
  config = function()
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    vim.lsp.config("lua_ls", {
      capabilities = capabilities,
      settings = {
        Lua = {
          completion = {
            callSnippet = "Replace",
          },
          diagnostics = {
            globals = { "vim" },
          },
          hint = {
            enable = true,
          },
          runtime = {
            version = "LuaJIT",
          },
          telemetry = {
            enable = false,
          },
          workspace = {
            checkThirdParty = false,
          },
        },
      },
    })

    vim.lsp.config("luau-lsp", {
      capabilities = capabilities,
    })
  end,
}
