local neodev = require("neodev")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local lspconfig = require("lspconfig")
local schemastore = require("schemastore")
local on_attach = require("configs.lsp.on-attach")
local filetypes = require("utils.filetypes")

-- Enable the following language servers
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.

--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
    bashls = {},
    clangd = {},
    cssls = {},
    dockerls = {},
    eslint = {},
    graphql = {},
    marksman = {},
    sqlls = {},
    taplo = {},
    terraformls = {},

    arduino_language_server = {
        cmd = {
            "arduino-language-server",
            "-cli-config",
            "$HOME/Library/Arduino15/arduino-cli.yaml",
            "-fqbn",
            "arduino:avr:uno",
        },
    },

    emmet_language_server = {
        filetypes = {
            filetypes.html,
            filetypes.htmx,
            filetypes.liquid,
            filetypes.markdown,
            filetypes.templ,
            filetypes.webc,
        },
    },

    ---@url https://github.com/golang/tools/tree/master/gopls/doc
    gopls = {
        cmd = { "gopls", "--remote=auto" },
        settings = {
            gopls = {
                gofumpt = true,
                staticcheck = true,
                usePlaceholders = true,
                completeUnimported = true,
                hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    compositeLiteralTypes = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                },
                analyses = {
                    unreachable = true,
                    nilness = true,
                    ST1003 = true,
                    fieldalignment = true,
                    unusedvariable = true,
                    unusedParams = true,
                    useany = true,
                },
            },
        },
        filetypes = {
            filetypes.go,
            filetypes.gomod,
            filetypes.gotmpl,
            filetypes.gowork,
        },
    },

    golangci_lint_ls = {
        cmd = { "golangci-lint-langserver" },
        init_options = {
            command = {
                "golangci-lint",
                "run",
                "--enable-all",
                "--disable",
                "lll,varnamelen,depguard,funlen,gci,godox,godot,gochecknoglobals,exportloopref,gomnd",
                "--out-format",
                "json",
                "--issues-exit-code=1",
            },
        },
        filetypes = {
            filetypes.go,
            filetypes.gomod,
            filetypes.gotmpl,
            filetypes.gowork,
        },
    },

    html = {
        filetypes = {
            filetypes.html,
            filetypes.htmx,
            filetypes.liquid,
            filetypes.markdown,
            filetypes.templ,
            filetypes.webc,
        },
    },

    htmx = {
        filetypes = {
            filetypes.html,
            filetypes.htmx,
            filetypes.templ,
            filetypes.webc,
        },
    },

    jsonls = {
        settings = {
            json = {
                schemas = schemastore.json.schemas(),
                validate = { enable = true },
            },
        },
    },

    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
        },
    },

    tailwindcss = {
        filetypes = {
            filetypes.html,
            filetypes.htmx,
            filetypes.liquid,
            filetypes.markdown,
            filetypes.templ,
        },
        init_options = { userLanguages = { templ = "html" } },
    },

    templ = {
        cmd = { "templ", "lsp", "-log", "/Users/zyr/tmp/logs/templ.log" },
        filetypes = { filetypes.templ },
    },

    ts_ls = {
        implicitProjectConfiguration = {
            checkJs = true,
        },
    },

    yamlls = {
        settings = {
            yaml = {
                schemaStore = {
                    -- You must disable built-in schemaStore support if you want to use
                    -- this plugin and its advanced options like `ignore`.
                    enable = false,
                    -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                    url = "",
                },
                schemas = schemastore.yaml.schemas(),
            },
        },
    },
}

local mason_tools_installs = vim.tbl_extend("keep", {}, vim.tbl_keys(servers))

local function setup_handlers(capabilities)
    -- Add specific handlers for servers that need custom setup
    for server_name, server_config in next, servers, nil do
        lspconfig[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            cmd = server_config.cmd,
            settings = server_config.settings,
            filetypes = server_config.filetypes,
            init_options = server_config.init_options,
            single_file_support = true,
        })
    end
end

return function()
    -- mason-lspconfig requires that these setup functions are called in this order
    -- before setting up the servers.
    mason.setup()
    mason_lspconfig.setup()

    neodev.setup()

    -- vim.lsp.set_log_level("OFF")

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

    mason_lspconfig.setup({
        ensure_installed = mason_tools_installs,
    })

    -- Making sure `.h` files are declared as C files and not C++
    vim.cmd("let g:c_syntax_for_h = 1")

    setup_handlers(capabilities)
end
