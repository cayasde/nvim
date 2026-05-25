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
      keymap = {
        preset = "enter",
        ["<Tab>"] = { "select_and_accept", "snippet_forward", "fallback" },
      },
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
    "windwp/nvim-autopairs",
    opts = {},
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
  },
  {
    "stevearc/oil.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      columns = { "icon" },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
  },
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        separator_style = "slant",
        offsets = {
          {
            filetype = "oil",
            text = "Oil",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
  },
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = function()
      local dashboard = require("config.dashboard")

      return {
        theme = "hyper",
        config = {
          header = dashboard.build(),
          shortcut = {
            {
              icon = "  ",
              desc = "cayasde",
              key = "h",
              action = function()
                vim.ui.open("https://github.com/cayasde")
              end,
            },
            { icon = "  ", desc = "Files", key = "f", action = "Telescope find_files" },
            { icon = "  ", desc = "Grep", key = "g", action = "Telescope live_grep" },
            { icon = "  ", desc = "Oil", key = "e", action = "Oil ." },
            { icon = "  ", desc = "LazyGit", key = "l", action = "LazyGit" },
            {
              icon = "󰗼  ",
              desc = "Quit",
              key = "q",
              action = "qa",
            },
          },
          project = { enable = true, limit = 8 },
          mru = { enable = true, limit = 10 },
          footer = {},
        },
      }
    end,
    config = function(_, opts)
      require("dashboard").setup(opts)
      require("config.dashboard").setup()
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    opts = {},
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
