-- LSP stack: mason (installer) + mason-lspconfig (bridge) + nvim-lspconfig + nvim-cmp.
-- Targets nvim 0.11+ and mason-lspconfig 2.x, which auto-enables installed
-- servers via `vim.lsp.enable()`. Per-server config goes through `vim.lsp.config()`.

return {
    -- Mason: installs LSP servers, formatters, linters, DAPs.
    {
        "williamboman/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
        opts = {},
    },

    -- Bridges Mason-installed servers to lspconfig. On mason-lspconfig 2.x
    -- installed servers are auto-enabled — no handlers wrapper needed.
    {
        "williamboman/mason-lspconfig.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        opts = {
            -- Add servers here to auto-install on startup (e.g. { "lua_ls", "pyright" }).
            -- Left empty: install on-demand via `:Mason`.
            ensure_installed = {},
        },
    },

    -- Core LSP: per-server config + buffer-local keymaps.
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "hrsh7th/cmp-nvim-lsp" },
        config = function()
            -- Merge cmp-nvim-lsp's completion capabilities into the defaults
            -- so servers advertise snippet + resolve support to nvim-cmp.
            local capabilities = vim.tbl_deep_extend(
                "force",
                vim.lsp.protocol.make_client_capabilities(),
                require("cmp_nvim_lsp").default_capabilities()
            )

            -- Applied to every server via the `*` wildcard (nvim 0.11+ API).
            vim.lsp.config("*", { capabilities = capabilities })

            -- lua_ls: teach it about the `vim` global so diagnostics are clean
            -- when editing this config.
            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                    },
                },
            })

            -- Buffer-local keymaps, attached whenever any LSP client does.
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(ev)
                    local opts = { buffer = ev.buf, remap = false, silent = true }
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                    vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                    vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
                    vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
                    vim.keymap.set("n", "<F3>", function() vim.lsp.buf.format({ async = true }) end, opts)
                    vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, opts)
                    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
                    -- vim.diagnostic.goto_{next,prev} deprecated in 0.11; use jump().
                    vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
                    vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
                end,
            })
        end,
    },

    -- Completion engine.
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip", -- bridge between nvim-cmp and LuaSnip
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local cmp_select = { behavior = cmp.SelectBehavior.Select }

            cmp.setup({
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                snippet = {
                    expand = function(args) luasnip.lsp_expand(args.body) end,
                },
                -- preset.insert gives sensible defaults; the entries below
                -- override those defaults to match the prior lsp-zero mappings.
                mapping = cmp.mapping.preset.insert({
                    ["<C-p>"]     = cmp.mapping.select_prev_item(cmp_select),
                    ["<C-n>"]     = cmp.mapping.select_next_item(cmp_select),
                    ["<C-y>"]     = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-u>"]     = cmp.mapping.scroll_docs(-4),
                    ["<C-d>"]     = cmp.mapping.scroll_docs(4),
                    -- <C-f>/<C-b>: jump forward/backward through LuaSnip
                    -- placeholders. Falls through to normal behavior when
                    -- there's no active snippet.
                    ["<C-f>"] = cmp.mapping(function(fallback)
                        if luasnip.jumpable(1) then
                            luasnip.jump(1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<C-b>"] = cmp.mapping(function(fallback)
                        if luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
            })

            -- nvim-autopairs integration: when completion inserts a function,
            -- the pair plugin adds the `()` automatically.
            local ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
            if ok then
                cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
            end
        end,
    },
}
