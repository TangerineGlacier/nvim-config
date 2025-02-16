vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- Use the system clipboard for all yank, delete, change, and put operations
vim.opt.clipboard = "unnamedplus"

local opts = { noremap = true, silent = true }

-- Mappings for starting selection with Shift+Arrow keys
vim.keymap.set("n", "<S-Left>", "v<Left>", opts)
vim.keymap.set("n", "<S-Right>", "v<Right>", opts)
vim.keymap.set("n", "<S-Up>", "v<Up>", opts)
vim.keymap.set("n", "<S-Down>", "v<Down>", opts)

-- In Visual mode: if you press Shift+Arrow, extend the selection.
vim.keymap.set("v", "<S-Left>", "<Left>", opts)
vim.keymap.set("v", "<S-Right>", "<Right>", opts)
vim.keymap.set("v", "<S-Up>", "<Up>", opts)
vim.keymap.set("v", "<S-Down>", "<Down>", opts)

-- In Visual mode: if you press an arrow key WITHOUT Shift, cancel Visual mode then move.
vim.keymap.set("v", "<Left>", "<Esc><Left>", opts)
vim.keymap.set("v", "<Right>", "<Esc><Right>", opts)
vim.keymap.set("v", "<Up>", "<Esc><Up>", opts)
vim.keymap.set("v", "<Down>", "<Esc><Down>", opts)

-- In Visual mode: map Ctrl+C to copy selection to the clipboard.
vim.keymap.set("v", "<C-c>", '"+y', opts)


require('keymaps')
require('plugins.lazy')
require('plugins.misc')
require('plugins.lualine')
require('plugins.formatter')
require('options')
require('misc')
require('plugins.dap')
require('plugins.gitsigns')
require('plugins.tele')
require('plugins.treesitter')
require('plugins.lsp')
require('plugins.trouble')
require('plugins.nvim-tangerine').setup()
require('plugins.zenmode')
require('plugins.neogit')
require('plugins.codesnap')
require('plugins.mini')
require("snippets.react")
require('plugins.obsidian')
require('plugins.prettier')
require('plugins.neo-tree')
