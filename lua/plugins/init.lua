local require = require

vim.o.number = true
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.clipboard = 'unnamedplus'
vim.o.wrap = true
vim.o.scrolloff = 10
vim.o.showcmd = true
vim.o.hlsearch = true
vim.g.mapleader = " "

vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.number = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.clipboard = 'unnamedplus'
vim.opt.wrap = true
vim.opt.showcmd = true
vim.opt.hlsearch = true
vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.backup = false
vim.opt.showcmd = true
vim.opt.cmdheight = 0
vim.opt.laststatus = 0
vim.opt.inccommand = "split"
vim.opt.ignorecase = true
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.path:append({ "**" })
vim.opt.wildignore:append({ "*/node_modules/*" })
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "cursor"
vim.opt.mouse = ""

local plugins = {
	--------------------------------------------------- Theme ---------------------------------------------------
	---
	{
		"loctvl842/monokai-pro.nvim",
		lazy = false, -- Load immediately
		priority = 1000, -- Ensure it loads first if you use multiple color schemes
		config = function()
		  require("monokai-pro").setup({
			filter = "pro", -- Choose your preferred filter: "classic", "octagon", "pro", "machine", "ristretto", "spectrum"
			-- Other options:
			transparent_background = false,
			terminal_colors = true,
			devicons = true, -- Enable or disable icons
			styles = {
			  comments = { italic = true },
			  keywords = { italic = true },
			  functions = { bold = true },
			  variables = {},
			  operators = {},
			},
			-- Add any additional custom highlights here
			custom_highlights = {},
		  })
		  vim.cmd.colorscheme("monokai-pro")
	
		end,
	  },
	{
		"sontungexpt/sttusline",
		branch = "develop",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		event = "User FilePostLazyLoaded",
		opts = {},
	},

	{
		"sontungexpt/smart-resizing",
	},

	-- {
	-- 	"akinsho/bufferline.nvim",
	-- 	dependencies = {
	-- 		"nvim-tree/nvim-web-devicons",
	-- 	},
	-- 	event = "User FilePostLazyLoaded",
	-- 	opts = require("config.bufferline"),
	-- 	config = function(_, opts) require("bufferline").setup(opts) end,
	-- },

	--------------------------------------------------- Syntax ---------------------------------------------------
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"HiPhish/rainbow-delimiters.nvim",
		},
		event = {
			"CursorHold",
			"CursorMoved",
			"User FilePostLazyLoaded",
		},
		cmd = {
			"TSInstall",
			"TSBufEnable",
			"TSEnable",
			"TSBufDisable",
			"TSModuleInfo",
			"TSInstallFromGrammar",
		},
		build = ":TSUpdate",
		main = "nvim-treesitter.configs",
		opts = function() return require("config.nvim-treesitter") end,
	},

	-- {
	-- 	"windwp/nvim-ts-autotag",
	-- 	dependencies = {
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 	},
	-- 	ft = {
	-- 		"html",
	-- 		"vue",
	-- 		"tsx",
	-- 		"jsx",
	-- 		"svelte",
	-- 		"javascript",
	-- 		"typescript",
	-- 		"javascriptreact",
	-- 		"typescriptreact",
	-- 	},
	-- },

	-- {
	-- 	"VebbNix/lf-vim",
	-- 	ft = "lf",
	-- },

	------------------------------------ Editor ------------------------------------
	{
		"sontungexpt/stcursorword",
		event = { "CursorHold", "CursorMoved" },
		main = "stcursorword",
		opts = {},
	},

	{
		"sontungexpt/url-open",
		branch = "mini",
		cmd = "URLOpenUnderCursor",
		event = { "CursorHold", "CursorMoved" },
		main = "url-open",
		opts = {},
	},

	-- {
	-- 	"sontungexpt/buffer-closer",
	-- 	cmd = "BufferCloserRetire",
	-- 	event = { "BufAdd", "FocusLost", "FocusGained" },
	-- 	config = function(_, opts) require("buffer-closer").setup {} end,
	-- },

	{
		"akinsho/toggleterm.nvim",
		cmd = { "ToggleTerm", "ToggleTermToggleAll", "TermExec" },
		keys = "<C-t>",
		main = "toggleterm",
		opts = function() return require("config.toggleterm") end,
	},

	{
		"kylechui/nvim-surround",
		keys = { "ys", "ds", "cs" },
		opts = {},
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		-- opts = function() return require("config.nvim-autopairs") end,
		config = function(_, opts)
			require("nvim-autopairs").setup(opts)
			local cmp_status_ok, cmp = pcall(require, "cmp")
			local cmp_autopairs_status_ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
			if cmp_status_ok and cmp_autopairs_status_ok then
				cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
			end
		end,
	},

	-- {
	-- 	"gelguy/wilder.nvim",
	-- 	dependencies = {
	-- 		"romgrk/fzy-lua-native",
	-- 	},
	-- 	build = ":UpdateRemotePlugins",
	-- 	event = "CmdlineEnter",
	-- 	config = function() require("config.wilder") end,
	-- },

	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = { "CursorHold", "CursorMoved" },
		dependencies = {
			"HiPhish/rainbow-delimiters.nvim",
		},
		opts = {
			indent = {
				char = "│",
			},
			scope = {
				highlight = {
					"RainbowDelimiterRed",
					"RainbowDelimiterYellow",
					"RainbowDelimiterBlue",
					"RainbowDelimiterOrange",
					"RainbowDelimiterGreen",
					"RainbowDelimiterViolet",
					"RainbowDelimiterCyan",
				},
				char = "│",
			},
		},
		config = function(_, opts)
			local hooks = require("ibl.hooks")
			hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
			require("ibl").setup(opts)
		end,
	},

	{
		"brenoprata10/nvim-highlight-colors",
		cmd = "HighlightColors",
		event = { "CursorHold", "CursorMoved" },
		opts = function() return require("config.highlight-colors") end,
		config = function(_, opts)
			require("nvim-highlight-colors").setup(opts)
			vim.api.nvim_command("HighlightColors On")
		end,
	},

	{
		"uga-rosa/ccc.nvim",
		cmd = "CccPick",
		main = "ccc",
		opts = {},
	},

	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			require("lazy").load { plugins = { "markdown-preview.nvim" } }
			vim.fn["mkdp#util#install"]()
		end,
		config = function() vim.g.mkdp_auto_close = 1 end,
	},

	{
		"folke/which-key.nvim",
		keys = { "<leader>", "[", "]", '"', "'", "c", "v", "g", "d", "z" },
		main = "which-key",
		opts = function() return require("config.whichkey") end,
	},

	{
		"kevinhwang91/nvim-ufo",
		keys = {
			{ "zc", mode = "n", desc = "Fold current line" },
			{ "zo", mode = "n", desc = "Unfold current line" },
			{ "za", mode = "n", desc = "Toggle fold current line" },
			{ "zA", mode = "n", desc = "Toggle fold all lines" },
			{ "zr", mode = "n", desc = "Unfold all lines" },
			{ "zR", mode = "n", desc = "Fold all lines" },
		},
		dependencies = "kevinhwang91/promise-async",
		opts = function()
			vim.o.foldenable = true -- enable folding when plugin is loaded
			return require("config.nvim-ufo")
		end,
	},

	-- {
	-- 	"zbirenbaum/copilot.lua",
	-- 	cmd = "Copilot",
	-- 	event = "InsertEnter",
	-- 	opts = function() return require("config.copilot") end,
	-- 	config = function(_, opts) require("copilot").setup(opts) end,
	-- },


	--------------------------------------------------- File Explorer ---------------------------------------------------
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		cmd = {
			"NvimTreeToggle",
			"NvimTreeFocus",
			"NvimTreeOpen",
		},
		opts = function() return require("config.nvim-tree") end,
		config = function(_, opts) require("nvim-tree").setup(opts) end,
	},

	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"nvim-lua/plenary.nvim",

			-- extensions
			-- "nvim-telescope/telescope-media-files.nvim",
		},
		opts = function() return require("config.telescope") end,
		config = function(_, opts)
			local telescope = require("telescope")
			telescope.setup(opts)
			for _, ext in ipairs(opts.extension_list) do
				telescope.load_extension(ext)
			end
		end,
	},

	--------------------------------------------------- Comments ---------------------------------------------------
	{
		"numToStr/Comment.nvim",
		dependencies = {
			{
				"JoosepAlviste/nvim-ts-context-commentstring",
				dependencies = {
					"nvim-treesitter/nvim-treesitter",
				},
				opts = {
					enable_autocmd = false,
				},
				config = function(_, opts) require("ts_context_commentstring").setup(opts) end,
			},
		},
		keys = {
			{ "gcc", mode = "n", desc = "Comment toggle current line" },
			{ "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
			{ "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
			{ "gbc", mode = "n", desc = "Comment toggle current block" },
			{ "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
			{ "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
		},
		-- because prehook is call so it need to return from a function
		main = "Comment",
		opts = function() return require("config.comment.Comment") end,
	},

	{
		"folke/todo-comments.nvim",
		cmd = { "TodoQuickFix", "TodoTelescope" },
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		event = { "CursorHold", "CmdlineEnter", "CursorMoved" },
		-- opts = require("config.comment.todo-comments"),
		main = "todo-comments",
		opts = {},
	},

	--------------------------------------------------- Git supporter ---------------------------------------------------
	{
		"lewis6991/gitsigns.nvim",
		event = "User GitLazyLoaded",
		main = "gitsigns",
		opts = function() return require("config.git.gitsigns") end,
	},

	{
		"akinsho/git-conflict.nvim",
		event = "User GitLazyLoaded",
		main = "git-conflict",
		opts = function() return require("config.git.git-conflict") end,
	},

	--------------------------------------------------- LSP ---------------------------------------------------
	{
		"neovim/nvim-lspconfig",
		event = "User FilePostLazyLoaded",
		config = function() require("config.lsp.lspconfig") end,
	},

	{
		"sontungexpt/better-diagnostic-virtual-text",
	},

	{
		"mfussenegger/nvim-jdtls",
		ft = "java",
		-- config is in ftplugin/java.lua
	},

	{
		"mrcjkb/rustaceanvim",
		ft = "rust",
		-- config is in ftplugin/rust.lua
	},

	{
		"akinsho/flutter-tools.nvim",
		ft = "dart",
		event = "BufReadPost */pubspec.yaml",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim", -- optional for vim.ui.select
		},
		main = "flutter-tools",
		opts = function() return require("config.flutter-tools") end,
	},

	{
		"glepnir/lspsaga.nvim",
		cmd = "Lspsaga",
		dependencies = {
			"neovim/nvim-lspconfig",
			"nvim-tree/nvim-web-devicons",

			--Please make sure you install markdown and markdown_inline parser
			"nvim-treesitter/nvim-treesitter",
		},
		main = "lspsaga",
		opts = function() return require("config.lsp.lspsaga") end,
	},

	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		cmd = {
			"Mason",
			"MasonLog",
			"MasonUpdate",
			"MasonInstall",
			"MasonUninstall",
			"MasonUninstallAll",
		},
		main = "mason",
		opts = function() return require("config.mason") end,
	},

	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				-- snippet plugin
				"L3MON4D3/LuaSnip",
				build = "make install_jsregexp",
				dependencies = "rafamadriz/friendly-snippets",
				config = function() require("config.cmp.LuaSnip") end,
			},

			-- cmp sources plugins
			{
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-nvim-lua",
				"saadparwaiz1/cmp_luasnip",
			},
		},
		config = function() require("config.cmp") end,
	},

	{
		"stevearc/conform.nvim",
		cmd = "ConformInfo",
		event = "BufWritePre",
		main = "conform",
		opts = function() return require("config.conform") end,
	},

	--------------------------------------------------- Debugger  ---------------------------------------------------
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			{
				"mfussenegger/nvim-dap",
				config = function() require("config.dap") end,
			},
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
		},
		main = "dapui",
		opts = function() require("config.dap.dapui") end,
	},
	--------------------------------------------------- Dashboard  ---------------------------------------------------

	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
		  bigfile = { enabled = true },
		  dashboard = { enabled = true },
		  indent = { enabled = true },
		  input = { enabled = true },
		  notifier = {
			enabled = true,
			timeout = 3000,
		  },
		  preset = {
			pick = nil,
			keys = {
			  { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
			  { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
			  { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
			  { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
			  { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
			  { icon = " ", key = "s", desc = "Restore Session", section = "session" },
			  { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
			  { icon = " ", key = "Q", desc = "Quit", action = ":qa"},
			},
			
			header = [[
  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
  
  
		  },
		  quickfile = { enabled = true },
		  scroll = { enabled = true },
		  statuscolumn = { enabled = true },
		  words = { enabled = true },
		  sections = {
            { section = "header" },
            { section = "keys", gap = 1, padding = 1 },
            { section = "startup" },
            {
              section = "terminal",
              cmd = "pokemon-colorscripts -n snorlax --no-title; sleep .1",
              random = 10,
              pane = 2,
              indent = 4,
              height = 30,
            },
          },
		},
		
		keys = {
		  { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
		  { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
		  { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
		  { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
		  { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
		  { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
		  { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
		  { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
		  { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
		  { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
		  { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
		  { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)" },
		  { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
		  { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
		  { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
		  { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
		  { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
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
				  signcolumn = "yes",
				  statuscolumn = " ",
				  conceallevel = 3,
				},
			  })
			end,
		  }
		},
		init = function()
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
			  Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
			  Snacks.toggle.treesitter():map("<leader>uT")
			  Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
			  Snacks.toggle.inlay_hints():map("<leader>uh")
			  Snacks.toggle.indent():map("<leader>ug")
			  Snacks.toggle.dim():map("<leader>uD")
			end,
		  })
		end,
	  }
}

require("lazy").setup(plugins, require("config.lazy-nvim"))
vim.api.nvim_set_keymap("n", "<leader>d", ":lua require('snacks.dashboard').open()<CR>", { noremap = true, silent = true })
