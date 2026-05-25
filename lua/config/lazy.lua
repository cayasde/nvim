local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("github_dark_default")
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "saghen/blink.cmp",
    version = "1.*",
    opts = {
      keymap = { preset = "enter" },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = { auto_show = false },
      },
      sources = {
        default = { "lsp", "path", "buffer" },
      },
      fuzzy = {
        implementation = "prefer_rust_with_warning",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
  },
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "luau_lsp" },
      automatic_enable = {
        exclude = { "luau_lsp" },
      },
    },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
  },
  {
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
  },
})
