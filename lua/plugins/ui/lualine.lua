---@diagnostic disable: undefined-field
return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "folke/noice.nvim" },
    config = function()
        local lualine = require("lualine")
        local custom_theme = require("lualine.themes.auto")
        local noice = require("noice")
        local filetypes = require("utils.filetypes")

        -- For the theme customization, see:
        ---@url https://github.com/projekt0n/github-nvim-theme/blob/d92e1143e5aaa0d7df28a26dd8ee2102df2cadd8/lua/github-theme/util/lualine.lua#L13C3-L21C6
        local gh_theme = require("github-theme.palette.github_dark_colorblind")
        local colors = gh_theme.generate_spec(gh_theme.palette)
        local C = require("github-theme.lib.color")

        local function blend(color, a)
            return C(colors.bg1):blend(C(color), a):to_css()
        end

        --- Create lualine group colors for github-theme
        ---@param color string
        local tint = function(color)
            return {
                a = { bg = color, fg = colors.bg1 },
                b = { bg = blend(color, 0.2), fg = blend(color, 0.8) },
                c = { bg = blend(color, 0.01), fg = blend(color, 0.60) },
            }
        end

        custom_theme.insert = tint(gh_theme.palette.yellow.base)
        custom_theme.visual = tint(colors.sel0)

        lualine.setup({
            options = {
                theme = custom_theme,
                globalstatus = true,
                ignore_focus = { filetypes.nvimtree, filetypes.outline },
            },
            sections = {
                lualine_x = {
                    {
                        noice.api.status.command.get,
                        cond = noice.api.status.command.has,
                        color = { fg = colors.syntax.keyword },
                    },
                    {
                        noice.api.status.search.get,
                        cond = noice.api.status.search.has,
                        color = { fg = colors.syntax.keyword },
                    },
                },
            },
        })
    end,
}
