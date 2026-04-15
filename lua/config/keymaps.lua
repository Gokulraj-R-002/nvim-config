-- Non-plugin keymaps. Plugin keymaps live with their plugin specs.

-- Open netrw file explorer.
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open netrw" })
