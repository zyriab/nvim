return {
    "b0o/incline.nvim",
    event = "VeryLazy",
    config = function()
        local incline = require("incline")
        local render = require("configs.incline.render")
        local theme = require("github-theme.palette.github_dark_colorblind")
        local filetypes = require("utils.filetypes")
        local colors = theme.generate_spec(theme.palette)

        incline.setup({
            hide = {
                cursorline = true,
                focused_win = true,
                only_win = true,
            },
            ignore = {
                buftypes = {},
                filetypes = { filetypes.outline, filetypes.nvimtree },
                floating_wins = true,
                unlisted_buffers = false,
                -- wintypes = {},
            },
            window = {
                zindex = 49,
                -- width = "fill",
                width = "fit",
                margin = {
                    vertical = 1,
                    horizontal = 1,
                },
                placement = {
                    vertical = "bottom",
                    horizontal = "right",
                },
                winhighlight = {
                    NormalNC = {
                        guibg = colors.bg3,
                    },
                },
            },
            highlight = {
                groups = {
                    InclineNormal = {
                        default = true,
                        group = "IncineNormalFloat",
                    },
                    InclineNormalNC = {
                        default = true,
                        group = "InclineNormalFloatNC",
                    },
                },
            },
            render = render,
        })
    end,
}
