-- General settings
vim.o.number = true
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.clipboard = 'unnamedplus'

-- Enable line wrapping
vim.o.wrap = true

-- Highlight search results
vim.o.hlsearch = true

-- Load additional configuration
require("config.lazy")

-- Bootstrap lazy.nvim
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

-- Set up plugins using lazy.nvim
require("lazy").setup("plugins")

-- Set up the dashboard plugin using lazy.nvim
require('lazy').setup({
  {
    'glepnir/dashboard-nvim',
    config = function()
      -- Dashboard configuration
      require('dashboard').setup {
        homepage = {
          enable = true,
          message = "Welcome to Neovim!", -- Custom welcome message
        },
        section = {
          a = { description = { "  Find File" }, command = "Telescope find_files" },
          b = { description = { "  Recently Used Files" }, command = "Telescope oldfiles" },
          c = { description = { "  Find Word" }, command = "Telescope live_grep" },
        },
        header = {
          "Welcome to your customized dashboard!",
          "Feel free to add more sections or tweak the settings."
        },
      }
    end
  }
})

-- Open the dashboard using Leader + d
vim.api.nvim_set_keymap('n', '<Leader>d', ':Dashboard<CR>', { noremap = true, silent = true })
