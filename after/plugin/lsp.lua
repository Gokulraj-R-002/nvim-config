local lsp_zero = require('lsp-zero')

lsp_zero.preset("recommended")


-- Fix Undefined global 'vim'
lsp_zero.configure('lua_ls', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp_zero.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

cmp.setup({
    sources = {
        {name = 'nvim_lsp'},
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp_mappings,
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
})


-- lsp_zero.setup_nvim_cmp({
--     mappings = cmp_mappings
-- })

require('lspconfig').lua_ls.setup({})

local flake_ignores = {
    -- "E203", -- whitespace before :
    -- "W503", -- line break before binary operator
    "E501", -- line too long
    -- "C901" -- mccabe complexity
}

-- require'lspconfig'.pylsp.setup({
--     -- on_attach=on_attach,
--     filetypes = {'python'},
--     settings = {
--         pylsp = {
--             plugins = {
--                 mccabe = { enabled = false },
--                 flake8 = {
--                     enabled = true,
--                     ignore = table.concat(flake_ignores, ",")
--                 }
--             }
--         },

--         -- configurations = {"flake8"},
--         -- formatCommand = {"black"},
--         -- pylsp = {
--         --     plugins = {
--         --         -- jedi_completion = {fuzzy = true},
--         --         -- jedi_completion = {eager=true},
--         --         -- jedi_completion = {
--         --         --     include_params = true,
--         --         -- },
--         --         -- jedi_signature_help = {enabled = true},
--         --         -- jedi = {
--         --         --     extra_paths = {'~/projects/work_odoo/odoo14', '~/projects/work_odoo/odoo14'},
--         --         --     -- environment = {"odoo"},
--         --         -- },
--         --         pyflakes={enabled=false},
--         --         pylint = {args = {'--ignore=E501', '-'}, enabled=false, debounce=200},
--         --         pylsp_mypy={enabled=false},
--         --         pycodestyle={
--         --             enabled=false,
--         --             ignore={'E501'},
--         --             maxLineLength=120},
--         --             yapf={enabled=true}
--         --     }
--         -- }
--     }

-- })

lsp_zero.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
    vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
    vim.keymap.set("n", "<F2>", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "<F3>", function() vim.lsp.buf.format() end, opts)
    vim.keymap.set("n", "<F4>", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)

    lsp_zero.default_keymaps({ buffer = bufnr })
end)

-- to learn how to use mason.nvim
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guide/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
    -- ensure_installed = {'lua_ls', 'bashls', 'markdown_oxide', 'powershell_es', 'pyright', 'sqlls', 'vimls'},
    ensure_installed = {},
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({})
        end,
    },
})
