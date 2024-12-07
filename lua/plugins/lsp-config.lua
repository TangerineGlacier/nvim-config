return {
    -- Mason plugin for managing LSP servers
    {
      "williamboman/mason.nvim",
      lazy = false,
      config = function()
        require("mason").setup()
      end,
    },
    
    -- mason-lspconfig for automatic installation of LSP servers
    {
      "williamboman/mason-lspconfig.nvim",
      lazy = false,
      opts = {
        auto_install = true,
      },
    },
    
    -- nvim-lspconfig to configure and enable LSPs
    {
      "neovim/nvim-lspconfig",
      lazy = false,
      config = function()
        -- Setup completion capabilities with cmp_nvim_lsp
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
  
        local lspconfig = require("lspconfig")
  
        -- Set up LSP servers with the updated 'ts_ls' for TypeScript
        lspconfig.ts_ls.setup({
          capabilities = capabilities,
        })
  
        lspconfig.solargraph.setup({
          capabilities = capabilities,
        })
  
        lspconfig.html.setup({
          capabilities = capabilities,
        })
  
        lspconfig.lua_ls.setup({
          capabilities = capabilities,
        })
  
        -- LSP key mappings
        vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
        vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
        vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
      end,
    },
  }
  