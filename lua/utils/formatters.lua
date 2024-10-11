local M = {}

-- Executes the given command or print the error if it failed
-- Use this instead of `vim.cmd("%!foo %")`
--
--- @param cmd string[] Command to execute w/ arguments
--- @param bufnr? integer Number of the buffer the command shall operate on
--- @return boolean success Whether the operation succeeded or not
M.run_command_on_buffer = function(cmd, bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    local temp_file_name = vim.fn.tempname()

    vim.api.nvim_buf_call(bufnr, function()
        vim.cmd("silent write " .. vim.fn.fnameescape(temp_file_name))
    end)

    local temp_file = io.open(temp_file_name, "r")

    if temp_file == nil then
        vim.notify_once("Failed to read formatted file", vim.log.levels.ERROR)

        return false
    end

    local temp_content = temp_file:read("*all")
    temp_file:close()

    local modified_cmd = vim.deepcopy(cmd)

    for i, arg in ipairs(modified_cmd) do
        if arg == "%" or arg == vim.fn.expand("%") then
            modified_cmd[i] = temp_file_name
            break
        end
    end

    local opts = {
        input = temp_content,
        text = true,
    }

    local ok, result = pcall(function()
        return vim.system(modified_cmd, opts):wait()
    end)

    os.remove(temp_file_name)

    if not ok then
        vim.notify_once("Error running " .. cmd[1] .. ": " .. result, vim.log.levels.ERROR)
        return false
    end

    if result.code ~= 0 then
        local out = result.stderr ~= "" and result.stderr or result.stdout
        vim.notify_once("Could not format file: " .. out, vim.log.levels.ERROR)
        return false
    end

    local formatted = vim.split(result.stdout, "\n")

    -- Removing the empty line at the end if any
    if formatted[#formatted] == "" then
        table.remove(formatted)
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, formatted)

    return true
end

-- Format the current buffer using the LSP formatter.
-- Skips the frontmatter if present. (starts and ends with "---[a-zA-Z]*")
M.lsp_format_skip_frontmatter = function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -2, false)
    local in_frontmatter = false
    local frontmatter_start_line, frontmatter_end_line

    for i, line in ipairs(lines) do
        if line:match("^%-%-%-[%w]*$") then
            if not in_frontmatter then
                in_frontmatter = true
                frontmatter_start_line = i
            else
                frontmatter_end_line = i
                break
            end
        end
    end

    if frontmatter_start_line and frontmatter_end_line then
        -- Format everything except the frontmatter

        vim.lsp.buf.format({
            range = {
                ["start"] = { frontmatter_end_line + 1, 0 },
                ["end"] = { #lines + 1, 0 },
            },
        })
    else
        -- If no frontmatter, format the whole file
        vim.lsp.buf.format()
    end
end

return M
