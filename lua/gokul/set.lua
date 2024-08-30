local o = vim.opt
local g = vim.g

-- vim.opt.encoding = "utf-8"
-- vim.opt.spell = "en_US"
-- vim.opt.spelllang = "en_US"

-- o.shortmess += c

vim.opt.title = true
vim.opt.mouse = 'a'
-- o.mousemodel = "popup"
-- o.clipboard = 

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.wrap = true
vim.opt.scrolloff = 8
vim.opt.exrc = true -- source the vimrc present in the current directory

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.hidden = true -- keeps the current buffer open so that you can move to another buffer without saving the current buffer

vim.opt.errorbells = false

vim.opt.splitbelow = true
vim.opt.splitright = true

-- Keeping history
-- o.noswapfile
-- o.nobackup
-- o.undodir = "~/.vim/undodir"
-- o.undofile

-- vim.opt.termguicolors = true

vim.opt.colorcolumn = "100"
-- vim.opt.signcolumn = true

vim.g.mapleader = " "
