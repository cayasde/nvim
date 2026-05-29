vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("util.dotenv").load(vim.fn.stdpath("config") .. "/.env")
require("config.options")
require("config.lazy")
require("config.autocmds")
require("features.format").setup()
require("keymaps").setup()
