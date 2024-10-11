---@diagnostic disable: missing-fields
local dap = require("dap")
local dapui = require("dapui")
local widgets = require("dap.ui.widgets")
local sign = vim.fn.sign_define

return function()
    -- Set up the sign and HL groups for points
    sign(
        "DapBreakpoint",
        { text = "󰃤", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
    )
    sign("DapBreakpointCondition", { text = "", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
    sign("DapLogPoint", { text = "󰛓", texthl = "DapLogPoint", linehl = "", numhl = "" })
    sign("DapStopped", { text = "󰓗", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })
    sign("DapBreakpointRejected", { text = "", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })

    dapui.setup({
        icons = { expanded = "", collapsed = "", current_frame = "󰸳" },
        controls = {
            icons = {
                pause = "",
                play = "",
                step_into = "",
                step_over = "",
                step_out = "",
                step_back = "",
                run_last = "",
                terminate = "",
                disconnect = "",
            },
        },
    })

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: See last session result." })
    vim.keymap.set({ "n", "v" }, "<Leader>dk", widgets.hover, { desc = "Debug: Open DAP hover menu" })

    vim.api.nvim_create_user_command("DapUiClose", dapui.close, {})

    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close
end
