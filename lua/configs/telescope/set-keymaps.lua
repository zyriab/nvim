local telescope = require("telescope")
local builtin = require("telescope.builtin")
local themes = require("telescope.themes")
local telescope_live_grep_open_files = require("configs.telescope.live-grep-open-files")

local current_buffer_fuzzy_find_config = {
    previewer = false,
}

local notify_config = { layout_strategy = "vertical" }

return function()
    -- See `:help telescope.builtin`
    vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind existing [B]uffers" })
    vim.keymap.set("n", "<leader>/", function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        builtin.current_buffer_fuzzy_find(themes.get_dropdown(current_buffer_fuzzy_find_config))
    end, { desc = "[/] Fuzzily search in current buffer" })

    vim.keymap.set("n", "<leader>so", telescope_live_grep_open_files, { desc = "[S]earch in [O]pen files" })
    -- vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
    vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "[F]ind [G]it files" })
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
    vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
    vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
    vim.keymap.set(
        "n",
        "<leader>sg",
        telescope.extensions.live_grep_args.live_grep_args,
        { desc = "[S]earch by [G]rep w/ glob args" }
    )
    vim.keymap.set("n", "<leader>sG", ":LiveGrepGitRoot<cr>", { desc = "[S]earch by [G]rep on Git root" })
    vim.keymap.set("n", "<leader>sd", function()
        builtin.diagnostics({ bufnr = 0 })
    end, { desc = "[S]earch document [D]iagnostics" })
    vim.keymap.set("n", "<leader>sD", builtin.diagnostics, { desc = "[S]earch workspace [D]iagnostics" })
    vim.keymap.set("n", "<leader>rs", builtin.resume, { desc = "[R]esume [S]earch" })
    vim.keymap.set("n", "<leader>sn", function()
        telescope.extensions.notify.notify(notify_config)
    end, { desc = "[S]earch [N]otifications" })

    -- NOTE:
    -- For `<leader>sg`, you can use glob patterns.
    -- Grep client in all files under src, ignore tsx files: "client" --iglob src/** --iglob !*.tsx
    -- Grep client in all files under src, ignore components: "client" --iglob src/** --iglob !**/components/**
    -- Grep client in all files under any components directory: "client" --iglob **/components/**
    -- For more info, look into `ripgrep`
end
