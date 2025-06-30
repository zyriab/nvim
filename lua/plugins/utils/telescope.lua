return {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-live-grep-args.nvim",
        "nvim-telescope/telescope-file-browser.nvim",
        -- Fuzzy Finder Algorithm which requires local dependencies to be built.
        -- Only load if `make` is available. Make sure you have the system
        -- requirements installed.
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            -- NOTE: If you are having trouble with this installation,
            --       refer to the README for telescope-fzf-native for more instructions.
            build = "make",
            cond = function()
                return vim.fn.executable("make") == 1
            end,
        },
    },
    config = function()
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")
        local t_actions = require("telescope.actions")
        local t_actions_state = require("telescope.actions.state")
        local load_extensions = require("configs.telescope.load-extensions")
        local live_grep_git_root = require("configs.telescope.live-grep-git-root")
        local set_keymaps = require("configs.telescope.set-keymaps")

        local PROJECTS_PATH = "~/Developer"

        ---@param prompt_bufnr integer
        local function nav_to_and_open_selected_cwd(prompt_bufnr)
            local entry = t_actions_state.get_selected_entry()
            t_actions.close(prompt_bufnr)

            vim.cmd.cd(entry.path)
            builtin.find_files({ cwd = entry.path })

            vim.notify("Changed directory to " .. entry.path)
        end

        -- See `:help telescope` and `:help telescope.setup()`
        telescope.setup({
            defaults = {
                file_ignore_patterns = { "node_modules", "OUTLINE_*", "*.otter.*" },
            },
            pickers = {
                find_files = {
                    -- Override .gitignore for `*_sqlc.go` and `*.sql.go` which are
                    -- generated files from SQLc
                    find_command = {
                        "sh",
                        "-c",
                        "(rg --files && rg --files --glob '*_sqlc.go' --glob '*.sql.go' --hidden --no-ignore) | sort | uniq",
                    },
                },
            },
            extensions = {
                file_browser = {
                    theme = "ivy",
                    path = PROJECTS_PATH,
                    prompt_title = "Projects 󱜙",
                    previewer = false,
                    initial_mode = "normal",
                    mappings = {
                        ["i"] = {
                            ["<C-o>"] = nav_to_and_open_selected_cwd,
                        },
                        ["n"] = {
                            ["o"] = nav_to_and_open_selected_cwd,
                            ["<C-o>"] = nav_to_and_open_selected_cwd,
                        },
                    },
                },
            },
        })

        load_extensions()

        vim.api.nvim_create_user_command("LiveGrepGitRoot", live_grep_git_root, {})

        set_keymaps()
    end,
}
