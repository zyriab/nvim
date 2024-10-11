local M = {}

local TERMINAL_HEIGHT = 15

M.toggle_terminal = function()
    local is_open = vim.g.term_win_id ~= nil and vim.api.nvim_win_is_valid(vim.g.term_win_id)

    if is_open then
        vim.api.nvim_win_hide(vim.g.term_win_id)
        vim.g.term_win_id = nil
        return
    end

    -- Open new window TERMINAL_HEIGHT lines tall at the bottom of the screen
    vim.cmd(string.format("botright %d new", TERMINAL_HEIGHT))
    vim.g.term_win_id = vim.api.nvim_get_current_win()

    local has_term_buf = vim.g.term_buf_id ~= nil and vim.api.nvim_buf_is_valid(vim.g.term_buf_id)

    if has_term_buf then
        vim.api.nvim_win_set_buf(vim.g.term_win_id, vim.g.term_buf_id)
    else
        vim.cmd.term()
        vim.g.term_buf_id = vim.api.nvim_get_current_buf()
    end

    vim.cmd.startinsert()
end

M.kill_terminal = function()
    if vim.g.term_win_id ~= nil then
        vim.api.nvim_win_close(vim.g.term_win_id, true)
        vim.g.term_win_id = nil
    end
    if vim.g.term_buf_id ~= nil then
        vim.api.nvim_buf_delete(vim.g.term_buf_id, { force = true })
        vim.g.term_buf_id = nil
    end
end

return M
