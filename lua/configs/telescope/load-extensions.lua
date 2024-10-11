local telescope = require("telescope")
return function()
    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "live_grep_args")
    pcall(telescope.load_extension, "file_browser")
end
