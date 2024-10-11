-- [[ Setting options ]]

-- [[ Columns ]]
-- Display line numbers
vim.opt.number = true

-- Use relative numbers
vim.opt.relativenumber = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Enable cursor line highlighting
vim.opt.cursorline = true

-- Highlight number only (font color change)
vim.opt.cursorlineopt = "screenline,number"

-- Highlight the cursor's column (vertical)
vim.opt.cursorcolumn = false

-- Highlight the 80th column
vim.opt.colorcolumn = "80"

-- [[ Indenting ]]
-- Enable break indent
vim.opt.breakindent = true

-- Autoindent when going on a new line
vim.opt.smartindent = true

-- Use spaces instead of tabs
vim.opt.expandtab = true

-- Use 4 spaces for indent
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- Save undo history
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir/"

-- Do not backup existing files being modified
vim.opt.backup = false

-- Do not store changed stuff in a swap file
vim.opt.swapfile = false

-- [[ Searching ]]

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Show the searched pattern in real-time
vim.opt.incsearch = true

-- [[ Navigation ]]

-- Keep at least 8 visible lines when scrolling
vim.opt.scrolloff = 8

-- [[ Autocomplete ]]

-- Set completeopt to have a better completion experience
vim.opt.completeopt = "menuone,noselect"

-- [[ Misc. ]]

-- Decrease update time
vim.opt.updatetime = 50
-- vim.opt.timeoutlen = 300

-- Enable mouse mode
vim.opt.mouse = "a"

-- Enable 24-bit RGB color
vim.opt.termguicolors = true
