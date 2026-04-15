return {
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        cmd = "Telescope",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>ff", function() require("telescope.builtin").find_files() end,  desc = "Telescope: find files" },
            { "<leader>fg", function() require("telescope.builtin").live_grep() end,   desc = "Telescope: live grep" },
            { "<leader>fb", function() require("telescope.builtin").buffers() end,     desc = "Telescope: buffers" },
            { "<leader>fd", function() require("telescope.builtin").diagnostics() end, desc = "Telescope: diagnostics" },
            { "<leader>fh", function() require("telescope.builtin").help_tags() end,   desc = "Telescope: help tags" },
        },
        opts = {
            defaults = {
                file_ignore_patterns = { "env/" },
            },
        },
    },
}
