return {
    -- Example plugins
    { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },  -- Syntax highlighting
    { "neovim/nvim-lspconfig" },  -- LSP support
    { "nvim-telescope/telescope.nvim", requires = { "nvim-lua/plenary.nvim" } },  -- Fuzzy finding
  
    -- Snacks plugin
    { 'folke/snacks.nvim', config = function() require('snacks').setup() end },

    -- Dashboard plugin
    {
        'glepnir/dashboard-nvim',
        config = function()
            require('dashboard').setup {
                -- Set up your custom dashboard configuration here
                homepage = {
                    enable = true,
                    message = "Welcome to Neovim!", -- Custom welcome message
                },
                section = {
                    a = { description = { "  Find File" }, command = "Telescope find_files" },
                    b = { description = { "  Recently Used Files" }, command = "Telescope oldfiles" },
                    c = { description = { "  Find Word" }, command = "Telescope live_grep" },
                },
            }
        end
    },
}
