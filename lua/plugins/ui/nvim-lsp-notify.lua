-- nicer lsp notifications using nvim-notify
return {
    -- "mrded/nvim-lsp-notify",
    dir = "$HOME/Developer/nvim-plugins/nvim-lsp-notify",
    dependencies = { "rcarriga/nvim-notify" },
    config = function() end,
    opts = {
        -- Keywords to exclude from notifications
        excludes = {
            "lua_ls", -- Keeps on spamming when editing Neovim config
            "arduino_language_server", -- Keeps building sketch, etc
        },
    },
}
