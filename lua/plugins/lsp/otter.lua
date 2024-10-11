return {
    "jmbuhr/otter.nvim",
    dependencies = {
        "hrsh7th/nvim-cmp",
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        local otter = require("otter")
        local filetypes = require("utils.filetypes")
        local telescope = require("telescope.builtin")
        local format_buffer = require("configs.lsp.format-buffer")

        otter.setup({
            lsp = {
                hover = {
                    border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
                },
                -- `:h events` that cause the diagnostics to update.
                diagnostic_update_events = { "BufWritePost", "InsertLeave", "TextChanged" },
            },
            buffers = {
                -- if set to true, the filetype of the otterbuffers will be set.
                -- otherwise only the autocommand of lspconfig that attaches
                -- the language server will be executed without setting the filetype
                set_filetype = false,
                -- write <path>.otter.<embedded language extension> files
                -- to disk on save of main buffer.
                -- usefule for some linters that require actual files
                -- otter files are deleted on quit or main buffer close
                write_to_disk = true,
            },
            strip_wrapping_quote_characters = { "'", "\"", "`" },
            -- Otter may not work the way you expect when entire code blocks are indented (eg. in Org files)
            -- When true, otter handles these cases fully. This is a (minor) performance hit
            handle_leading_whitespace = true,
        })

        -- Autoactivate Otter
        local augroup = vim.api.nvim_create_augroup("otter-activate", { clear = true })
        vim.api.nvim_create_autocmd("BufEnter", {
            group = augroup,
            callback = function()
                local filetype = vim.bo.filetype

                local function on_list(options)
                    vim.fn.setqflist({}, " ", options)
                    vim.cmd.cfirst()
                end

                vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "[R]e[n]ame" })

                vim.keymap.set("n", "<leader>fm", format_buffer, { desc = "[F]or[M]at the current buffer with LSP" })

                if filetype == filetypes.html or filetype == filetypes.webc then
                    vim.keymap.set("n", "gd", function()
                        vim.lsp.buf.definition({ on_list })
                    end, { desc = "[G]oto [D]efinition" })

                    vim.keymap.set("n", "gr", function()
                        vim.lsp.buf.references(nil, { on_list })
                    end, { desc = "[G]oto [R]eferences" })

                    vim.keymap.set("n", "<leader>D", function()
                        vim.lsp.buf.type_definition({ on_list })
                    end, { desc = "Type [D]efinition" })

                    vim.keymap.set("n", "gi", function()
                        vim.lsp.buf.implementation({ on_list })
                    end, { desc = "[G]oto [I]mplementation" })

                    vim.keymap.set("n", "<leader>ds", function()
                        vim.lsp.buf.document_symbol({ on_list })
                    end, { desc = "[D]ocument [S]ymbols" })

                    vim.keymap.set("n", "<leader>ws", function()
                        vim.lsp.buf.workspace_symbol("", { on_list })
                    end, { desc = "[W]orkspace [S]ymbols" })

                    otter.activate({ "javascript", "css", "html", "typescript" })
                else
                    vim.keymap.set("n", "gd", telescope.lsp_definitions, { desc = "[G]oto [D]efinition" })
                    vim.keymap.set("n", "gr", telescope.lsp_references, { desc = "[G]oto [R]eferences" })
                    vim.keymap.set("n", "<leader>D", telescope.lsp_type_definitions, { desc = "Type [D]efinition" })
                    vim.keymap.set("n", "gi", telescope.lsp_implementations, { desc = "[G]oto [I]mplementation" })
                    vim.keymap.set("n", "<leader>ds", telescope.lsp_document_symbols, { desc = "[D]ocument [S]ymbols" })

                    vim.keymap.set(
                        "n",
                        "<leader>ws",
                        telescope.lsp_dynamic_workspace_symbols,
                        { desc = "[W]orkspace [S]ymbols" }
                    )
                end
            end,
        })
    end,
}
