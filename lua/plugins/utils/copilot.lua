return {
    "zbirenbaum/copilot-cmp",
    opts = {},
    dependencies = {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
            filetypes = {
                yaml = true,
                markdown = true,
            },
        },
    },
}
