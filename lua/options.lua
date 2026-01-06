-- Set highlight on search
vim.o.hlsearch = false

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

-- Enable autoread to detect external file changes
vim.o.autoread = true

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

-- Auto-reload files when changed externally
local auto_reload_group = vim.api.nvim_create_augroup("AutoReload", { clear = true })

-- Function to check and reload file if changed externally
local function check_and_reload()
	-- Skip if in command window
	if vim.fn.getcmdwintype() ~= "" then
		return
	end
	
	-- Skip if buffer is not a file or is modified (has unsaved changes)
	local buf = vim.api.nvim_get_current_buf()
	if vim.bo[buf].buftype ~= "" or vim.bo[buf].modified then
		return
	end
	
	-- Check if file exists and is readable
	local filename = vim.api.nvim_buf_get_name(buf)
	if filename == "" or vim.fn.filereadable(filename) == 0 then
		return
	end
	
	-- Check for external changes
	vim.cmd("checktime")
end

-- Check for file changes when buffer gets focus or periodically
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
	group = auto_reload_group,
	pattern = "*",
	callback = check_and_reload,
})

-- Periodic check (every updatetime ms when cursor is idle)
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	group = auto_reload_group,
	pattern = "*",
	callback = check_and_reload,
})

-- Reload buffer when file changes externally
vim.api.nvim_create_autocmd("FileChangedShellPost", {
	group = auto_reload_group,
	pattern = "*",
	callback = function()
		vim.notify("File changed externally. Buffer reloaded.", vim.log.levels.INFO, {
			title = "Auto-reload",
			timeout = 2000,
		})
	end,
})
