return {
    {
        "danymat/neogen",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        version = "*", -- Uses only stable versions
        config = function()
            local neogen = require("neogen")

            neogen.setup({
                enabled = true,
                snippet_engine = "luasnip",
            })

            -- NOTE: Placeholder jumping is set in nvim-cmp config file
            vim.keymap.set("n", "<leader>doc", neogen.generate, { desc = "Generate type [DOC]umentation" })
        end,
    },
}
