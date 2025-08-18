-- vim.o.laststatus = 3
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- Use the system clipboard for all yank, delete, change, and put operations
vim.opt.clipboard = "unnamedplus"
vim.o.mouse = "a"
vim.o.termguicolors = true -- Better color support in terminal
vim.o.splitright = true -- Open vertical splits to the right
vim.o.splitbelow = true -- Open horizontal splits below

-- Enable word wrap
vim.wo.wrap = true
vim.wo.linebreak = true -- Wrap at word boundaries
vim.wo.breakindent = true -- Preserve indentation in wrapped lines

-- Macro recording notifications
vim.api.nvim_create_autocmd("RecordingEnter", {
	callback = function()
		vim.notify("Macro recording started", vim.log.levels.INFO, {
			title = "Macro",
			timeout = 2000,
			highlight = "MacroStart",
		})
		-- Print to command line for debugging
		vim.cmd("echo 'Recording macro...'")
	end,
})

vim.api.nvim_create_autocmd("RecordingLeave", {
	callback = function()
		vim.notify("Macro recording stopped", vim.log.levels.INFO, {
			title = "Macro",
			timeout = 2000,
			highlight = "MacroStop",
		})
		-- Print to command line for debugging
		vim.cmd("echo 'Macro recording stopped'")
	end,
})

-- Add highlight groups for macro notifications
vim.api.nvim_set_hl(0, "MacroStart", { fg = "#00ff00", bold = true })
vim.api.nvim_set_hl(0, "MacroStop", { fg = "#ff0000", bold = true })
vim.api.nvim_set_hl(0, "MacroReplay", { fg = "#00ffff", bold = true })
vim.api.nvim_set_hl(0, "MacroClear", { fg = "#ff00ff", bold = true })

-- Function to show macro replay notification
local function show_macro_replay(count)
	local message = count > 1 and string.format("Replaying macro %d times", count) or "Replaying macro"
	vim.notify(message, vim.log.levels.INFO, {
		title = "Macro",
		timeout = 2000,
		highlight = "MacroReplay",
	})
end

-- Function to clear all macros
local function clear_all_macros()
	-- Clear all registers from a to z
	for i = 97, 122 do -- ASCII values for 'a' to 'z'
		vim.fn.setreg(string.char(i), "")
	end
	-- Clear all registers from 0 to 9
	for i = 48, 57 do -- ASCII values for '0' to '9'
		vim.fn.setreg(string.char(i), "")
	end
	vim.notify("All macros cleared", vim.log.levels.INFO, {
		title = "Macro",
		timeout = 2000,
		highlight = "MacroClear",
	})
end

-- Create keymaps for macro replay with notifications
vim.keymap.set("n", "@", function()
	local count = vim.v.count1
	show_macro_replay(count)
	return "@"
end, { expr = true })

-- Add keybinding to clear all macros
vim.keymap.set("n", "<leader>mc", clear_all_macros, { desc = "Clear all macros" })

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

----------------------------------------
-- Pure Option+Arrow Keys (Wordwise Movement, No Selection)
----------------------------------------
-- Normal mode: move wordwise without selection.
vim.keymap.set("n", "<A-Left>", "b", opts)
vim.keymap.set("n", "<A-Right>", "w", opts)

-- Visual mode: move wordwise and adjust the selection.
vim.keymap.set("v", "<A-Left>", "b", opts)
vim.keymap.set("v", "<A-Right>", "w", opts)

----------------------------------------
-- Option+Shift+Arrow Keys (Wordwise Selection)
----------------------------------------
-- Normal mode: start Visual mode then move wordwise.
vim.keymap.set("n", "<A-S-Left>", "v<b", opts)
vim.keymap.set("n", "<A-S-Right>", "v<w", opts)

-- Visual mode: extend selection wordwise.
vim.keymap.set("v", "<A-S-Left>", "b", opts)
vim.keymap.set("v", "<A-S-Right>", "w", opts)

require("keymaps")
require("plugins.lazy")
require("plugins.misc")
require("plugins.lualine")
require("plugins.formatter")
require("options")
require("misc")
require("plugins.dap")
require("plugins.gitsigns")
require("plugins.telescope")
require("plugins.treesitter")
require("plugins.lsp")
require("plugins.trouble")
require("plugins.nvim-tangerine").setup()
require("plugins.zenmode")
require("plugins.neogit")
require("plugins.codesnap")
require("plugins.mini")
require("snippets.react")

require("plugins.prettier")

require("plugins.highlights")
require("plugins.harpoon")
vim.keymap.set("n", "<Esc>p", "<cmd>Telescope find_files<cr>", { noremap = true, silent = true })

-- Auto-save when leaving insert mode
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	command = "silent! write",
	group = vim.api.nvim_create_augroup("AutoSave", { clear = true }),
})

vim.keymap.set('n', '<leader>r', ':set relativenumber!<CR>')
