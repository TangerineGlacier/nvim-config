-- General Neovim settings
vim.o.number = true
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.clipboard = 'unnamedplus'
vim.o.wrap = true

vim.o.hlsearch = true

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
require("lazy").setup({
  -- nvim-colorizer plugin to highlight color codes
  {
    "norcalli/nvim-colorizer.lua",  
    config = function()
      require'colorizer'.setup()
    end
  },

  -- Snacks plugin configuration for dashboard
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        width = 60,
        height = 20,  -- Set a fixed height to prevent scrolling
        row = nil,    -- Center position
        col = nil,    -- Center position
        pane_gap = 4,
        autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
        preset = {
          pick = nil,
          keys = {
            { icon = "", key = "f", desc = "Find File", action = ":Telescope find_files" },
            { icon = "", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = "", key = "g", desc = "Find Text", action = ":Telescope live_grep" },
            { icon = "", key = "r", desc = "Recent Files", action = ":Telescope oldfiles" },
            { icon = "", key = "c", desc = "Config", action = ":e $MYVIMRC" },
            { icon = "", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰙦", key = "L", desc = "Lazy", action = ":Lazy" },
            { icon = "", key = "q", desc = "Quit", action = ":qa" },
          },
          header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],        
        },
        sections = {
            { section = "header" },
            { section = "keys", gap = 1, padding = 1 },
            { section = "startup" },
            {
              section = "terminal",
              cmd = "pokemon-colorscripts -n charizard --no-title; sleep .1",
              random = 10,
              pane = 2,
              indent = 4,
              height = 30,
            },
          },
        formats = {
          icon = function(item)
            return { { item.icon, width = 2, hl = "icon" } }
          end,
          header = { "%s", align = "center" },
          file = function(item, ctx)
            local fname = vim.fn.fnamemodify(item.file, ":~")
            if #fname > ctx.width then
              fname = vim.fn.pathshorten(fname)
            end
            return { { fname, hl = "file" } }
          end,
        },
      },
    },
  },

  -- Telescope plugin setup for fuzzy finding
  {
    "nvim-telescope/telescope.nvim", 
    requires = { "nvim-lua/plenary.nvim" },
  },

  -- tokyonight.nvim plugin setup
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      local transparent = false -- Set to true if you would like to enable transparency

      local bg = "#011628"
      local bg_dark = "#011423"
      local bg_highlight = "#143652"
      local bg_search = "#0A64AC"
      local bg_visual = "#275378"
      local fg = "#CBE0F0"
      local fg_dark = "#B4D0E9"
      local fg_gutter = "#627E97"
      local border = "#547998"

      require("tokyonight").setup({
        style = "night",
        transparent = transparent,
        styles = {
          sidebars = transparent and "transparent" or "dark",
          floats = transparent and "transparent" or "dark",
        },
        on_colors = function(colors)
          colors.bg = bg
          colors.bg_dark = transparent and colors.none or bg_dark
          colors.bg_float = transparent and colors.none or bg_dark
          colors.bg_highlight = bg_highlight
          colors.bg_popup = bg_dark
          colors.bg_search = bg_search
          colors.bg_sidebar = transparent and colors.none or bg_dark
          colors.bg_statusline = transparent and colors.none or bg_dark
          colors.bg_visual = bg_visual
          colors.border = border
          colors.fg = fg
          colors.fg_dark = fg_dark
          colors.fg_float = fg
          colors.fg_gutter = fg_gutter
          colors.fg_sidebar = fg_dark
        end,
      })

      vim.cmd("colorscheme tokyonight")
    end,
  },
})

-- Keybinding to open dashboard
vim.api.nvim_set_keymap('n', '<Leader>d', ':lua require("snacks.dashboard").open()<CR>', { noremap = true, silent = true })
