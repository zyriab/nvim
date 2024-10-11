local lazy = require("lazy")
lazy.setup({
    -- Detect tabstop and shiftwidth automatically
    -- FIXME: breaks with some filetypes (C)
    -- "tpope/vim-sleuth",

    -- Nicer vim.ui interfaces
    "stevearc/dressing.nvim",

    -- Highlight matching words under cursor
    "RRethy/vim-illuminate",

    -- Support for DBML files
    "zyriab/vim-dbml",

    -- Schema store catalog access
    "b0o/schemastore.nvim",

    { import = "plugins" },
}, {
    ui = { border = "rounded" },
})
