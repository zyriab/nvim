local set_keymaps = require("configs.lsp.set-keymaps")
local format_buffer = require("configs.lsp.format-buffer")

--  This function gets run when an LSP connects to a particular buffer.
--- @param _ any
--- @param bufnr integer
return function(_, bufnr)
    set_keymaps()

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, "Format", format_buffer, { desc = "Format current buffer with LSP" })
end
