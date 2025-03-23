return {
    "hrsh7th/nvim-cmp",
    lazy = true,
    dependencies = {
        -- Snippet Engine & its associated nvim-cmp source
        {
            "L3MON4D3/LuaSnip",
            build = (function()
                -- Build Step is needed for regex support in snippets
                -- This step is not supported in many windows environments
                -- Remove the below condition to re-enable on windows
                if vim.fn.has("win32") == 1 then
                    return
                end
                return "make install_jsregexp"
            end)(),
        },
        "saadparwaiz1/cmp_luasnip",

        -- Nice symbols in float
        "onsails/lspkind.nvim",

        -- Adds LSP completion capabilities
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",

        -- Adds a number of user-friendly snippets
        "rafamadriz/friendly-snippets",
    },
    config = function()
        -- See `:help cmp`
        local cmp = require("cmp")
        local neogen = require("neogen")
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")
        local setup_luasnip = require("configs.cmp.setup-luasnip")

        setup_luasnip()

        local select_opts = { behavior = cmp.SelectBehavior.Select }

        local function jump_next()
            neogen.jump_next()

            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            end
        end

        local function jump_prev()
            neogen.jump_prev()

            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            end
        end

        -- Keeping the `J` and `K` positions but on Colemak
        -- HACK: <C-i> and <Tab> are the same key system-wide, so we need to remap <Tab> to itself
        vim.keymap.set({ "n", "i", "v" }, "<Tab>", "<Tab>")
        vim.keymap.set({ "n", "i", "v" }, "<C-e>", jump_next, { desc = "Jump to next placeholder" })
        vim.keymap.set({ "n", "i", "v" }, "<C-m>", jump_prev, { desc = "Jump to previous placeholder" })

        cmp.setup({
            formatting = {
                fields = { "abbr", "kind", "menu" },
                expandable_indicator = true,
                format = function(entry, item)
                    local color_item = require("nvim-highlight-colors").format(entry, { kind = item.kind })

                    item = lspkind.cmp_format({
                        mode = "symbol_text",
                        maxwidth = 50,
                        ellipsis_char = "",
                        show_labelDetails = true,
                    })(entry, item)

                    if color_item.abbr_hl_group then
                        item.kind_hl_group = color_item.abbr_hl_group
                        item.kind = color_item.abbr
                    end

                    return item
                end,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            completion = {
                completeopt = "menu,menuone,noinsert",
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-n>"] = cmp.mapping.select_next_item(select_opts),
                ["<C-p>"] = cmp.mapping.select_prev_item(select_opts),
                ["<C-u>"] = cmp.mapping.scroll_docs(-6),
                ["<C-d>"] = cmp.mapping.scroll_docs(6),
                ["<C-Space>"] = cmp.mapping.complete({}),
                ["<C-y>"] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                }),
                ["<Tab>"] = nil,
                ["<S-Tab>"] = nil,
            }),
            sources = {
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "path" },
            },
            sorting = {
                priority_weight = 2,
                comparators = {
                    -- Below is the default comparitor list and order for nvim-cmp except for `exact`
                    cmp.config.compare.offset,
                    -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
                    cmp.config.compare.score,
                    cmp.config.compare.recently_used,
                    cmp.config.compare.locality,
                    cmp.config.compare.kind,
                    cmp.config.compare.sort_text,
                    cmp.config.compare.length,
                    cmp.config.compare.order,
                },
            },
        })
    end,
}
