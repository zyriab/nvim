return {
    "hedyhli/outline.nvim",
    config = function()
        local outline = require("outline")
        local is_focused = false

        local default_opts = {
            cursorlineopt = vim.opt.cursorlineopt,
            cursorcolumn = vim.opt.cursorcolumn,
        }

        local function set_cursor_options()
            local filetype = vim.bo.filetype
            local outline_ft = require("utils.filetypes").outline

            if is_focused or filetype == outline_ft then
                vim.opt.cursorlineopt = "both"
                vim.opt.cursorcolumn = false
                return
            end

            vim.opt.cursorlineopt = default_opts.cursorlineopt
            vim.opt.cursorcolumn = default_opts.cursorcolumn
        end

        -- TODO(outline-ux): check if using `BufWinEnter` could not reduce the checks and variable needs
        local augroup = vim.api.nvim_create_augroup("outline-custom-options-group", { clear = true })
        vim.api.nvim_create_autocmd("BufEnter", { group = augroup, callback = set_cursor_options })

        vim.keymap.set("n", "<leader>o", function()
            is_focused = outline.toggle_outline({ focus_outline = true })

            set_cursor_options()
        end, { desc = "Toggle [O]utline" })

        vim.keymap.set("n", "<leader>O", function()
            local is_open = outline.toggle_outline({ focus_outline = false })
            is_focused = false

            if is_open == false then
                set_cursor_options()
            end
        end, { desc = "Toggle [O]utline (keep focus)" })

        require("outline").setup({
            outline_window = {
                position = "right",
                -- Percentage or integer of columns
                width = 20,
                relative_width = true,
                auto_close = false,
                auto_jump = false,
                jump_highlight_duration = 300, -- false to disable
                center_on_jump = true,
                show_numbers = true,
                show_relative_numbers = true,
                wrap = false,
                show_cursorline = true,
                hide_cursor = true,
                focus_on_open = true,
                -- winhl = "",
            },

            outline_items = {
                show_symbol_details = true,
                show_symbol_lineno = true,
                highlight_hovered_item = true,
                auto_set_cursor = true,
                auto_update_events = {
                    -- Includes both setting of cursor and highlighting of hovered item.
                    -- The above two options are respected.
                    -- This can be triggered manually through `follow_cursor` lua API,
                    -- :OutlineFollow command, or <C-g>.
                    follow = { "CursorMoved" },
                    -- Re-request symbols from the provider.
                    -- This can be triggered manually through `refresh_outline` lua API, or
                    -- :OutlineRefresh command.
                    items = { "InsertLeave", "WinEnter", "BufEnter", "BufWinEnter", "TabEnter", "BufWritePost" },
                },
            },

            guides = {
                enabled = true,
                markers = {
                    bottom = "└",
                    middle = "├",
                    vertical = "│",
                },
            },

            symbol_folding = {
                autofold_depth = 1,
                auto_unfold = {
                    hovered = false,
                    -- Auto fold when the root level only has this many nodes.
                    -- Set true for 1 node, false for 0.
                    only = true,
                },
                markers = { "", "" },
            },

            preview_window = {
                -- Automatically open preview of code location when navigating outline window
                auto_preview = false,
                -- Automatically open hover_symbol when opening preview (see keymaps for
                -- hover_symbol).
                -- If you disable this you can still open hover_symbol using your keymap
                -- below.
                open_hover_on_preview = false,
                width = 50,
                min_width = 50,
                relative_width = true,
                border = "rounded",
                winhl = "NormalFloat:",
                winblend = 0,
                live = true,
            },

            -- These keymaps can be a string or a table for multiple keys.
            -- Set to `{}` to disable. (Using 'nil' will fallback to default keys)
            keymaps = {
                show_help = "?",
                close = { "<Esc>", "q" },
                -- Jump to symbol under cursor.
                -- It can auto close the outline window when triggered, see
                -- 'auto_close' option above.
                goto_location = "<Cr>",
                -- Jump to symbol under cursor but keep focus on outline window.
                peek_location = "p",
                -- Visit location in code and close outline immediately
                goto_and_close = "<S-Cr>",
                -- Change cursor position of outline window to match current location in code.
                -- 'Opposite' of goto/peek_location.
                restore_location = "g",
                -- Open LSP/provider-dependent symbol hover information
                hover_symbol = "<C-space>",
                -- Preview location code of the symbol under cursor
                toggle_preview = "K",
                rename_symbol = "r",
                code_actions = "a",
                -- These fold actions are collapsing tree nodes, not code folding
                fold = "h",
                unfold = "l",
                fold_toggle = "<Tab>",
                fold_toggle_all = "<S-Tab>",
                fold_all = "C",
                unfold_all = "O",
                fold_reset = "R",
                down_and_jump = "<C-n>",
                up_and_jump = "<C-e>",
            },

            providers = {
                priority = { "lsp", "markdown" },
                lsp = { blacklist_clients = {} },
            },

            symbols = {
                -- Include all except String and Constant:
                --   filter = { 'String', 'Constant', exclude = true }
                -- Only include Package, Module, and Function:
                --   filter = { 'Package', 'Module', 'Function' }
                filter = nil,
                -- You can use a custom function that returns the icon for each symbol kind.
                -- This function takes a kind (string) as parameter and should return an
                -- icon as string.
                icon_fetcher = nil,
                icon_source = "lspkind",
                -- Fallback
                icons = {
                    File = { icon = "󰈙", hl = "Identifier" },
                    Module = { icon = "", hl = "Include" },
                    Namespace = { icon = "󰅪", hl = "Include" },
                    Package = { icon = "󰏗", hl = "Include" },
                    Class = { icon = "󰠱", hl = "Type" },
                    Method = { icon = "󰆧", hl = "Function" },
                    Property = { icon = "󰜢", hl = "Identifier" },
                    Field = { icon = "󰜢", hl = "Identifier" },
                    Constructor = { icon = "", hl = "Special" },
                    Enum = { icon = "", hl = "Type" },
                    Interface = { icon = "", hl = "Type" },
                    Function = { icon = "󰊕", hl = "Function" },
                    Variable = { icon = "󰀫", hl = "Constant" },
                    Constant = { icon = "󰏿", hl = "Constant" },
                    String = { icon = "󰉿", hl = "String" },
                    Number = { icon = "#", hl = "Number" },
                    Boolean = { icon = "", hl = "Boolean" },
                    Array = { icon = "󰅪", hl = "Constant" },
                    Object = { icon = "⦿", hl = "Type" },
                    Key = { icon = "󰌋", hl = "Type" },
                    Null = { icon = "󰟢", hl = "Type" },
                    EnumMember = { icon = "", hl = "Identifier" },
                    Struct = { icon = "󰙅", hl = "Structure" },
                    Event = { icon = "", hl = "Type" },
                    Operator = { icon = "󰆕", hl = "Identifier" },
                    TypeParameter = { icon = "𝙏", hl = "Identifier" },
                    Component = { icon = "󰅴", hl = "Function" },
                    Fragment = { icon = "󰅴", hl = "Constant" },
                    TypeAlias = { icon = " ", hl = "Type" },
                    Parameter = { icon = " ", hl = "Identifier" },
                    StaticMethod = { icon = " ", hl = "Function" },
                    Macro = { icon = " ", hl = "Function" },
                },
            },
        })
    end,
}
