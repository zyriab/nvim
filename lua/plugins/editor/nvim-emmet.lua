return {
    "olrtg/nvim-emmet",
    config = function()
        local nvim_emmet = require("nvim-emmet")
        vim.keymap.set({ "n", "v" }, "<leader>xe", nvim_emmet.wrap_with_abbreviation)
    end,
}
