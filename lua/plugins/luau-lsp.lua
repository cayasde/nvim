return {
  "lopi-py/luau-lsp.nvim",
  opts = {
    platform = {
      type = "roblox",
    },
    types = {
      roblox_security_level = "PluginSecurity",
    },
  },
  config = function(_, opts)
    vim.lsp.config("luau-lsp", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })

    require("luau-lsp").setup(opts)
  end,
}
