return {
    {
        "folke/tokyonight.nvim",
        lazy = false,      -- load at startup so the colorscheme is set immediately
        priority = 1000,   -- ensure it loads before any other plugin
        config = function()
            vim.opt.background = "dark"
            vim.cmd.colorscheme("tokyonight-night")
        end,
    },
}
