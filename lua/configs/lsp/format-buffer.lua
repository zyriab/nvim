local filetypes = require("utils.filetypes")
local formatters = require("utils.formatters")

local clang_types = {
    filetypes.c,
    filetypes.cpp,
    filetypes.arduino,
}

local prettier_types = {
    filetypes.javascript,
    filetypes.typescript,
    filetypes.jsx,
    filetypes.tsx,
    filetypes.json,
    filetypes.css,
}

-- List of all possible prettier config file names
local prettier_config_files = {
    ".prettierrc",
    ".prettierrc.json",
    ".prettierrc.yml",
    ".prettierrc.yaml",
    ".prettierrc.json5",
    ".prettierrc.js",
    ".prettierrc.cjs",
    ".prettierrc.mjs",
    ".prettierrc.toml",
    "prettier.config.js",
    "prettier.config.cjs",
    "prettier.config.mjs",
}

local function find_prettier_config(root_path)
    for _, config_file in ipairs(prettier_config_files) do
        local config_path = vim.fn.resolve(root_path .. "/" .. config_file)

        if vim.fn.filereadable(config_path) == 1 then
            return config_path
        end
    end

    return nil
end

--- Format current buffer based on filetype. Fallbacks to nvim-lsp formatter.
return function()
    local filetype = vim.bo.filetype

    -- [[ Markdown ]]
    if filetype == filetypes.markdown then
        return
    end

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

        local parser = "babel"
        if string.find(filetype, "typescript") then
            parser = parser .. "-ts"
        end

        local current_file_name = vim.fn.expand("%")
        local project_root = vim.fs.root(0, ".git") or "./"
        local prettier_config = find_prettier_config(project_root)

        if prettier_config == nil then
            vim.notify("Prettier configuration file could not be found, using LSP formatter", vim.log.levels.ERROR)
            goto FALLBACK
        end

        local bufnr = vim.api.nvim_get_current_buf()
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local buf_content = table.concat(lines, "\n")

        -- echo [file contents] | prettierd --no-color --parser=[parser] [filename]
        local cmd = {
            "sh",
            "-c",
            "echo "
                .. vim.fn.shellescape(buf_content)
                .. " | /usr/local/bin/prettierd --no-color --parser="
                .. parser
                .. " "
                .. vim.fn.shellescape(current_file_name),
        }
        local env = { PRETTIERD_DEFAULT_CONFIG = prettier_config }

        local ok = formatters.run_command_on_buffer(cmd, env)

        if not ok then
            goto FALLBACK
        end

        return
    end

    -- [[ Templ ]]
    if filetype == filetypes.templ then
        if vim.fn.executable("templ") ~= 1 then
            vim.notify("Templ is not installed, using LSP formatter", vim.log.levels.ERROR)
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
        local ok = formatters.run_command_on_buffer(cmd)

        if not ok then
            goto FALLBACK
        end

        return
    end

    -- [[ WebC ]]
    if filetype == filetypes.webc then
        formatters.lsp_format_skip_frontmatter()

        return
    end

    -- [[ Nix ]]
    if filetype == filetypes.nix then
        if vim.fn.executable("nixfmt") ~= 1 then
            vim.notify("nixfmt is not installed, skipping formatting", vim.log.levels.ERROR)
            return
        end

        -- FIXME: on NixOS, cannot find `_system.lua`
        local current_file_name = vim.fn.expand("%")
        local cmd = {
            "nixfmt <",
            "-w 80",
            current_file_name,
        }

        local ok = formatters.run_command_on_buffer(cmd)

        if not ok then
            goto FALLBACK
        end

        return
    end

    -- [[ SQL ]]
    if filetype == filetypes.sql then
        if vim.fn.executable("pg_format") ~= 1 then
            vim.notify("pg_format is not installed, skipping formatting", vim.log.levels.ERROR)
            return
        end

        local current_file_name = vim.fn.expand("%")
        local cmd = {
            "pg_format",
            "-w",
            "80",
            "--function-case",
            "2",
            "--type-case",
            "2",
            "--no-space-function",
            "--comma-start",
            "--comma-break",
            "--no-rcfile",
            current_file_name,
        }

        formatters.run_command_on_buffer(cmd)

        return
    end

    -- [[ Fallback ]]
    ::FALLBACK::
    vim.lsp.buf.format()
end
