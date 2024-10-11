local filetypes = require("utils.filetypes")
return {
    "windwp/nvim-ts-autotag",
    config = function()
        local autotag = require("nvim-ts-autotag")
        local tag_configs = require("nvim-ts-autotag.config.init")

        -- if this happens: https://github.com/windwp/nvim-ts-autotag/issues/19
        -- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        -- 	underline = true,
        -- 	virtual_text = {
        -- 		spacing = 5,
        -- 		severity_limit = "Warning",
        -- 	},
        -- 	update_in_insert = true,
        -- })

        autotag.setup({
            aliases = {
                [filetypes.webc] = filetypes.html,
            },
        })
    end,
}
