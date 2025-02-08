local filetypes = require("utils.filetypes")

return {
    "terrortylor/nvim-comment",
    dependencies = {
        {
            "JoosepAlviste/nvim-ts-context-commentstring",
            opts = {
                enable_autocmd = false,
                languages = {
                    [filetypes.arduino] = "/*%s*/",
                    [filetypes.templ] = "// %s",
                },
            },
        },
    },
    config = function()
        local nvim_comment = require("nvim_comment")
        local ts_context_commentstring = require("ts_context_commentstring")

        vim.keymap.set("n", "<C-/>", vim.cmd.CommentToggle, { silent = true })
        vim.keymap.set("n", "gcc", vim.cmd.CommentToggle, { silent = true })

        vim.keymap.set("v", "<C-/>", ":'<,'>CommentToggle<Cr>", { silent = true })
        vim.keymap.set("v", "gcc", ":'<,'>CommentToggle<Cr>", { silent = true })

        nvim_comment.setup({
            comment_empty = false,
            create_mappings = false,
            hook = ts_context_commentstring.update_commentstring,
        })
    end,
}
