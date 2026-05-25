vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.updatetime = 250
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.whichwrap:append("<,>,[,]")

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map({ "n", "x" }, "<Left>", "h", opts)
map({ "n", "x" }, "<Down>", "gj", opts)
map({ "n", "x" }, "<Up>", "gk", opts)
map({ "n", "x" }, "<Right>", "l", opts)

map({ "n", "x" }, "<Home>", "^", opts)
map({ "n", "x" }, "<End>", "$", opts)
map({ "n", "x" }, "<C-Left>", "b", opts)
map({ "n", "x" }, "<C-Right>", "w", opts)
map("n", "<C-S-Left>", "vb", opts)
map("n", "<C-S-Right>", "vw", opts)
map("n", "<C-S-Up>", "vgk", opts)
map("n", "<C-S-Down>", "vgj", opts)
map("x", "<C-S-Left>", "b", opts)
map("x", "<C-S-Right>", "w", opts)
map("x", "<C-S-Up>", "gk", opts)
map("x", "<C-S-Down>", "gj", opts)
map("x", "<BS>", '"_d', opts)
map({ "n", "x" }, "<C-BS>", 'vb"_d', opts)
map({ "n", "x" }, "<C-h>", 'vb"_d', opts)
map({ "n", "x" }, "<C-x>", '"+d', opts)
map({ "n", "x" }, "<C-c>", '"+y', opts)
map("n", "<C-v>", '"+p', opts)
map("x", "<C-v>", '"+p', opts)
map("n", "<C-z>", "u", opts)
map("x", "<C-z>", "u", opts)
map("n", "<C-y>", "<C-r>", opts)
map("x", "<C-y>", "<C-r>", opts)
map("n", "<C-q>", "<cmd>bdelete<CR>", opts)
map("n", "<C-s>", "<cmd>w<CR>", opts)
map("i", "<C-s>", "<C-o><cmd>w<CR>", opts)
map("x", "<C-s>", "<Esc><cmd>w<CR>", opts)

map("n", "<leader>e", "<cmd>Oil .<CR>", opts)
map("n", "<leader>gg", "<cmd>LazyGit<CR>", opts)
map("n", "<leader><leader>", "<cmd>Telescope find_files<CR>", opts)
map("n", "<leader>g", "<cmd>Telescope live_grep<CR>", opts)

map("i", "<Home>", "<C-o>^", opts)
map("i", "<End>", "<End>", opts)
map("i", "<C-Left>", "<C-o>b", opts)
map("i", "<C-Right>", "<C-o>w", opts)
map("i", "<C-S-Left>", "<C-o>vb", opts)
map("i", "<C-S-Right>", "<C-o>vw", opts)
map("i", "<C-S-Up>", "<C-o>vgk", opts)
map("i", "<C-S-Down>", "<C-o>vgj", opts)
map("i", "<C-BS>", "<C-w>", opts)
map("i", "<C-h>", "<C-w>", opts)
map("i", "<C-v>", '<C-r>+', opts)
map("i", "<C-z>", "<C-o>u", opts)
map("i", "<C-y>", "<C-o><C-r>", opts)

map({ "i", "v", "s", "o" }, "<Esc>", "<Esc>", opts)
map("n", "<Esc>", "<cmd>nohlsearch<CR><Esc>", opts)
map("t", "<Esc>", [[<C-\><C-n>]], opts)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lazygit",
  callback = function(args)
    local lazygit_opts = { noremap = true, silent = true, buffer = args.buf }
    map("n", "<Esc>", "<cmd>close<CR>", lazygit_opts)
    map("t", "<Esc>", [[<C-\><C-n><cmd>close<CR>]], lazygit_opts)
  end,
})
