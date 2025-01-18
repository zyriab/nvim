local dap = require("dap")
local npm_dap = require("npm-dap")
local utils = require("dap.utils")

--- Gets a path to a package in the Mason registry.
--- Prefer this to `get_package`, since the package might not always be
--- available yet and trigger errors.
--  See https://github.com/mxsdev/nvim-dap-vscode-js/issues/58#issuecomment-2582575821
---@param pkg string
---@param path? string
local function get_pkg_path(pkg, path)
    pcall(require, "mason")
    local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
    path = path or ""
    local ret = root .. "/packages/" .. pkg .. "/" .. path
    return ret
end

return function()
    -- See: https://www.lazyvim.org/extras/lang/typescript#nvim-dap
    if not dap.adapters["pwa-node"] then
        dap.adapters["pwa-node"] = {
            type = "server",
            host = "localhost",
            port = "${port}",
            executable = {
                command = "node",
                args = {
                    get_pkg_path("js-debug-adapter", "/js-debug/src/dapDebugServer.js"),
                    "${port}",
                },
            },
        }
    end

    for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        local node_client = "node"

        if language == "typescript" or language == "typescriptreact" then
            node_client = "ts-node"
        end

        dap.configurations[language] = {
            -- NODE
            {
                name = "Launch file",
                type = "pwa-node",
                request = "launch",
                program = "${file}",
                cwd = "${workspaceFolder}",
                rootPath = "${workspaceFolder}",
                sourceMaps = true,
                skilpFiles = { "<node_internals>/**" },
                protocol = "inspector",
                -- console = "integratedTerminal",
                runtimeExecutable = node_client,
            },
            {
                name = "Attach",
                type = "pwa-node",
                request = "attach",
                cwd = "${workspaceFolder}",
                rootPath = "${workspaceFolder}",
                sourceMaps = true,
                skilpFiles = { "<node_internals>/**" },
                protocol = "inspector",
                console = "integratedTerminal",
                processId = utils.pick_process,
                runtimeExecutable = node_client,
                outFiles = { "${workspaceFolder}/dist/**/*.js" },
            },
            -- ENDOF NODE
            -- JEST
            {
                name = "Debug Jest tests",
                type = "pwa-node",
                request = "launch",
                -- trace = true, -- include debugger info
                runtimeExecutable = node_client,
                runtimeArgs = {
                    "./node_modules/jest/bin/jest.js",
                    "--runInBand",
                },
                rootPath = "${workspaceFolder}",
                cwd = "${workspaceFolder}",
                console = "integratedTerminal",
                outFiles = { "${workspaceFolder}/dist/**/*.js" },
                internalConsoleOptions = "neverOpen",
            },
            -- ENDOF JEST
        }
    end

    npm_dap.setup()
end
