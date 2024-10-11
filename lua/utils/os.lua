local M = {}

M.get_os = function()
    return vim.loop.os_uname().sysname
end

M.is_linux = function()
    return M.get_os() == "Linux"
end

M.is_macosx = function()
    return M.get_os() == "Darwin"
end

return M
