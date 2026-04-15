return {
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            check_ts = true, -- treesitter-aware: skips pairs inside strings/comments
        },
    },
}
