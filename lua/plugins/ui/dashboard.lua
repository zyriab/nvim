return {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
    config = function()
        local dashboard = require("dashboard")
        local bible_verse = require("bible-verse")
        local bv_utils = require("bible-verse.utils")
        local telescope = require("telescope")
        local t_builtin = require("telescope.builtin")
        local session_manager = require("session_manager")

        local function get_footer()
            local verses_result = bible_verse.query({ random = true })
            local verses_fmt_table = { "", "" }
            for _, verse in ipairs(verses_result) do
                local formatted_verse =
                    string.format("%s - %s %s:%s", verse.verse, verse.book, verse.chapter, verse.verse_number)
                table.insert(verses_fmt_table, formatted_verse)
            end

            table.insert(verses_fmt_table, "")

            -- Apply wrapping at half of editor's width
            local verses_fmt_wrap_table = bv_utils.wrap(verses_fmt_table, math.floor(vim.o.columns * 0.5))
            return verses_fmt_wrap_table
        end

        local function show_sessions()
            session_manager.load_session(false)
        end

        local function nav_to_config()
            local path = "~/.config/nvim"
            vim.cmd.cd(path)
            t_builtin.find_files({ cwd = path })
        end

        dashboard.setup({
            theme = "hyper",
            config = {
                packages = { enable = true },
                project = { icon = "󱜙" },
                mru = { icon = "" },
                header = {
                    "",
                    "",
                    "  /0000000             /00                /0000000            /00                                    ",
                    "| 0__   00           | 00               | 00__  00          | 00                                   ",
                    "| 00  \\ 00 /11   /11 /000000    /111111 | 00  \\ 00  /111111 | 00   /00  /111111   /000000   /1111111",
                    "| 0000000 | 11  | 11|_  00_/   /11__  11| 0000000  |____  11| 00  /00/ /11__  11 /00__  00 /11_____/",
                    "| 00__  00| 11  | 11  | 00    | 11111111| 00__  00  /1111111| 000000/ | 11111111| 00  \\__/|  111111 ",
                    "| 00  \\ 00| 11  | 11  | 00 /00| 11_____/| 00  \\ 00 /11__  11| 00_  00 | 11_____/| 00       \\____  11",
                    "| 0000000/|  1111111  |  0000/|  1111111| 0000000/|  1111111| 00 \\  00|  1111111| 00       /1111111/",
                    "|_______/  \\____  11   \\___/   \\_______/|_______/  \\_______/|__/  \\__/ \\_______/|__/      |_______/ ",
                    "           /11  | 11                                                                                ",
                    "          |  111111/                                                                                ",
                    "           \\______/                                                                                 ",
                    "",
                    "",
                },

                footer = get_footer,

                shortcut = {
                    {
                        desc = " Update ",
                        group = "DiagnosticWarn",
                        action = "Lazy update",
                        key = "u",
                    },
                    {
                        desc = "󰚰 Sessions ",
                        group = "DiagnosticInfo",
                        action = show_sessions,
                        key = "s",
                    },

                    {
                        desc = "󱜙 Projects ",
                        group = "DiagnosticError",
                        action = telescope.extensions.file_browser.file_browser,
                        key = "p",
                    },
                    {
                        desc = " Config ",
                        group = "DiagnosticHint",
                        action = nav_to_config,
                        key = "c",
                    },
                },
            },
        })
    end,
}
