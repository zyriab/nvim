return {
    "theprimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")

        harpoon:setup({
            settings = {
                save_on_toggle = true,
                sync_on_ui_close = true,
            },
        })

        vim.keymap.set("n", "<leader>a", function()
            harpoon:list():add()
        end, { desc = "Harpoon: [A]ppend file" })
        vim.keymap.set("n", "<leader>m", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, { desc = "Harpoon: open quick [M]enu" })

        -- Map <c-1> to <c-9> to go to the corresponding file in the list
        for i = 1, 9, 1 do
            vim.keymap.set("n", string.format("<c-%d>", i), function()
                harpoon:list():select(i)
            end, { desc = string.format("harpoon: [c-%d] go to file #%d", i, i) })
        end
    end,
}
