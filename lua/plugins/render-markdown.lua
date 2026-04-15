return {
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons", -- also used by lualine
        },
        -- Defaults are good: rendered in normal/command/terminal modes; raw
        -- text shows in insert/visual so you can actually edit. Toggle with
        -- `:RenderMarkdown toggle`.
        opts = {},
    },
}
