return function(bufnr)
    local format_buffer = require("configs.lsp.format-buffer")
    local telescope_builtin = require("telescope.builtin")

    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    -- NOTE: Using otter.nvim
    -- nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>ca", function()
        ---@diagnostic disable-next-line: missing-fields
        vim.lsp.buf.code_action({ context = { only = { "quickfix", "refactor", "source" } } })
    end, "[C]ode [A]ction")

    -- NOTE: Using otter.nvim
    -- nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
    -- nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    -- nmap("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
    -- nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
    -- nmap("gi", telescope_builtin.lsp_implementations, "[G]oto [I]mplementation")
    -- nmap("<leader>ws", telescope_builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

    -- NOTE: Using otter.nvim
    -- nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    --
    -- TODO: find a way to toggle signature help
    vim.keymap.set({ "n", "i", "v" }, "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Documentation" })

    -- Lesser used LSP functionality
    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
    nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[W]orkspace [L]ist Folders")

    -- [[ Diagnostic ]]
    nmap("[d", vim.diagnostic.goto_prev, "Go to previous [[] [D]iagnostic message")
    nmap("]d", vim.diagnostic.goto_next, "Go to next []] [D]agnostic message")
    nmap("<leader>dl", vim.diagnostic.setqflist, "Open [D]iagnostics [L]ist")
    nmap("<leader>df", function()
        vim.diagnostic.open_float({ source = true })
    end, "Open [D]iagnostic [F]loating window")

    -- [[ Format ]]
    nmap("<leader>fm", format_buffer, "[F]or[M]at the current buffer with LSP")

    -- [[ Go ]]
    nmap("<leader>gie", vim.cmd.GoIfErr, "[G]o [I]f [E]rror (snippet)")
    nmap("<leader>gtg", vim.cmd.GoTestsAll, "[G]o [T]est [G]enerate for all fn")
    nmap("<leader>gg", function()
        vim.cmd("!templ generate")
    end, "[G]o [G]enerate Templ file")
end
