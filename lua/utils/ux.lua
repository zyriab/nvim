local M = {}

--- Call the given function then scrolls back to the original cursor position
---@param fn function a function to be called
M.call_with_preserved_cursor_position = function(fn)
    if not fn then
        return
    end

    local cursor = vim.api.nvim_win_get_cursor(0)
    fn()
    vim.api.nvim_win_set_cursor(0, cursor)
end

return M
