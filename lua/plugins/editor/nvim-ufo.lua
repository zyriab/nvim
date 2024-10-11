-- Better folds!
return {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    config = function()
        local ufo = require("ufo")

        vim.opt.foldcolumn = "1"
        vim.opt.foldlevel = 99
        vim.opt.foldlevelstart = 99
        vim.opt.foldenable = true

        -- Setting the folds' characters
        vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

        vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "[Z][R] Open all folds" })
        vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "[Z][M] Close all folds" })

        ufo.setup({
            provider_selector = function()
                return { "treesitter", "indent" }
            end,
        })
    end,
}
