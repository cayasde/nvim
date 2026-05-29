vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.lazy")
require("config.autocmds")
require("features.format").setup()
require("keymaps").setup()
