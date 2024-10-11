return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local todo_comments = require("todo-comments")

        vim.keymap.set("n", "]t", todo_comments.jump_next, { desc = "Next []] [T]odo comment" })
        vim.keymap.set("n", "[t", todo_comments.jump_prev, { desc = "Previous [[] [T]odo comment" })

        vim.keymap.set("n", "<leader>td", vim.cmd.TodoTelescope, { desc = "Show [T]o[D]o comments in Telescope" })

        todo_comments.setup({
            highlight = {
                pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]],
            },
            search = {
                pattern = [[\b(KEYWORDS)(\(\w*\))*:]],
            },
        })
    end,
}
