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
