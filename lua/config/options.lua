-- Process-level log level (quiets verbose LSP/runtime logs).
vim.env.NVIM_LOG_LEVEL = "WARN"

local opt = vim.opt

opt.title = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"

-- Indentation: 4-space, expand tabs, smart indent.
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- Search.
opt.hlsearch = false
opt.incsearch = true

opt.wrap = true
opt.scrolloff = 8

-- Source project-local .nvim.lua / .exrc from cwd. Only enable in trusted dirs.
opt.exrc = true

-- Line numbers.
opt.number = true
opt.relativenumber = true

opt.hidden = true
opt.errorbells = false

opt.splitbelow = true
opt.splitright = true

opt.colorcolumn = "100"
