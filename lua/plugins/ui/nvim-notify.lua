---@diagnostic disable: assign-type-mismatch
return {
    "rcarriga/nvim-notify",
    config = function()
        local notify = require("notify")
        -- Overriding vim's notification system
        vim.notify = notify

        vim.keymap.set("n", "<leader><leader>", function()
            notify.dismiss({ silent = true, pending = true })
            vim.cmd.noh()
        end, { desc = "Clear notifications and search highlights" })

        -- Just the default config except for the 3 first properties
        -- This is needed because, otherwise, the diagnostic float
        -- would not open except on line 1
        notify.setup({
            merge_duplicates = true,
            background_colour = "#000000",
            render = "wrapped-compact",
            stages = "fade",
            level = vim.log.levels.INFO,
            timeout = 7000,
            max_width = nil,
            max_height = nil,
            on_open = nil,
            on_close = nil,
            minimum_width = 50,
            fps = 30,
            top_down = true,
            time_formats = {
                notification_history = "%FT%T",
                notification = "%T",
            },
            icons = {
                ERROR = "",
                WARN = "",
                INFO = "",
                DEBUG = "",
                TRACE = "✎",
            },
        })
    end,
}
