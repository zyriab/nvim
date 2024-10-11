return {
    "kosayoda/nvim-lightbulb",
    opts = {
        priority = 10,
        hide_in_unfocused_buffer = true,
        link_highlights = false,
        validate_config = "auto",

        -- Code action kinds to observe.
        -- To match all code actions, set to `nil`.
        -- Otherwise, set to a table of kinds.
        -- Example: { "quickfix", "refactor.rewrite" }
        -- See: https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#codeActionKind
        action_kinds = nil,

        sign = {
            enabled = true,
            -- Text to show in the sign column.
            -- Must be between 1-2 characters.
            text = "",
            -- Highlight group to highlight the sign column text.
            hl = "LightBulbSign",
        },

        autocmd = {
            -- Whether or not to enable autocmd creation.
            enabled = true,
            -- See |updatetime|.
            -- Set to a negative value to avoid setting the updatetime.
            updatetime = -1,
            -- See |nvim_create_autocmd|.
            events = { "CursorHold", "CursorHoldI" },
            -- See |nvim_create_autocmd| and |autocmd-pattern|.
            pattern = { "*" },
        },

        ignore = {
            -- LSP client names to ignore.
            -- Example: {"null-ls", "lua_ls"}
            clients = {},
            -- Filetypes to ignore.
            -- Example: {"neo-tree", "lua"}
            ft = {},
            actions_without_kind = false,
        },
    },
}
