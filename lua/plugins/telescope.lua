return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    dependencies = { 
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzf-native.nvim',
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
            '--glob=!__pycache__/',
            '--glob=!.pytest_cache/',
            '--glob=!.venv/',
            '--glob=!venv/',
            '--glob=!env/',
            '--glob=!ENV/',
            '--glob=!.env/',
            '--glob=!dist/',
            '--glob=!build/',
            '--glob=!.DS_Store',
          },
        },
        pickers = {
          find_files = {
            hidden = false,
            no_ignore = false,
            find_command = {
              'rg',
              '--files',
              '--hidden',
              '--glob=!.git/',
              '--glob=!node_modules/',
              '--glob=!__pycache__/',
              '--glob=!.pytest_cache/',
              '--glob=!.venv/',
              '--glob=!venv/',
              '--glob=!env/',
              '--glob=!ENV/',
              '--glob=!.env/',
              '--glob=!dist/',
              '--glob=!build/',
              '--glob=!.DS_Store',
            },
            follow = true,
            respect_gitignore = true,
          },
          live_grep = {
            additional_args = function()
              return {
                "--hidden",
                "--glob=!.git/",
                "--glob=!node_modules/",
                "--glob=!__pycache__/",
                "--glob=!.pytest_cache/",
                "--glob=!.venv/",
                "--glob=!venv/",
                "--glob=!env/",
                "--glob=!ENV/",
                "--glob=!.env/",
                "--glob=!dist/",
                "--glob=!build/",
                "--glob=!.DS_Store",
              }
            end,
          },
        },
      })

      -- Load fzf native extension
      pcall(telescope.load_extension, 'fzf')

      -- Keybindings
      vim.keymap.set('n', '<D-S-P>', builtin.find_files, { desc = 'Find files' })
      vim.keymap.set('n', '<D-F>', builtin.live_grep, { desc = 'Live grep' })
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
    end,
  },
} 