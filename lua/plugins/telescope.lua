return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    dependencies = { 
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzf-native.nvim',
      'nvim-telescope/telescope-git-worktree.nvim',
    },
    config = function()
      local telescope = require('telescope')
      local builtin = require('telescope.builtin')

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
            },
          },
          -- Custom highlighting to make text white
          color_devicons = true,
          set_env = { ['COLORTERM'] = 'truecolor' },
          prompt_prefix = "🔍 ",
          selection_caret = "❯ ",
          entry_prefix = "  ",
          initial_mode = "insert",
          selection_strategy = "reset",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
            '--glob=!.git/',
            '--glob=!node_modules/',
            '--glob=!**/node_modules/',
            '--glob=!**/node_modules/**/*',
            '--glob=!__pycache__/',
            '--glob=!.pytest_cache/',
            '--glob=!.venv/',
            '--glob=!venv/',
            '--glob=!env/',
            '--glob=!ENV/',
            '--glob=!dist/',
            '--glob=!build/',
            '--glob=!.DS_Store',
            '--glob=.env*',
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            grep_string = {
              additional_args = {"--hidden"}
            },
            live_grep = {
              additional_args = {"--hidden"}
            },
            no_ignore = true,
            follow = true,
            respect_gitignore = false,
            file_ignore_patterns = {
              "node_modules",
              "gitignore",
            },
            find_command = {
              'rg',
              '--files',
              '--hidden',
              '--glob=!.git/',
              '--glob=!node_modules/',
              '--glob=!gitignore/',
              '--glob=!__pycache__/',
              '--glob=!.pytest_cache/',
              '--glob=!.venv/',
              '--glob=!venv/',
              '--glob=!env/',
              '--glob=!ENV/',
              '--glob=!dist/',
              '--glob=!build/',
              '--glob=!.DS_Store',
              '--glob=.env*',
            },
          },
          live_grep = {
            additional_args = function()
              return {
                "--hidden",
                "--glob=!.git/",
                "--glob=!node_modules/",
                "--glob=!gitignore/",
                "--glob=!__pycache__/",
                "--glob=!.pytest_cache/",
                "--glob=!.venv/",
                "--glob=!venv/",
                "--glob=!env/",
                "--glob=!ENV/",
                "--glob=!dist/",
                "--glob=!build/",
                "--glob=!.DS_Store",
                "--glob=.env*",
              }
            end,
            file_ignore_patterns = {
              "node_modules",
              "gitignore",
            },
          },
        },
      })

      -- Load extensions
      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'git_worktree')

      -- Custom highlight groups to make Telescope text white
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          -- Telescope highlights
          vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { fg = "#ffffff", bold = true })
          vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = "#ffffff", bold = true })
          vim.api.nvim_set_hl(0, "TelescopePromptCounter", { fg = "#ffffff" })
          vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#ffffff" })
          vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = "#ffffff", bold = true })
          vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = "#ffffff" })
          vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = "#ffffff", bold = true })
          vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = "#ffffff" })
          vim.api.nvim_set_hl(0, "TelescopeNormal", { fg = "#ffffff" })
          vim.api.nvim_set_hl(0, "TelescopeSelection", { fg = "#ffffff", bg = "#404040" })
          vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = "#ffffff" })
          vim.api.nvim_set_hl(0, "TelescopeMultiSelection", { fg = "#ffffff" })
          vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = "#ffffff", bold = true })
          vim.api.nvim_set_hl(0, "TelescopePromptNormal", { fg = "#ffffff" })
          vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { fg = "#ffffff" })
          vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { fg = "#ffffff" })
        end,
      })

      -- Trigger the highlight setup
      vim.cmd("doautocmd ColorScheme")

      -- Custom finder function to exclude node_modules
      local function find_files_no_node_modules()
        require('telescope.builtin').find_files({
          hidden = false,
          no_ignore = true,
          follow = true,
          respect_gitignore = false,
          file_ignore_patterns = {
            "node_modules",
            "gitignore",
          },
          find_command = {
            'rg',
            '--files',
            '--hidden',
            '--glob=!.git/',
            '--glob=!node_modules/',
            '--glob=!gitignore/',
            '--glob=!__pycache__/',
            '--glob=!.pytest_cache/',
            '--glob=!.venv/',
            '--glob=!venv/',
            '--glob=!env/',
            '--glob=!ENV/',
            '--glob=!dist/',
            '--glob=!build/',
            '--glob=!.DS_Store',
            '--glob=.env*',
          },
        })
      end

      -- Keybindings
      vim.keymap.set('n', '<D-S-P>', find_files_no_node_modules, { desc = 'Find files (no node_modules)' })
      vim.keymap.set('n', '<D-F>', builtin.live_grep, { desc = 'Live grep' })
      vim.keymap.set('n', '<D-S-F>', builtin.live_grep, { desc = 'Universal search (live grep)' })
      vim.keymap.set('n', '<leader>ff', find_files_no_node_modules, { desc = 'Find files (no node_modules)' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
      
      -- Additional useful keybindings
      vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = 'Find recently opened files' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'Search current word' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = 'Search diagnostics' })
      vim.keymap.set('n', '<leader>sS', builtin.git_status, { desc = 'Git status' })
      vim.keymap.set('n', '<leader>sr', '<CMD>lua require("telescope").extensions.git_worktree.git_worktrees()<CR>', { desc = 'Git worktrees' })
      vim.keymap.set('n', '<leader>sR', '<CMD>lua require("telescope").extensions.git_worktree.create_git_worktree()<CR>', { desc = 'Create git worktree' })
      vim.keymap.set('n', '<leader>sn', '<CMD>lua require("telescope").extensions.notify.notify()<CR>', { desc = 'Notifications' })
      vim.keymap.set('n', 'st', ':TodoTelescope<CR>', { desc = 'Todo comments' })
      vim.keymap.set('n', '<leader><tab>', builtin.commands, { desc = 'Commands' })
    end,
  },
} 
