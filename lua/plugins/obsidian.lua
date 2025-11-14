-- Obsidian.nvim configuration
local obsidian = require("obsidian")

-- Helper function to resize window to 30% of screen width
local function resize_obsidian_window()
	local width = math.floor(vim.o.columns * 0.30)
	vim.cmd("vertical resize " .. width)
end

-- Set up Obsidian with your vault path
obsidian.setup({
	workspaces = {
		{
			name = "personal",
			path = "~/Documents/notebook",
		},
	},
	
	-- Set the daily notes directory
	daily_notes = {
		folder = "notes/dailies",
		date_format = "%Y-%m-%d",
		alias_format = "%B %d, %Y",
	},
	
	-- Set the templates directory (create if it doesn't exist)
	templates = {
		subdir = "templates",
		date_format = "%Y-%m-%d-%H%M",
		time_format = "%H:%M",
	},
	
	-- Completion settings
	completion = {
		nvim_cmp = true,
		min_chars = 2,
	},
	
	-- UI settings
	ui = {
		enable = true,
		update_debounce = 200,
		checkboxes = {
			[" "] = { char = "☐", hl_group = "ObsidianTodo" },
			["x"] = { char = "☑", hl_group = "ObsidianDone" },
			[">"] = { char = "↪", hl_group = "ObsidianRightArrow" },
			["~"] = { char = "↩", hl_group = "ObsidianLeftArrow" },
			["-"] = { char = "•", hl_group = "ObsidianBullet" },
		},
		external_link_icon = { char = "↗", hl_group = "ObsidianExtLinkIcon" },
		reference_text = { hl_group = "ObsidianRefText" },
		highlight_text = { hl_group = "ObsidianHighlightText" },
		tags = { hl_group = "ObsidianTag" },
		block_ids = { hl_group = "ObsidianBlockId" },
		link_text = { hl_group = "ObsidianLinkText" },
		urls = { hl_group = "ObsidianUrl" },
	},
	
	-- Attachments settings
	attachments = {
		img_folder = "assets/imgs",
		img_text_func = function(client, path)
			local link_path = client:vault_relative_path(path) or path
			local display_name = vim.fs.basename(link_path)
			return string.format("![%s](%s)", display_name, link_path)
		end,
	},
	
	-- Note ID function
	note_id_func = function(title)
		if title ~= nil then
			return title:gsub(" ", "-"):lower()
		else
			return tostring(os.time())
		end
	end,
	
	-- Follow URL function
	follow_url_func = function(url)
		vim.system({ "open", url }, { detach = true })
	end,
	
	-- New notes location
	new_notes_location = "current_dir",
	
	-- Open notes in vertical split to the right
	open_notes_in = "vsplit",
	
	-- Custom function to handle note opening with proper sizing
	note_opener = function(client, path)
		vim.cmd("vsplit")
		resize_obsidian_window()
		vim.cmd("edit " .. path)
	end,
})

-- Keymaps for Obsidian functionality - ALL open in vertical splits
vim.keymap.set("n", "<leader>on", function()
	vim.cmd("ObsidianNew")
end, { desc = "New Obsidian Note" })

vim.keymap.set("n", "<leader>oo", function()
	vim.cmd("vsplit")
	resize_obsidian_window()
	vim.cmd("ObsidianOpen")
end, { desc = "Open Obsidian Note" })

vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianToggleCheckbox<cr>", { desc = "Toggle Checkbox" })

vim.keymap.set("n", "<leader>os", function()
	require('telescope.builtin').find_files({
		cwd = "~/Documents/notebook",
		prompt_title = "Search Obsidian Notes",
		attach_mappings = function(prompt_bufnr, map)
			local actions = require('telescope.actions')
			local action_state = require('telescope.actions.state')
			
			-- Override the default file selection action
			map('i', '<CR>', function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				if selection then
					vim.cmd("vsplit")
					resize_obsidian_window()
					vim.cmd("edit " .. selection.path)
				end
			end)
			
			map('n', '<CR>', function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				if selection then
					vim.cmd("vsplit")
					resize_obsidian_window()
					vim.cmd("edit " .. selection.path)
				end
			end)
			
			return true
		end
	})
end, { desc = "Search Obsidian Notes" })

vim.keymap.set("n", "<leader>ol", "<cmd>ObsidianLink<cr>", { desc = "Insert Obsidian Link" })

vim.keymap.set("n", "<leader>od", function()
	vim.cmd("vsplit")
	vim.cmd("vertical resize 25%")
	vim.cmd("ObsidianToday")
end, { desc = "Open Daily Note" })

vim.keymap.set("n", "<leader>oy", "<cmd>ObsidianYankAnchor<cr>", { desc = "Yank Anchor" })

vim.keymap.set("n", "<leader>or", "<cmd>ObsidianRename<cr>", { desc = "Rename Note" })

vim.keymap.set("n", "<leader>ob", function()
	vim.cmd("vsplit")
	vim.cmd("vertical resize 25%")
	vim.cmd("ObsidianBacklinks")
end, { desc = "Show Backlinks" })

vim.keymap.set("n", "<leader>of", function()
	vim.cmd("vsplit")
	vim.cmd("vertical resize 25%")
	vim.cmd("ObsidianFollowLink")
end, { desc = "Follow Link" })

vim.keymap.set("n", "<leader>oq", function()
	vim.cmd("vsplit")
	vim.cmd("vertical resize 25%")
	vim.cmd("ObsidianQuickSwitch")
end, { desc = "Quick Switch" })

-- Additional navigation keymaps
vim.keymap.set("n", "<leader>olist", function()
	require('telescope.builtin').find_files({
		cwd = "~/Documents/notebook",
		prompt_title = "List All Obsidian Notes",
		attach_mappings = function(prompt_bufnr, map)
			local actions = require('telescope.actions')
			local action_state = require('telescope.actions.state')
			
			map('i', '<CR>', function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				if selection then
					vim.cmd("vsplit")
					resize_obsidian_window()
					vim.cmd("edit " .. selection.path)
				end
			end)
			
			map('n', '<CR>', function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				if selection then
					vim.cmd("vsplit")
					resize_obsidian_window()
					vim.cmd("edit " .. selection.path)
				end
			end)
			
			return true
		end
	})
end, { desc = "List All Notes" })

vim.keymap.set("n", "<leader>otags", function()
	require('telescope.builtin').live_grep({
		cwd = "~/Documents/notebook",
		prompt_title = "Search Obsidian Content",
		attach_mappings = function(prompt_bufnr, map)
			local actions = require('telescope.actions')
			local action_state = require('telescope.actions.state')
			
			map('i', '<CR>', function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				if selection then
					vim.cmd("vsplit")
					resize_obsidian_window()
					vim.cmd("edit " .. selection.path)
				end
			end)
			
			map('n', '<CR>', function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				if selection then
					vim.cmd("vsplit")
					resize_obsidian_window()
					vim.cmd("edit " .. selection.path)
				end
			end)
			
			return true
		end
	})
end, { desc = "Search Content" })

vim.keymap.set("n", "<leader>otoday", function()
	vim.cmd("vsplit")
	vim.cmd("vertical resize 25%")
	vim.cmd("ObsidianToday")
end, { desc = "Open Today's Note" })

-- Telescope integration for browsing vault
vim.keymap.set("n", "<leader>ovault", function()
	require('telescope.builtin').find_files({
		cwd = "~/Documents/notebook",
		prompt_title = "Browse Obsidian Vault",
		attach_mappings = function(prompt_bufnr, map)
			local actions = require('telescope.actions')
			local action_state = require('telescope.actions.state')
			
			map('i', '<CR>', function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				if selection then
					vim.cmd("vsplit")
					resize_obsidian_window()
					vim.cmd("edit " .. selection.path)
				end
			end)
			
			map('n', '<CR>', function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				if selection then
					vim.cmd("vsplit")
					resize_obsidian_window()
					vim.cmd("edit " .. selection.path)
				end
			end)
			
			return true
		end
	})
end, { desc = "Browse Vault with Telescope" })

-- Markdown preview keymaps
vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Toggle Markdown Preview" })
vim.keymap.set("n", "<leader>ms", "<cmd>MarkdownPreviewStop<cr>", { desc = "Stop Markdown Preview" })

-- Math rendering with nabla
vim.keymap.set("n", "<leader>nm", function()
	require("nabla").popup()
end, { desc = "Show Math Popup" })

-- Auto-format markdown on save (disabled to prevent character truncation)
-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	pattern = "*.md",
-- 	callback = function()
-- 		-- Format markdown files
-- 		vim.cmd("normal! gg=G")
-- 	end,
-- 	group = vim.api.nvim_create_augroup("MarkdownFormat", { clear = true }),
-- })

-- Set up markdown-specific settings
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		-- Enable spell checking for markdown files
		vim.opt_local.spell = true
		vim.opt_local.spelllang = "en_us"
		
		-- Set text width for markdown
		vim.opt_local.textwidth = 80
		
		-- Enable line wrapping
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		
		-- Set up folding
		vim.opt_local.foldmethod = "manual"
		vim.opt_local.foldlevel = 99
	end,
	group = vim.api.nvim_create_augroup("MarkdownSettings", { clear = true }),
})

-- Custom function to open Obsidian notes in vertical split
local function open_obsidian_note_vertical()
	vim.cmd("vsplit")
	vim.cmd("ObsidianOpen")
end

-- Custom function to open daily note in vertical split
local function open_daily_note_vertical()
	vim.cmd("vsplit")
	vim.cmd("ObsidianToday")
end

-- Override the default Obsidian commands to use vertical splits
vim.api.nvim_create_user_command("ObsidianOpenVertical", open_obsidian_note_vertical, { desc = "Open Obsidian note in vertical split" })
vim.api.nvim_create_user_command("ObsidianTodayVertical", open_daily_note_vertical, { desc = "Open daily note in vertical split" })
