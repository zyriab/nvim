return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local nvim_tree = require("nvim-tree")

        -- Replacing netrw
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        vim.keymap.set("n", "<leader>ft", vim.cmd.NvimTreeToggle, { desc = "Toggle [F]ile[T]ree" })

        nvim_tree.setup({
            actions = {
                open_file = {
                    quit_on_open = true,
                },
            },
            update_focused_file = {
                enable = true,
            },
            renderer = {
                group_empty = true,
                full_name = true,
                indent_markers = {
                    enable = true,
                },
            },
            diagnostics = {
                enable = true,
                show_on_dirs = true,
            },
            modified = {
                enable = true,
            },
            view = {
                width = 50,
            },
            git = {
                enable = true,
                ignore = false,
                timeout = 500,
            },
        })
    end,
}
