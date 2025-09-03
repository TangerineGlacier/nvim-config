-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true
vim.o.relativenumber = true

-- Disable mouse mode
vim.o.mouse = "a"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

-- Set colorscheme
--vim.cmd [[colorscheme onedark]]
-- vim.cmd.colorscheme "catppuccin"

--vim.cmd()
vim.opt.clipboard = "unnamedplus"

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- Concealer for Neorg
vim.o.conceallevel = 2

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Global ignore patterns for file explorers and searches
vim.opt.wildignore = vim.opt.wildignore + {
  "node_modules",
  "**/node_modules/**",
  ".git",
  "**/.git/**",
  "__pycache__",
  "**/__pycache__/**",
  ".pytest_cache",
  "**/.pytest_cache/**",
  ".venv",
  "venv",
  "env",
  "ENV",
  "dist",
  "build",
  ".DS_Store",
  "*.pyc",
  "*.pyo",
  "*.pyd",
  "*.so",
  "*.dylib",
  "*.dll",
  "*.exe",
  "*.out",
  "*.app",
  "*.i",
  "*.o",
  "*.obj",
  "*.elf",
  "*.ext",
  "*.so",
  "*.so.*",
  "*.dylib",
  "*.dylib.*",
  "*.dll",
  "*.dll.*",
  "*.exe",
  "*.exe.*",
  "*.out",
  "*.out.*",
  "*.app",
  "*.app.*",
  "*.i",
  "*.i.*",
  "*.o",
  "*.o.*",
  "*.obj",
  "*.obj.*",
  "*.elf",
  "*.elf.*",
  "*.ext",
  "*.ext.*",
}
