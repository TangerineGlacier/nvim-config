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
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            no_ignore = true,
          },
          live_grep = {
            additional_args = function()
              return { "--hidden", "--glob=!.git/" }
            end,
          },
        },
      })

      -- Load fzf native extension
      pcall(telescope.load_extension, 'fzf')

      -- Keybindings
      vim.keymap.set('n', '<D-p>', builtin.find_files, { desc = 'Find files' })
      vim.keymap.set('n', '<D-F>', builtin.live_grep, { desc = 'Live grep' })
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
    end,
  },
} 