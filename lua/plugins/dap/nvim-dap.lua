return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        {
            "theHamsta/nvim-dap-virtual-text",
            opts = {},
        },

        "williamboman/mason.nvim",
        "jay-babu/mason-nvim-dap.nvim",

        "zyriab/npm-dap.nvim",
        "leoluz/nvim-dap-go",
        {
            "microsoft/vscode-js-debug",
            build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
        },
    },
    config = function()
        local mason_dap = require("mason-nvim-dap")
        local configure_ui = require("configs.dap.configure-ui")
        local set_keymaps = require("configs.dap.set-keymaps")
        local dap_go = require("dap-go")
        local setup_c_dap = require("configs.dap.setup-c-dap")
        local setup_js_dap = require("configs.dap.setup-js-dap")

        mason_dap.setup({
            -- Makes a best effort to setup the various debuggers with
            -- reasonable debug configurations
            automatic_setup = true,
            automatic_installation = true,

            -- You can provide additional configuration to the handlers,
            -- see mason-nvim-dap README for more information
            handlers = {},

            ensure_installed = {
                "delve",
                "codelldb",
                "cpptools",
            },
        })

        set_keymaps()
        configure_ui()

        -- Setup language specific stuff
        dap_go.setup()
        setup_c_dap()
        setup_js_dap()
    end,
}
