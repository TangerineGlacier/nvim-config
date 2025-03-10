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

require('lazy').setup({
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- Optional: for file icons
    },
    config = function()
      require("nvim-tree").setup {
        -- Add any custom nvim-tree settings here.
        update_focused_file = { enable = true },
        view = {
          width = 30,
          side = 'left',
        },
      }
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
      line = "<leader>cc",  -- cmd + /
      --- Block-comment toggle keymap
      block = "<leader>bc",
    },
  },
  lazy = false,
},
{
  "rest-nvim/rest.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    opts = function (_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "http")
    end,
  }
},
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
      window = {
        position = "left",
        mappings = {
          ["J"] = function(state)
            local tree = state.tree
            local node = tree:get_node()
            local siblings = tree:get_nodes(node:get_parent_id())
            local renderer = require("neo-tree.ui.renderer")
            renderer.focus_node(state, siblings[#siblings]:get_id())
          end,
          ["K"] = function(state)
            local tree = state.tree
            local node = tree:get_node()
            local siblings = tree:get_nodes(node:get_parent_id())
            local renderer = require("neo-tree.ui.renderer")
            renderer.focus_node(state, siblings[1]:get_id())
          end,
        },
      },
      sort_function = function(a, b)
        -- Simplified check if a path is in the 'notes' directory
        local function is_in_notes_directory(path)
          return string.match(path, "/notes/") or string.match(path, "^notes/")
        end

        -- Get the modification time of a file
        local function get_mod_time(path)
          local attributes = vim.loop.fs_stat(path)
          return attributes and attributes.mtime.sec or 0
        end

        -- Prioritize directories over files
        if a.type ~= b.type then
          return a.type == "directory"
        end

        local a_in_notes = is_in_notes_directory(a.path)
        local b_in_notes = is_in_notes_directory(b.path)

        -- If both nodes are files in 'notes' directories, sort by modification time
        if a_in_notes and b_in_notes and a.type ~= "directory" and b.type ~= "directory" then
          return get_mod_time(a.path) > get_mod_time(b.path)
        end

        -- Default sort by name, assuming `name` property or similar is available
        -- You might need to extract the name from `a.path` and `b.path` if direct comparison is needed
        local a_name = a.path:match("^.+/(.+)$") or a.path
        local b_name = b.path:match("^.+/(.+)$") or b.path
        return a_name < b_name
      end,
    },
  },
  
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" }
},
  {
    "lervag/vimtex",
    ft = { "tex" },
    config = function()
      vim.g.vimtex_view_method = "zathura"  -- Set Zathura as viewer
      vim.g.vimtex_compiler_method = "latexmk"  -- Use latexmk for compilation
      vim.g.vimtex_quickfix_mode = 0  -- Disable quickfix auto-popup
    end
  },  

  { 'echasnovski/mini.nvim', version = false },
  {
    "mhartington/formatter.nvim",
    config = function()
      require("formatter").setup({
        logging = false,  -- Enable if you need debugging
        filetype = {
          python = {
            -- Format Python files with Black
            function()
              return {
                exe = "black",         -- Make sure Black is installed: pip install black
                args = {"--quiet", "-"},-- Use '-' to read from stdin
                stdin = true,
              }
            end,
          },
          json = {
            -- Format JSON files with Prettier
            function()
              return {
                exe = "prettier",      -- Make sure Prettier is installed: npm install -g prettier
                args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0)},
                stdin = true,
              }
            end,
          },
          javascript = {
            -- Format JavaScript files with Prettier
            function()
              return {
                exe = "prettier",
                args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0)},
                stdin = true,
              }
            end,
          },
          typescript = {
            -- Format TypeScript files with Prettier
            function()
              return {
                exe = "prettier",
                args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0)},
                stdin = true,
              }
            end,
          },
          go = {
            -- Format Go files with gofmt
            function()
              return {
                exe = "gofmt",
                args = {},
                stdin = true,
              }
            end,
          },
        },
      })

      -- Map Option+Shift+F (as <A-F>) to run the formatter
      vim.keymap.set("n", "<A-F>", ":Format<CR>", { noremap = true, silent = true })
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = true ,
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 3 },
        { section = "startup" },
        {
          section = "terminal",
          cmd = "pokemon-colorscripts -n charizard  --no-title; sleep .1",
          random = 10,
          pane = 2,
          indent = 4,
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
          wo = { wrap = true } -- Wrap notifications
        }
      }
    },
    keys = {
      { "<leader>d", function() Snacks.dashboard() end, desc = "Open Dashboard" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse" },
      { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
      { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)" },
      { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
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
              -- signcolumn = "yes",
              statuscolumn = " ",
              conceallevel = 3,
            },
          })
        end,
      },
      { "<leader>d", function() Snacks.dashboard() end, desc = "Open Dashboard" },
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
          Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
        end,
      })
    end,
  },
  {
    "mistricky/codesnap.nvim",
    build = "make",
  },
  {
    "NeogitOrg/neogit",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional - Diff integration
      "nvim-telescope/telescope.nvim", -- optional
    },
    config = true
  },
  -- {
  --   'Exafunction/codeium.vim',
  --   event = "InsertEnter",
  --   config = function ()
  --     -- Change '<C-g>' here to any keycode you like.
  --     vim.keymap.set('i', '<C-e>', function () return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
  --     vim.keymap.set('i', '<c-n>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
  --     vim.keymap.set('i', '<c-p>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
  --     vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
  --   end
  -- },
  'onsails/lspkind.nvim',
  
  "preservim/vim-pencil",

  'folke/zen-mode.nvim',
  'tpope/vim-obsession',
  'ThePrimeagen/git-worktree.nvim',
  -- "tpope/vim-furround",
  {
    'rmagatti/goto-preview',
    config = function()
      require('goto-preview').setup {
        width = 120; -- Width of the floating window
        height = 15; -- Height of the floating window
        border = {"↖", "─" ,"┐", "│", "┘", "─", "└", "│"}; -- Border characters of the floating window
        default_mappings = true;
        debug = false; -- Print debug information
        opacity = nil; -- 0-100 opacity level of the floating window where 100 is fully transparent.
        resizing_mappings = false; -- Binds arrow keys to resizing the floating window.
        post_open_hook = nil; -- A function taking two arguments, a buffer and a window to be ran as a hook.
        references = { -- Configure the telescope UI for slowing the references cycling window.
          telescope = require("telescope.themes").get_dropdown({ hide_preview = false })
        };
        -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
        focus_on_open = true; -- Focus the floating window when opening it.
        dismiss_on_move = false; -- Dismiss the floating window when moving the cursor.
        force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
        bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
        stack_floating_preview_windows = true, -- Whether to nest floating windows
        preview_window_title = { enable = true, position = "left" }, -- Whether 
      }
    end
  },

  {
    "folke/trouble.nvim",
    lazy = false,
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  },

  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {}
    end
  },

  {
    "folke/noice.nvim",
    config = function()
      require("noice").setup({
        -- add any options here
        
        routes = {
          {
            filter = {
              event = 'msg_show',
              any = {
                { find = '%d+L, %d+B' },
                { find = '; after #%d+' },
                { find = '; before #%d+' },
                { find = '%d fewer lines' },
                { find = '%d more lines' },
              },
            },
            opts = { skip = true },
          }
        },
      })
    end,
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  },

  'ray-x/go.nvim',
  'ray-x/guihua.lua',
  {
    "tiagovla/tokyodark.nvim",
    opts = {
        -- custom options here
    },
    config = function(_, opts)
        require("tokyodark").setup(opts) -- calling setup is optional
        vim.cmd [[colorscheme tokyodark]]
    end,
  },
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',
    }
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip'
    },
    config = function()
      -- nvim-cmp setup
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'

      cmp.setup({
        view = {
          entries = "native"
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = "neorg" },
        },
      })
    end
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',

    build = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    }
  },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x', -- or whichever branch/version you prefer
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local telescope = require('telescope')
      telescope.setup{
        defaults = {
          prompt_prefix = "🔍 ",
          selection_caret = " ",
          path_display = { "smart" },
        },
        pickers = {
          find_files = {
            -- picker-specific options here.
          },
        },
        extensions = {
          -- Your extensions configuration.
        },
      }
  
      -- Map Cmd+P to open Telescope's find_files (only works in GUI clients)
      vim.keymap.set("n", "<C-P>", ":Telescope find_files<CR>", { noremap = true, silent = true })
  
      -- Optionally, load Telescope extensions.
      -- telescope.load_extension('fzf')
    end,
  },  
  {
    "epwalsh/obsidian.nvim",
    version = "*",  -- Use latest version
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",  -- Optional: for completion
      "nvim-telescope/telescope.nvim",  -- Optional: for searching notes
    },
    opts = {
      workspaces = {
        {
          name = "my-notes",
          path = "~/Documents/ObsidianVault",
        },
      },
    },
  },  

  {
    "rcarriga/nvim-dap-ui",
    dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"}
  },
  'theHamsta/nvim-dap-virtual-text',
  'leoluz/nvim-dap-go',

  -- Git related plugins
  'tpope/vim-fugitive',
  'lewis6991/gitsigns.nvim',

  'nvim-lualine/lualine.nvim', -- Fancier statusline
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
  -- {
  --   'numToStr/Comment.nvim', -- "gc" to comment visual regions/lines 
  --   event = { "BufRead", "BufNewFile" },
  --   config = true
  -- },
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },
  'nvim-telescope/telescope-symbols.nvim',
  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = vim.fn.executable 'make' == 1 },
  {
    "folke/twilight.nvim",
    ft = "markdown",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },
})
