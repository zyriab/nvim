return {
    "stevearc/qf_helper.nvim",
    config = function()
        local qf_helper = require("qf_helper")

        qf_helper.setup({
            prefer_loclist = false, -- Used for QNext/QPrev (see Commands below)
            sort_lsp_diagnostics = true, -- Sort LSP diagnostic results
            quickfix = {
                autoclose = true, -- Autoclose qf if it's the only open window
                default_bindings = true, -- Set up recommended bindings in qf window
                default_options = true, -- Set recommended buffer and window options
                max_height = 10, -- Max qf height when using open() or toggle()
                min_height = 1, -- Min qf height when using open() or toggle()
                track_location = true, -- Keep qf updated with your current location
            },
            loclist = { -- The same options, but for the loclist
                autoclose = true,
                default_bindings = true,
                default_options = true,
                max_height = 10,
                min_height = 1,
                track_location = true,
            },
        })

        vim.keymap.set("n", "<leader>qf", function()
            vim.cmd.QFToggle({ bang = true })
        end, { desc = "Toggle [Q]uick[F]ix", silent = true })

        vim.keymap.set("n", "<leader>ll", function()
            vim.cmd.LLToggle({ bang = true })
        end, { desc = "Toggle [L]oc[L]ist", silent = true })

        vim.keymap.set("n", "<C-n>", vim.cmd.QFNext, { desc = "QuickFix/LocList [N]ext", silent = true })
        vim.keymap.set("n", "<C-p>", vim.cmd.QFPrev, { desc = "QuickFix/LocList [P]revious", silent = true })
    end,
}
