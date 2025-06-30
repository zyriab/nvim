return {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
        {
            "williamboman/mason.nvim",
            opts = { ui = { border = "rounded" } },
            config = true,
        },
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        local setup_autoformat = require("configs.lsp.setup-autoformat")
        local register_which_keys = require("configs.lsp.register-which-keys")
        local setup_servers = require("configs.lsp.setup-servers")
        local configure_ui = require("configs.lsp.configure-ui")

        register_which_keys()
        setup_autoformat()
        setup_servers()
        configure_ui()
    end,
}
