return {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        vim.keymap.set("n", "<leader>lg", vim.cmd.LazyGit, { desc = "Open [L]azy[G]it" })
    end,
}
