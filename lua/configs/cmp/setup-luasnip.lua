local luasnip = require("luasnip")
local loader_vscode = require("luasnip.loaders.from_vscode")

-- Placeholder jumping is set in nvim-cmp config file
return function()
    vim.keymap.set("i", "<C-o>", function()
        if luasnip.choice_active() then
            luasnip.change_choice(1)
        end
    end, { desc = "[c-O] Cycle snippet's [O]ptions", silent = true })

    loader_vscode.lazy_load()

    require("luasnip.loaders.from_vscode").lazy_load()
    luasnip.config.setup({
        keep_roots = true,
        link_roots = true,
        link_children = true,
        update_events = { "TextChanged", "TextChangedI" },
        enable_autosnippets = true,
    })
end
