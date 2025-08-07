return {
    "zyriab/github-nvim-theme",
    lazy = false,
    priority = 1000,
    dependencies = {
        "xiyaowong/transparent.nvim",
        opts = {
            groups = { -- table: default groups
                "Normal",
                "NormalNC",
                "Comment",
                "Constant",
                "Special",
                "Identifier",
                "Statement",
                "PreProc",
                "Type",
                "Underlined",
                "Todo",
                "String",
                "Function",
                "Conditional",
                "Repeat",
                "Operator",
                "Structure",
                "LineNr",
                "NonText",
                "SignColumn",
                "StatusLine",
                "StatusLineNC",
                "EndOfBuffer",
            },
            extra_groups = {
                "NvimTreeNormal",
                "NormalFloat",
                "NvimTreeEndOfBuffer",
                "StatusLine",
                "StatusLineNC",
                "CmpItemMenu",
                "NoiceScrollbar",
            }, -- table: additional groups that should be cleared
            exclude_groups = {
                "CursorLine",
                "CursorLineNr",
                "CursorColumn",
                "InclineNormalFloat",
                "InclineNormalFloatNC",
            }, -- table: groups you don't want to clear,
        },
    },
    config = function()
        local transparent = require("transparent")
        local theme = require("github-theme")
        local palette1 = require("github-theme.palette.github_dark_colorblind")
        local palette2 = require("github-theme.palette.github_dark")
        local colors1 = palette1.generate_spec(palette1.palette)
        local colors2 = palette2.generate_spec(palette2.palette)

        local matching_highlight_color = colors2.sel2
        local fluo_pk = "#ef0fff"
        local fluo_gr = "#38d878"
        local blk = "#000000"
        local wht = "#ffffff"

        theme.setup({
            palette = {},
            groups = {
                all = {
                    CursorLine = { bg = colors1.sel1 },
                    ColorColumn = { bg = colors2.bg1 },

                    -- Inspired by Firefox dev edition
                    Search = { bg = fluo_pk, fg = wht },
                    IncSearch = { bg = fluo_gr, fg = blk },

                    -- Indent-blankline
                    IblScope = { fg = colors1.syntax.func },
                    IblIndent = { fg = colors1.fg3 },

                    -- Illuminate
                    IlluminatedWordText = { gui = "NONE", bg = matching_highlight_color },
                    IlluminatedWordRead = { gui = "NONE", bg = matching_highlight_color },
                    IlluminatedWordWrite = { gui = "NONE", bg = matching_highlight_color },

                    -- Lightbulb
                    LightBulbSign = { fg = fluo_gr },

                    -- LspSignature
                    LspSignatureActiveParameter = { bg = colors1.sel2, fg = blk },

                    -- DAP
                    DapStopped = { bg = colors1.sel2, fg = blk },
                    DapBreakpointCondition = { fg = colors1.diag.hint },
                    DapBreakpointRejected = { fg = colors1.diag.error },
                    DapLogPoint = { fg = colors1.diag.info },

                    -- Dashboard
                    DashboardFooter = { fg = colors1.diag.hint },
                    DashboardProjectTitle = { fg = colors1.diag.warn },
                    DashboardProjectTitleIcon = { fg = colors1.fg1 },
                    DashboardMruTitle = { fg = colors1.diag.info },
                    DashboardMruIcon = { fg = colors1.fg1 },

                    -- Copilot-cmp
                    CmpItemKindCopilot = { fg = colors1.syntax.string },
                },
            },
            options = {
                transparent = true,
                hide_end_of_buffer = false,
            },
        })

        transparent.clear_prefix("WhichKey")
        transparent.clear_prefix("Lazy")
        -- The tabs do not display well if transparent
        -- transparent.clear_prefix("Mason")

        vim.cmd.colorscheme("github_dark_colorblind")
    end,
}
