-- Leader must be set before lazy.nvim loads so plugin keymaps bind correctly.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.lazy")
