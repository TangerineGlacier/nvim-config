-- Install lazylazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Fixes Notify opacity issues
vim.o.termguicolors = true

require("lazy").setup({

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("neo-tree").setup({
				close_if_last_window = true,
				enable_git_status = false,
				git_status_async = false,
				window = {
					width = 30,
					mappings = {
						["<space>e"] = "close_window",
					},
				},
				filesystem = {
					-- Auto-reveal file in tree when opened
					reveal_file = "current",
					reveal_force_cwd = true,
					filtered_items = {
						visible = false,
						hide_dotfiles = false,
						hide_gitignored = false,
						hide_hidden = false,
						-- Force .env and similar to show (takes precedence over other filters)
						always_show = {
							".env",
							".env.*",
							".envrc",
						},
						hide_by_name = {
							".git",
							"node_modules",
							".DS_Store",
							"__pycache__",
							".pytest_cache",
							".venv",
							"venv",
							-- Don't hide "env" by name: it can match ".env" and hide the file
							"ENV",
							"dist",
							"build",
						},
						hide_by_pattern = {
							"**/node_modules/**",
							"**/.git/**",
							"**/__pycache__/**",
							"**/.pytest_cache/**",
							"**/.venv/**",
							"**/venv/**",
							-- Only hide dirs named "env" (path contains /env/), not file ".env"
							"**/env/**",
							"**/ENV/**",
							"**/dist/**",
							"**/build/**",
						},
					},
					git_status = {
						symbols = {
							-- Change type
							added     = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
							modified  = "", -- or "✹", but this is redundant info if you use git_status_colors on the name
							deleted   = "", -- this can only be used in the git_status source
							renamed   = "", -- this can only be used in the git_status source
							untracked = "", -- or "?", but this is redundant info if you use git_status_colors on the name
							ignored   = "", -- this can only be used in the git_status source
							unstaged  = "", -- this can only be used in the git_status source
							staged    = "", -- this can only be used in the git_status source
							conflict  = "", -- this can only be used in the git_status source
						}
					},
					use_libuv_file_watcher = false,
				},
				git_status = {
					symbols = {
						-- Change type
						added     = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
						modified  = "", -- or "✹", but this is redundant info if you use git_status_colors on the name
						deleted   = "", -- this can only be used in the git_status source
						renamed   = "", -- this can only be used in the git_status source
						untracked = "", -- or "?", but this is redundant info if you use git_status_colors on the name
						ignored   = "", -- this can only be used in the git_status source
						unstaged  = "", -- this can only be used in the git_status source
						staged    = "", -- this can only be used in the git_status source
						conflict  = "", -- this can only be used in the git_status source
					}
				},
			})
			vim.keymap.set("n", "<space>e", function()
				require("neo-tree.command").execute({ toggle = true })
			end, { desc = "Toggle Neotree" })
			-- Auto-reveal file in neo-tree when opening/switching to a buffer
			-- This automatically expands folders to show the current file, like VS Code
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
				group = vim.api.nvim_create_augroup("NeotreeAutoReveal", { clear = true }),
				callback = function()
					local file_path = vim.api.nvim_buf_get_name(0)
					-- Only process if it's a real file (not empty, not a directory, not a special buffer)
					if file_path ~= "" 
						and vim.fn.isdirectory(file_path) == 0 
						and vim.fn.filereadable(file_path) == 1 then
						
						-- Use neo-tree's manager to check if any neo-tree window is open
						local manager = require("neo-tree.sources.manager")
						local state = manager.get_state("filesystem")
						
						-- Reveal the file in neo-tree if it's open
						if state and state.tree then
							pcall(function()
								-- This will automatically expand only the necessary folders
								require("neo-tree.command").execute({ 
									action = "reveal_file",
									path = file_path,
									reveal_force_cwd = true,
								})
							end)
						end
					end
				end,
			})
		end,
	},
	{
		"NvChad/nvim-colorizer.lua",
		event = "BufReadPost",
		opts = {
			user_default_options = {
				tailwind = true,
			},
		},
	},
	{
		"numToStr/Comment.nvim",
		keys = { "gc", "gb", "<leader>cc", "<leader>bc", "<leader>c", "<leader>b" },
		opts = {
			toggler = {
				line = "<leader>cc",
				block = "<leader>bc",
			},
			opleader = {
				line = "<leader>c",
				block = "<leader>b",
			},
		},
	},
	{
		"rcarriga/nvim-notify",
		config = function()
			require("notify").setup({
				stages = "fade_in_slide_out",
				timeout = 3000,
				background_colour = "#000000",
			})
			vim.notify = require("notify")
		end,
	},

	{
		"lervag/vimtex",
		ft = { "tex" },
		config = function()
			vim.g.vimtex_view_method = "zathura" -- Set Zathura as viewer
			vim.g.vimtex_compiler_method = "latexmk" -- Use latexmk for compilation
			vim.g.vimtex_quickfix_mode = 0 -- Disable quickfix auto-popup
		end,
	},
	{
		"ThePrimeagen/vim-be-good",
		cmd = "VimBeGood", -- Loads only when you run :VimBeGood
	},
	{ "echasnovski/mini.nvim", version = false },
	{ "vuciv/golf", event = "VeryLazy" },
	{
		"folke/snacks.nvim",
		priority = 1000,
		event = "VeryLazy",
		---@type snacks.Config
		opts = {
			bigfile = { enabled = true },
			dashboard = {
				enabled = true,
				-- Install colorscripts for "square" graphic: https://gitlab.com/dwt1/shell-color-scripts
				--   cd ~/.shell-color-scripts && sudo make install
				--   Scripts go to /opt/shell-color-scripts/colorscripts; then: colorscript -e square
				sections = {
					{ section = "header" },
					{
						pane = 2,
						section = "terminal",
						cmd = "colorscript -e square",
						height = 5,
						padding = 1,
					},
					{ section = "keys", gap = 1, padding = 1 },
					{ pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
					{ pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
					{
						pane = 2,
						icon = " ",
						title = "Git Status",
						section = "terminal",
						enabled = function()
							return Snacks.git.get_root() ~= nil
						end,
						cmd = "git status --short --branch --renames",
						height = 5,
						padding = 1,
						ttl = 5 * 60,
						indent = 3,
					},
					{ section = "startup" },
				},
				-- Pokemon (commented out): cmd = "pokemon-colorscripts -n rayquaza --no-title; sleep .1", random = 10, pane = 2, indent = 8, height = 30
			},
			notifier = {
				enabled = true,
				timeout = 3000,
			},
			quickfile = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
			styles = {
				notification = {
					wo = { wrap = true }, -- Wrap notifications
				},
			},
		},
		keys = {
			{
				"<leader>d",
				function()
					Snacks.dashboard()
				end,
				desc = "Open Dashboard",
			},
			{
				"<leader>un",
				function()
					Snacks.notifier.hide()
				end,
				desc = "Dismiss All Notifications",
			},
			{
				"<leader>bd",
				function()
					Snacks.bufdelete()
				end,
				desc = "Delete Buffer",
			},
			{
				"<leader>gg",
				function()
					Snacks.lazygit()
				end,
				desc = "Lazygit",
			},
			{
				"<leader>gb",
				function()
					Snacks.git.blame_line()
				end,
				desc = "Git Blame Line",
			},
			{
				"<leader>gB",
				function()
					Snacks.gitbrowse()
				end,
				desc = "Git Browse",
			},
			{
				"<leader>gf",
				function()
					Snacks.lazygit.log_file()
				end,
				desc = "Lazygit Current File History",
			},
			{
				"<leader>gl",
				function()
					Snacks.lazygit.log()
				end,
				desc = "Lazygit Log (cwd)",
			},
			{
				"<leader>cR",
				function()
					Snacks.rename.rename_file()
				end,
				desc = "Rename File",
			},
			{
				"<c-/>",
				function()
					Snacks.terminal()
				end,
				desc = "Toggle Terminal",
			},
			{
				"<c-_>",
				function()
					Snacks.terminal()
				end,
				desc = "which_key_ignore",
			},
			{
				"]]",
				function()
					Snacks.words.jump(vim.v.count1)
				end,
				desc = "Next Reference",
				mode = { "n", "t" },
			},
			{
				"[[",
				function()
					Snacks.words.jump(-vim.v.count1)
				end,
				desc = "Prev Reference",
				mode = { "n", "t" },
			},
			{
				"<leader>N",
				desc = "Neovim News",
				function()
					Snacks.win({
						file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
						width = 0.6,
						height = 0.6,
						wo = {
							spell = false,
							wrap = false,
							-- signcolumn = "yes",
							statuscolumn = " ",
							conceallevel = 3,
						},
					})
				end,
			},
		},
		init = function()
			Snacks = require("snacks")
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					-- Setup some globals for debugging (lazy-loaded)
					_G.dd = function(...)
						Snacks.debug.inspect(...)
					end
					_G.bt = function()
						Snacks.debug.backtrace()
					end
					vim.print = _G.dd -- Override print to use snacks for `:=` command

					-- Create some toggle mappings
					Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
					Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
					Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
					Snacks.toggle.diagnostics():map("<leader>ud")
					Snacks.toggle.line_number():map("<leader>ul")
					Snacks.toggle
						.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
						:map("<leader>uc")
					Snacks.toggle.treesitter():map("<leader>uT")
					Snacks.toggle
						.option("background", { off = "light", on = "dark", name = "Dark Background" })
						:map("<leader>ub")
					Snacks.toggle.inlay_hints():map("<leader>uh")
				end,
			})
		end,
	},
	{
		"mistricky/codesnap.nvim",
		build = "make",
		cmd = "CodeSnap",
		config = function()
			require("codesnap").setup({})
		end,
		force = true,
	},
	{
		"NeogitOrg/neogit",
		cmd = "Neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration
			"nvim-telescope/telescope.nvim", -- optional
		},
		config = true,
	},

	{ "onsails/lspkind.nvim", event = "VeryLazy" },
	{ "tpope/vim-obsession", event = "VeryLazy" },
	{ "ThePrimeagen/git-worktree.nvim", event = "VeryLazy" },
	{
		"rmagatti/goto-preview",
		event = "LspAttach",
		config = function()
			require("goto-preview").setup({
				width = 120, -- Width of the floating window
				height = 15, -- Height of the floating window
				border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" }, -- Border characters of the floating window
				default_mappings = true,
				debug = false, -- Print debug information
				opacity = nil, -- 0-100 opacity level of the floating window where 100 is fully transparent.
				resizing_mappings = false, -- Binds arrow keys to resizing the floating window.
				post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
				references = { -- Configure the telescope UI for slowing the references cycling window.
					telescope = require("telescope.themes").get_dropdown({ hide_preview = false }),
				},
				-- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
				focus_on_open = true, -- Focus the floating window when opening it.
				dismiss_on_move = false, -- Dismiss the floating window when moving the cursor.
				force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
				bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
				stack_floating_preview_windows = true, -- Whether to nest floating windows
				preview_window_title = { enable = true, position = "left" }, -- Whether
			})
		end,
	},

	{
		"folke/trouble.nvim",
		cmd = { "Trouble", "TroubleToggle" },
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("trouble").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	},

	{
		"folke/todo-comments.nvim",
		event = "VeryLazy",
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			require("todo-comments").setup({})
		end,
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "helix",
			win = {
				width = 0.3,
				height = { min = 4, max = 25 },
				col = 9999,
				padding = { 1, 2 },
				title = true,
				title_pos = "center",
				border = "rounded",
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},

	{
		"folke/noice.nvim",
		event = "VeryLazy",
		config = function()
			require("noice").setup({
				-- add any options here

				routes = {
					{
						filter = {
							event = "msg_show",
							any = {
								{ find = "%d+L, %d+B" },
								{ find = "; after #%d+" },
								{ find = "; before #%d+" },
								{ find = "%d fewer lines" },
								{ find = "%d more lines" },
							},
						},
						opts = { skip = true },
					},
				},
			})
		end,
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},
	

	{ "ray-x/go.nvim", ft = "go" },
	{ "ray-x/guihua.lua", ft = "go" },
	-- OldWorld (default) - https://github.com/dgox16/oldworld.nvim
	{
		"dgox16/oldworld.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("oldworld").setup({
				terminal_colors = true,
				variant = "default",
				styles = {},
				integrations = {
					alpha = true,
					cmp = true,
					gitsigns = true,
					indent_blankline = true,
					lazy = true,
					lsp = true,
					neo_tree = true,
					telescope = true,
					treesitter = true,
				},
			})
			vim.cmd("colorscheme oldworld")
		end,
	},

	-- Catppuccin (optional: :colorscheme catppuccin)
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				background = { light = "latte", dark = "mocha" },
				transparent_background = false,
				show_end_of_buffer = false,
				term_colors = false,
				dim_inactive = { enabled = false },
				no_italic = false,
				no_bold = false,
				no_underline = false,
				styles = {
					comments = { "italic" },
					conditionals = { "italic" },
					loops = {},
					functions = {},
					keywords = {},
					strings = {},
					variables = {},
					numbers = {},
					booleans = {},
					properties = {},
					types = {},
					operators = {},
				},
				color_overrides = {},
				custom_highlights = {},
				integrations = {
					cmp = true,
					gitsigns = true,
					nvimtree = true,
					telescope = true,
					notify = false,
					mini = false,
				},
			})
		end,
	},

	{ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"j-hui/fidget.nvim",
		},
	},

	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			-- nvim-cmp setup
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				view = {
					entries = "native",
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
					["<Tab>"] = cmp.mapping(function(fallback)
						local suggestion = require('supermaven-nvim.completion_preview')
						if suggestion.has_suggestion() then
							suggestion.on_accept_suggestion()
						elseif cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "neorg" },
					{ name = "supermaven" },
				},
			})
		end,
	},

	-- Supermaven AI Code Completion
	{
		"supermaven-inc/supermaven-nvim",
		event = "InsertEnter",
		config = function()
			require("supermaven-nvim").setup({
				keymaps = {
					accept_suggestion = "<Tab>",
					clear_suggestion = "<C-]>",
					accept_word = "<C-j>",
				},
				ignore_filetypes = { "markdown", "mdx", "txt" },
				color = {
					suggestion_color = "#888888",
					cterm = 244,
				},
				log_level = "info",
				disable_inline_completion = false,
				disable_keymaps = false,
			})
			
			-- Set up custom highlight for Supermaven suggestions
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "*",
				callback = function()
					vim.api.nvim_set_hl(0, "SupermavenSuggestion", {
						fg = "#888888",
						italic = true,
						cterm = { italic = true }
					})
				end,
			})
			
			-- Trigger the highlight setup
			vim.cmd("doautocmd ColorScheme")
		end,
	},

	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		event = "BufReadPost",
		build = function()
			pcall(require("nvim-treesitter.install").update({ with_sync = true }))
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
	},

	{
		"sphamba/smear-cursor.nvim",
		opts = {},
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			formatters_by_ft = {
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				jsonc = { "prettier" },
				yaml = { "prettier" },
				markdown = {}, -- Explicitly disable formatting for markdown to prevent character truncation
				lua = { "stylua" },
				sh = { "shfmt" },
				go = { "gofmt", "goimports" },
				rust = { "rustfmt" },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
			formatters = {
				prettier = {
					prepend_args = { "--double-quote", "--jsx-double-quote" },
				},
			},
		},
	},
	{
		"jose-elias-alvarez/nvim-lsp-ts-utils",
		dependencies = { "nvim-lspconfig" },
		config = function()
			-- Configuration is handled in lsp.lua
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
	},
	"theHamsta/nvim-dap-virtual-text",
	"leoluz/nvim-dap-go",

	-- Git related plugins
	{ "tpope/vim-fugitive", event = "BufReadPre" },
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		config = function()
			require("plugins.gitsigns")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("plugins.lualine")
		end,
	},
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", event = "BufReadPost", opts = {} },

	{ "tpope/vim-sleuth", event = "BufReadPost" }, -- Detect tabstop and shiftwidth automatically

	-- Transparency
	-- {
	-- 	"xiyaowong/transparent.nvim",
	-- 	lazy = false,
	-- 	config = function()
	-- 		require("transparent").setup({
	-- 			groups = { -- table: default groups
	-- 				"Normal",
	-- 				"NormalNC",
	-- 				"Comment",
	-- 				"Constant",
	-- 				"Special",
	-- 				"Identifier",
	-- 				"Statement",
	-- 				"PreProc",
	-- 				"Type",
	-- 				"Underlined",
	-- 				"Todo",
	-- 				"String",
	-- 				"Function",
	-- 				"Conditional",
	-- 				"Repeat",
	-- 				"Operator",
	-- 				"Structure",
	-- 				"LineNr",
	-- 				"NonText",
	-- 				"SignColumn",
	-- 				"CursorLine",
	-- 				"CursorLineNr",
	-- 				"StatusLine",
	-- 				"StatusLineNC",
	-- 				"EndOfBuffer",
	-- 			},
	-- 			extra_groups = {}, -- table: additional groups that should be cleared
	-- 			exclude_groups = {}, -- table: groups you don't want to clear
	-- 		})
	-- 	end,
	-- },

	{
		"folke/twilight.nvim",
		ft = "markdown",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({
				check_ts = true,
				ts_config = {
					javascript = { "template_string" },
					typescript = { "template_string" },
					javascriptreact = { "template_string" },
					typescriptreact = { "template_string" },
				},
			})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		ft = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact" },
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
	-- {
	-- 	"alvan/vim-closetag",
	-- 	config = function()
	-- 		-- Configure plugin options here
	-- 		vim.g.closetag_filenames = '*.html,*.jsx,*.xhtml,*.phtml, *.ts, *.js, *.jsx, *.tsx'
	-- 		vim.g.closetag_xhtml_filenames = '*.xhtml,*.jsx, *.ts, *.js, *.jsx, *.tsx'
	-- 		vim.g.closetag_filetypes = 'html,javascriptreact,js,xhtml,phtml,typescriptreact,typescript'
	-- 		vim.g.closetag_xhtml_filetypes = 'xhtml,jsx,typescriptreact,typescript'
	-- 		vim.g.closetag_emptyTags_caseSensitive = 1
	-- 		vim.g.closetag_regions = {
	-- 			['typescript.tsx'] = 'jsxRegion,tsxRegion',
	-- 			['javascript.jsx'] = 'jsxRegion',
	-- 			['typescriptreact'] = 'jsxRegion,tsxRegion',
	-- 			['javascriptreact'] = 'jsxRegion',
	-- 		}
	-- 		vim.g.closetag_shortcut = '>'              -- shortcut for closing tag
	-- 		vim.g.closetag_close_shortcut = '<leader>>' -- shortcut to add > without closing tag
	-- 	end,
	-- },
	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		keys = { { "<leader>z", desc = "Zen mode" } },
		opts = {
			window = {
				backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
				-- height and width can be:
				-- * an absolute number of cells when > 1
				-- * a percentage of the width/height of the editor when <= 1
				-- * a function that returns the width or the height
				width = 120, -- width of the Zen window
				height = 1, -- height of the Zen window
				-- by default, no options are changed for the Zen window
				-- uncomment any of the options below, or add other vim.wo options you want to apply
				options = {
					signcolumn = "no", -- disable signcolumn
					number = false, -- disable number column
					relativenumber = false, -- disable relative numbers
					cursorline = false, -- disable cursorline
					cursorcolumn = false, -- disable cursor column
					foldcolumn = "0", -- disable fold column
					list = false, -- disable whitespace characters
				},
			},
			plugins = {
				-- disable some global vim options (vim.o...)
				-- comment the lines to not apply the options
				options = {
					enabled = true,
					ruler = false, -- disables the ruler text in the cmd line area
					showcmd = false, -- disables the command in the last line of the screen
				},
				twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
				gitsigns = { enabled = false }, -- disables git signs
				tmux = { enabled = false }, -- disables the tmux statusline
				-- this will change the font size on kitty when in zen mode
				-- to make this work, you need to set the following kitty options:
				-- - allow_remote_control socket-only
				-- - listen_on unix:/tmp/kitty
				kitty = {
					enabled = false,
					font = "+4", -- font size increment
				},
			},
		},
	},
	{
		"mistweaverco/kulala.nvim",
		keys = {
			{ "<leader>zs", desc = "Send request" },
			{ "<leader>za", desc = "Send all requests" },
			{ "<leader>zb", desc = "Open scratchpad" },
		},
		ft = {"http", "rest"},
		opts = {
			global_keymaps = false,
			global_keymaps_prefix = "<leader>z",
			kulala_keymaps_prefix = "",
		},
	},
	require("plugins.harpoon"),
	
	-- Obsidian integration plugins
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		ft = "markdown", -- load only for markdown files
		-- Replace the above line with this if you want to load the plugin unconditionally:
		-- event = {
		--   -- If you want to use the home screen 'code' action from the Obsidian app, you can use
		--   -- the home screen when opening a markdown file with Obsidian.
		--   "BufReadPre " .. vim.fn.expand "~" .. "/Documents/notebook/**.md",
		-- },
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",
			-- see below for full list of optional dependencies 👇
		},
		opts = {
			workspaces = {
				{
					name = "personal",
					path = "~/Documents/notebook",
				},
				-- {
				--   name = "work",
				--   path = "~/vaults/work", -- absolute path
				-- },
			},
			-- see below for full list of options 👇
		},
	},
	
	-- Markdown preview and rendering
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function() vim.fn["mkdp#util#install"]() end,
		config = function()
			vim.g.mkdp_auto_start = 0
			vim.g.mkdp_auto_close = 1
			vim.g.mkdp_refresh_slow = 0
			vim.g.mkdp_command_for_global = 0
			vim.g.mkdp_open_to_the_world = 0
			vim.g.mkdp_open_ip = ""
			vim.g.mkdp_browser = ""
			vim.g.mkdp_echo_preview_url = 0
			vim.g.mkdp_browserfunc = ""
			vim.g.mkdp_preview_options = {
				mkit = {},
				katex = {},
				uml = {},
				maid = {},
				disable_sync_scroll = 0,
				sync_scroll_type = "middle",
				hide_yaml_meta = 1,
				sequence_diagrams = {},
				flowchart_diagrams = {},
				footnote_anchor_parentheses = 0,
			}
			vim.g.mkdp_markdown_css = ""
			vim.g.mkdp_highlight_css = ""
			vim.g.mkdp_port = ""
			vim.g.mkdp_page_title = "「${name}」"
		end,
	},
	
	-- Better markdown support
	{
		"preservim/vim-markdown",
		ft = "markdown",
		config = function()
			vim.g.markdown_folding = 0
			vim.g.markdown_fold_style = "manual"
			vim.g.markdown_enable_mappings = 1
			vim.g.markdown_enable_insert_mode_mappings = 1
			vim.g.markdown_enable_conceal = 0 -- Disable conceal to prevent character truncation
			vim.g.markdown_enable_spell_checking = 0
		end,
	},
	
	-- Wiki-style links and navigation
	{
		"jbyuki/nabla.nvim",
		ft = "markdown",
		config = function()
			require("nabla").enable_virt({
				autogen = true,
				use_virt_lines = true,
			})
		end,
	},
	require("plugins.skills"),
})