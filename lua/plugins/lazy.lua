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
					filtered_items = {
						visible = false,
						hide_dotfiles = false,
						hide_gitignored = false,
						hide_by_name = {
							"node_modules",
							".DS_Store",
							"__pycache__",
							".pytest_cache",
							".venv",
							"venv",
							"env",
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
		end,
	},
	{
		"NvChad/nvim-colorizer.lua",
		opts = {
			user_default_options = {
				tailwind = true,
			},
		},
	},
	{
		"numToStr/Comment.nvim",
		opts = {
			toggler = {
				--- Line-comment toggle keymap
				line = "<leader>cc", -- cmd + /
				--- Block-comment toggle keymap
				block = "<leader>bc",
			},
			opleader = {
				--- Line-comment keymap
				line = "<leader>c",
				--- Block-comment keymap
				block = "<leader>b",
			},
		},
		lazy = false,
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
	{ "vuciv/golf" },
	{ "tpope/vim-fugitive" },
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			bigfile = { enabled = true },
			dashboard = {
				enabled = true,
				sections = {
					{ section = "header" },
					{ section = "keys", gap = 1, padding = 6 },
					{ section = "startup" },
					{
						section = "terminal",
						cmd = "pokemon-colorscripts -n garchomp --no-title; sleep .1",
						random = 10,
						pane = 2,
						indent = 8,
						height = 30,
					},
				},
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
		config = function()
			require("codesnap").setup({
				-- Add any custom configuration here
			})
		end,
		-- Force a clean installation
		force = true,
	},
	{
		"NeogitOrg/neogit",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration
			"nvim-telescope/telescope.nvim", -- optional
		},
		config = true,
	},

	"onsails/lspkind.nvim",
	"folke/zen-mode.nvim",
	"tpope/vim-obsession",
	"ThePrimeagen/git-worktree.nvim",
	{
		"rmagatti/goto-preview",
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
		lazy = false,
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
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			require("todo-comments").setup({})
		end,
	},

	{
		"folke/noice.nvim",
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
	

	"ray-x/go.nvim",
	"ray-x/guihua.lua",
	-- ========================================
	-- COLORSCHEMES - Choose one by uncommenting
	-- ========================================
	
	-- Vague Theme (Modern, low contrast)
	{
		"vague2k/vague.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("vague").setup({
				transparent = false, -- don't set background
				bold = true,
				italic = true,
				style = {
					boolean = "bold",
					number = "none",
					float = "none",
					error = "bold",
					comments = "italic",
					conditionals = "none",
					functions = "none",
					headings = "bold",
					operators = "none",
					strings = "italic",
					variables = "none",
					keywords = "none",
					keyword_return = "italic",
					keywords_loop = "none",
					keywords_label = "none",
					keywords_exception = "none",
					builtin_constants = "bold",
					builtin_functions = "none",
					builtin_types = "bold",
					builtin_variables = "none",
				},
				plugins = {
					cmp = {
						match = "bold",
						match_fuzzy = "bold",
					},
					dashboard = {
						footer = "italic",
					},
					lsp = {
						diagnostic_error = "bold",
						diagnostic_hint = "none",
						diagnostic_info = "italic",
						diagnostic_ok = "none",
						diagnostic_warn = "bold",
					},
					neotest = {
						focused = "bold",
						adapter_name = "bold",
					},
					telescope = {
						match = "bold",
					},
				},
			})
			-- vim.cmd("colorscheme vague") -- Uncomment to use Vague
		end,
	},

	-- Tokyo Dark Theme (Classic dark theme)
	{
		"tiagovla/tokyodark.nvim",
		opts = {
			-- transparent_background = true,
		},
		config = function(_, opts)
			require("tokyodark").setup(opts)
			-- vim.cmd("colorscheme tokyodark") -- Uncomment to use Tokyo Dark
		end,
	},

	-- Catppuccin Theme (Popular, multiple variants)
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				background = { -- :h background
					light = "latte",
					dark = "mocha",
				},
				transparent_background = false, -- disables setting the background color.
				show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
				term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
				dim_inactive = {
					enabled = false, -- dims the background color of inactive window
					shade = "dark",
					percentage = 0.15, -- percentage of the shade to apply to the inactive window
				},
				no_italic = false, -- Force no italic
				no_bold = false, -- Force no bold
				no_underline = false, -- Force no underline
				styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
					comments = { "italic" }, -- Change the style of comments
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
					-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
				},
			})
			-- vim.cmd("colorscheme catppuccin") -- Uncomment to use Catppuccin
		end,
	},

	-- OldWorld Theme (Relaxing, non-saturated colors)
	{
		"dgox16/oldworld.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("oldworld").setup({
				terminal_colors = true, -- enable terminal colors
				variant = "default", -- default, oled, cooler
				styles = { -- You can pass the style using the format: style = true
					comments = {}, -- style for comments
					keywords = {}, -- style for keywords
					identifiers = {}, -- style for identifiers
					functions = {}, -- style for functions
					variables = {}, -- style for variables
					booleans = {}, -- style for booleans
				},
				integrations = { -- You can disable/enable integrations
					alpha = true,
					cmp = true,
					flash = true,
					gitsigns = true,
					hop = false,
					indent_blankline = true,
					lazy = true,
					lsp = true,
					markdown = true,
					mason = true,
					navic = false,
					neo_tree = false,
					neogit = false,
					neorg = false,
					noice = true,
					notify = true,
					rainbow_delimiters = true,
					telescope = true,
					treesitter = true,
				},
				highlight_overrides = {}
			})
			-- vim.cmd("colorscheme oldworld") -- Uncomment to use OldWorld
		end,
	},

	-- Dracula Theme (Official Dracula colorscheme for Neovim)
	{
		"Mofiqul/dracula.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("dracula").setup({
				-- show the '~' characters after the end of buffers
				show_end_of_buffer = true, -- default false
				-- use transparent background
				transparent_bg = false, -- default false
				-- set custom lualine background color
				lualine_bg_color = nil, -- default nil
				-- set italic comment
				italic_comment = true, -- default false
				-- overrides the default highlights with table see `:h synIDattr`
				overrides = {},
				-- You can use overrides as table like this
				-- overrides = {
				--   NonText = { fg = "white" }, -- set NonText fg to white
				--   NvimTreeIndentMarker = { link = "Comment" }, -- link to Comment
				--   ToggleTerm = { fg = "white" },
				-- },
			})
			-- vim.cmd("colorscheme dracula") -- Uncomment to use Dracula
		end,
	},

	-- Vesper Theme (Port of VS Code Vesper theme)
	{
		"datsfilipe/vesper.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("vesper").setup({
				transparent = false, -- Boolean: Sets the background to transparent
				italics = {
					comments = true, -- Boolean: Italicizes comments
					keywords = true, -- Boolean: Italicizes keywords
					functions = true, -- Boolean: Italicizes functions
					strings = true, -- Boolean: Italicizes strings
					variables = true, -- Boolean: Italicizes variables
				},
				overrides = {}, -- A dictionary of group names, can be a function returning a dictionary or a table.
				palette_overrides = {}
			})
			-- vim.cmd("colorscheme vesper") -- Uncomment to use Vesper
		end,
	},

	-- Rosé Pine (three variants: main, moon, dawn)
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = false,
		priority = 1000,
		config = function()
			-- Configure before selecting a Rosé Pine variant via Themery
			require("rose-pine").setup({
				variant = "auto",
				dark_variant = "main",
				enable = { terminal = true, legacy_highlights = true, migrations = true },
				styles = { bold = true, italic = true, transparency = false },
			})
			-- vim.cmd("colorscheme rose-pine") -- Uncomment to use Rosé Pine directly
		end,
	},

	-- Tokyo Night (multiple styles: night, storm, day, moon)
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			-- Style is selected by colorscheme name (e.g. tokyonight, tokyonight-moon) or setup option
			require("tokyonight").setup({})
			-- vim.cmd("colorscheme tokyonight") -- Uncomment to use Tokyo Night directly
		end,
	},

	-- Oxocarbon
	{
		"nyoom-engineering/oxocarbon.nvim",
		lazy = false,
		priority = 1000,
	},

	-- Sonokai
	{
		"sainnhe/sonokai",
		lazy = false,
		priority = 1000,
	},

	{ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",

			-- Useful status updates for LSP
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
	"tpope/vim-fugitive",
	"lewis6991/gitsigns.nvim",
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("plugins.lualine")
		end,
	},
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

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
	
	-- Theme picker with live preview
	{
		"zaldih/themery.nvim",
		lazy = false,
		config = function()
			require("themery").setup({
				themes = {
					-- Catppuccin variants
					{
						name = "Catppuccin Latte",
						colorscheme = "catppuccin",
						before = [[
							require("catppuccin").setup({
								flavour = "latte",
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
						]],
					},
					{
						name = "Catppuccin Frappe",
						colorscheme = "catppuccin",
						before = [[
							require("catppuccin").setup({
								flavour = "frappe",
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
						]],
					},
					{
						name = "Catppuccin Macchiato",
						colorscheme = "catppuccin",
						before = [[
							require("catppuccin").setup({
								flavour = "macchiato",
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
						]],
					},
					{
						name = "Catppuccin Mocha",
						colorscheme = "catppuccin",
						before = [[
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
						]],
					},
					-- Other themes
					{
						name = "Tokyo Dark",
						colorscheme = "tokyodark",
					},
					{
						name = "Vague",
						colorscheme = "vague",
					},
					{
						name = "OldWorld",
						colorscheme = "oldworld",
					},
					{
						name = "Dracula",
						colorscheme = "dracula",
					},
					{
						name = "Vesper",
						colorscheme = "vesper",
					},
						-- Newly added themes
						{
							name = "Rose Pine",
							colorscheme = "rose-pine",
						},
						-- TokyoNight variants
						{
							name = "Tokyo Night (Night)",
							colorscheme = "tokyonight-night",
						},
						{
							name = "Tokyo Night (Moon)",
							colorscheme = "tokyonight-moon",
						},
						{
							name = "Tokyo Night (Storm)",
							colorscheme = "tokyonight-storm",
						},
						{
							name = "Tokyo Night (Day)",
							colorscheme = "tokyonight-day",
						},
						{
							name = "Oxocarbon",
							colorscheme = "oxocarbon",
						},
						{
							name = "Sonokai",
							colorscheme = "sonokai",
						},
				},
				livePreview = true,
				globalBefore = [[
					-- Reset any theme-specific settings before applying new theme
				]],
				globalAfter = [[
					-- Apply our custom highlighting after theme change
					vim.cmd("doautocmd ColorScheme")
				]],
			})
			
			-- Set default theme if none is saved
			local current_theme = require("themery").getCurrentTheme()
			if not current_theme then
				vim.cmd("colorscheme catppuccin")
			end
		end,
	},
})

-- ========================================
-- DEFAULT COLORSCHEME SELECTION
-- ========================================
-- Theme selection is now handled by Themery plugin
-- The plugin will automatically load the last selected theme on startup
-- Use :ChangeTheme or <leader>t to change themes

-- If no theme is selected via Themery, Neovim will use its default

