local dap = require("dap")
local dap_go = require("dap-go")
local persistent_breakpoints = require("persistent-breakpoints.api")

return function()
    vim.keymap.set("n", "<F1>", dap.step_into, { desc = "Debug: Step Into" })
    vim.keymap.set("n", "<F2>", dap.step_over, { desc = "Debug: Step Over" })
    vim.keymap.set("n", "<F3>", dap.step_out, { desc = "Debug: Step Out" })
    vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
    vim.keymap.set("n", "<leader><F5>", dap.terminate, { desc = "Debug: Teminate session" })

    vim.keymap.set("n", "<leader>b", persistent_breakpoints.toggle_breakpoint, { desc = "Debug: Toggle [B]reakpoint" })
    vim.keymap.set(
        "n",
        "<leader>B",
        persistent_breakpoints.set_conditional_breakpoint,
        { desc = "Debug: Set conditional [B]reakpoint" }
    )
    vim.keymap.set(
        "n",
        "<leader>cb",
        persistent_breakpoints.clear_all_breakpoints,
        { desc = "Debug: [C]lear [B]reakpoints" }
    )

    -- [[ Go ]]
    vim.keymap.set("n", "<leader>gdt", function()
        dap_go.debug_test()
    end, { desc = "Debug: [G]o [D]ebug [T]est" })

    vim.keymap.set("n", "<leader>gdl", function()
        dap_go.debug_test()
    end, { desc = "Debug: [G]o [D]ebug [L]ast test" })

    -- NOTE: replaced by `persistent_breakpoints` plugin
    -- vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle [B]reakpoint" })
    -- vim.keymap.set("n", "<leader>B", function()
    --     dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    -- end, { desc = "Debug: Set conditional [B]reakpoint" })
    -- vim.keymap.set("n", "<leader>cb", dap.clear_breakpoints, { desc = "Debug: [C]lear [B]reakpoints" })
end
