local dap = require("dap")

return function()
    dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
            -- TODO(C-DAP): update this for Linux :)
            command = "/usr/local/bin/lldb-vscode",
            args = { "--port", "${port}" },
        },
    }

    dap.configurations.c = {
        {
            name = "Launch file",
            type = "codelldb",
            request = "launch",
            program = function()
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
        },
    }
end
