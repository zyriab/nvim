-- Set <space> as the leader key
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Setting options ]]
require("options")

-- [[ Install `lazy.nvim` plugin manager ]]
require("lazy-bootstrap")

-- [[ Configure plugins ]]
require("lazy-plugins")

-- [[ Basic Keymaps ]]
require("keymaps")

-- [[ QuickFix keymaps ]]
-- require("quickfix")
