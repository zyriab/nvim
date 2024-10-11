return {
    "ofirgall/goto-breakpoints.nvim",
    config = function()
        local goto_breakpoints = require("goto-breakpoints")
        vim.keymap.set("n", "]b", goto_breakpoints.next, { desc = "Jump to next []] [B]reakpoint" })
        vim.keymap.set("n", "[b", goto_breakpoints.prev, { desc = "Jump to previous [[] [B]reakpoint" })
        vim.keymap.set("n", "]s", goto_breakpoints.stopped, { desc = "Jump to next [S]topped breakpoint" })
    end,
}
