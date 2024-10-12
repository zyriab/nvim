local filetypes = require("utils.filetypes")
local ux = require("utils.ux")
local formatters = require("utils.formatters")

local clang_types = {
    filetypes.c,
    filetypes.cpp,
    filetypes.arduino,
}

local prettier_types = {
    filetypes.javascript,
    filetypes.javascriptreact,
    filetypes.typescript,
    filetypes.typescriptreact,
    filetypes.jsx,
    filetypes.tsx,
    filetypes.json,
    filetypes.css,
}

--- Format current buffer based on filetype. Fallbacks to nvim-lsp formatter.
return function()
    local filetype = vim.bo.filetype

    -- [[ C/C++/Arduino ]]
    if vim.tbl_contains(clang_types, filetype) then
        if vim.fn.executable("clang-format") ~= 1 then
            vim.notify("clang-format is not installed, using LSP formatter", vim.log.levels.ERROR)
            goto FALLBACK
        end

        local current_file_name = vim.fn.expand("%")
        local cmd = { "clang-format", current_file_name }
        _ = formatters.run_command_on_buffer(cmd)

        return
    end

    -- [[ Go ]]
    if filetype == filetypes.go then
        if vim.fn.executable("gofumpt") ~= 1 then
            vim.notify("gofumpt is not installed, using LSP formatter", vim.log.levels.ERROR)
            goto FALLBACK
        end

        local current_file_name = vim.fn.expand("%")
        local cmd = { "gofumpt", current_file_name }

        local ok = formatters.run_command_on_buffer(cmd)

        if not ok then
            return
        end

        cmd = {
            "golines",
            current_file_name,
            "--max-len=80",
            "--ignore-generated",
            "--ignored-dirs=vendor,node_modules",
        }

        _ = formatters.run_command_on_buffer(cmd)

        return
    end

    -- [[ Lua ]]
    if filetype == filetypes.lua then
        local ok, stylua = pcall(require, "stylua-nvim")

        if not ok then
            vim.notify("Stylua is not installed, using LSP formatter", vim.log.levels.ERROR)
            goto FALLBACK
        end

        stylua.format_file()

        return
    end

    -- [[ JS/TS/Json/CSS ]]
    if vim.tbl_contains(prettier_types, filetype) then
        if vim.fn.executable("prettierd") ~= 1 then
            vim.notify("Prettierd is not installed, using LSP formatter", vim.log.levels.ERROR)
            goto FALLBACK
        end

        local current_file_name = vim.fn.expand("%:t")
        local cmd = { "prettierd", "--no-color", current_file_name }
        local ok = formatters.run_command_on_buffer(cmd)

        if not ok then
            goto FALLBACK
        end

        return
    end

    -- [[ WebC/Markdown ]]
    if filetype == filetypes.webc or filetype == filetypes.markdown then
        formatters.lsp_format_skip_frontmatter()

        return
    end

    -- [[ templ ]]
    if filetype == filetypes.templ then
        if vim.fn.executable("templ") ~= 1 then
            vim.notify("templ is not installed, using LSP formatter", vim.log.levels.ERROR)
            goto FALLBACK
        end

        local current_file_name = vim.fn.expand("%")
        local cmd = {
            "templ",
            "fmt",
            "-stdout",
            "-log-level",
            "error",
            current_file_name,
        }
        _ = formatters.run_command_on_buffer(cmd)

        return
    end

    -- [[ Fallback ]]
    ::FALLBACK::
    vim.lsp.buf.format()
end
