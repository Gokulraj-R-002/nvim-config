-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use 'folke/tokyonight.nvim'
    use 'ellisonleao/gruvbox.nvim'

    use 'tpope/vim-commentary'

    -- Telescope
    use {
      'nvim-telescope/telescope.nvim',
      branch = '0.1.x',
      -- OR
      -- tag = '0.1.0',
      requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- lualine
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    -- treesitter
    use {
      'nvim-treesitter/nvim-treesitter',
      run = function()
          local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
          ts_update()
      end,
    }

    -- lsp-zero
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            -- lsp support
            {'neovim/nvim-lspconfig'},

            -- mason
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-nvim-lsp'},

            -- snippets
            {'L3MON4D3/LuaSnip'},
        }
    }

end)
