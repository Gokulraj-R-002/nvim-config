return {
    {
        "nvim-treesitter/nvim-treesitter",
        -- Pin to master: nvim-treesitter made `main` the default branch for
        -- their v1.0 rewrite, which removed `nvim-treesitter.configs` and the
        -- `setup()` API used below. The legacy API still lives on `master`
        -- and is what this config targets.
        branch = "master",
        build = ":TSUpdate",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "python", "lua", "vim", "vimdoc", "query",
                    "markdown", "markdown_inline", -- required by render-markdown.nvim
                },
                sync_install = false,
                auto_install = true,
                ignore_install = {},
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                    },
                    -- Note: `]c`/`[c` are claimed by gitsigns for hunk navigation.
                    -- Using `]f`/`[f` for functions; classes only via textobject selection.
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = { ["]f"] = "@function.outer" },
                        goto_previous_start = { ["[f"] = "@function.outer" },
                    },
                },
            })
        end,
    },
    -- Declared as a separate lazy spec so nvim-treesitter can depend on it,
    -- but it has no standalone setup call of its own.
    -- Same branch pin reason as above: `main` is the v1 rewrite, `master` is
    -- the legacy API wired into our `configs.setup({ textobjects = ... })`.
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "master",
        lazy = true,
    },
}
