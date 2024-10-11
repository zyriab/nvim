---@diagnostic disable: param-type-mismatch
return {
    "Shatur/neovim-session-manager",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local session_manager = require("session_manager")
        local config = require("session_manager.config")
        local filetypes = require("utils.filetypes")

        session_manager.setup({
            autoload_mode = config.AutoloadMode.Disabled, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
            autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
            autosave_ignore_dirs = {}, -- A list of directories where the session will not be autosaved.
            autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
                "gitcommit",
                "gitrebase",
                filetypes.noice,
                filetypes.notify,
                filetypes.nvimtree,
            },
            autosave_ignore_buftypes = {}, -- All buffers of these bufer types will be closed before the session is saved.
            autosave_only_in_session = false, -- Always autosaves session. If true, only autosaves after a session is active.
            max_path_length = 80, -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
        })

        local group = vim.api.nvim_create_augroup("session_manager_group", { clear = true })
        vim.api.nvim_create_autocmd("User", {
            pattern = "SessionSavePre",
            group = group,
            callback = function()
                vim.cmd.cclose()
                pcall(vim.cmd.DapUiClose)
                pcall(vim.cmd.NvimTreeClose)
                pcall(vim.cmd.OutlineClose)
                pcall(vim.cmd.TermKill)
            end,
        })

        vim.keymap.set("n", "<leader>ss", function()
            session_manager.load_session(false)
        end, { desc = "[S]earch [S]essions" })

        vim.keymap.set("n", "<leader>sds", function()
            session_manager.delete_session()
        end, { desc = "[S]earch and [D]elete [S]essions" })
    end,
}
