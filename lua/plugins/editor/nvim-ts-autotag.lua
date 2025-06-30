local filetypes = require("utils.filetypes")
return {
    "windwp/nvim-ts-autotag",
    config = function()
        local autotag = require("nvim-ts-autotag")
        local tag_configs = require("nvim-ts-autotag.config.init")

        autotag.setup({
            aliases = {
                [filetypes.webc] = filetypes.html,
            },
        })
    end,
}
