-- Diagnostic keymaps
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>di', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- Enable mouse support for LSP features
  vim.api.nvim_buf_set_option(bufnr, 'mousemoveevent', true)
  
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  -- Mouse mappings
  vim.keymap.set('n', '<LeftMouse>', '<LeftMouse>', { buffer = bufnr })
  vim.keymap.set('n', '<C-LeftMouse>', '<LeftMouse><Cmd>lua vim.lsp.buf.definition()<CR>', { buffer = bufnr })
  vim.keymap.set('i', '<C-LeftMouse>', '<LeftMouse><Cmd>lua vim.lsp.buf.definition()<CR>', { buffer = bufnr })
  vim.keymap.set('n', '<S-LeftMouse>', '<LeftMouse><Cmd>lua vim.lsp.buf.references()<CR>', { buffer = bufnr })
  vim.keymap.set('i', '<S-LeftMouse>', '<LeftMouse><Cmd>lua vim.lsp.buf.references()<CR>', { buffer = bufnr })

  -- Ctrl+Enter for go to definition
  vim.keymap.set('n', '<C-CR>', '<Cmd>lua vim.lsp.buf.definition()<CR>', { buffer = bufnr, desc = 'Go to Definition' })
  vim.keymap.set('i', '<C-CR>', '<Cmd>lua vim.lsp.buf.definition()<CR>', { buffer = bufnr, desc = 'Go to Definition' })

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    if vim.lsp.buf.format then
      vim.lsp.buf.format()
    elseif vim.lsp.buf.formatting then
      vim.lsp.buf.formatting()
    end
  end, { desc = 'Format current buffer with LSP' })
end

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Setup mason-lspconfig to auto-install LSP servers
require('mason-lspconfig').setup({
  ensure_installed = {
    'clangd', 
    'rust_analyzer', 
    'pyright', 
    'jsonls',
    'golangci_lint_ls',
    'html',      -- HTML
    'gopls',
    'tailwindcss', -- Tailwind CSS
    'eslint',     -- ESLint
    'bashls'      -- Bash Language Server
  },
  automatic_installation = true,
})

-- Enable the following language servers
-- Feel free to add/remove any LSPs that you want here. They will automatically be installed
local servers = { 
  'clangd', 
  'rust_analyzer', 
  'pyright', 
  -- 'ts_ls', -- Configured separately below
  'jsonls',
  'golangci_lint_ls',
  'html',      -- HTML
  'gopls',
  'tailwindcss', -- Tailwind CSS
  'eslint',     -- ESLint
  'bashls'      -- Bash Language Server
}

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Enable additional capabilities for better auto-imports
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

-- Setup LSP configurations
for _, lsp in ipairs(servers) do
  local config = {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  -- Add specific configurations for certain servers
  if lsp == 'html' then
    config.filetypes = { 'html', 'javascriptreact', 'typescriptreact' }
  elseif lsp == 'tailwindcss' then
    config.filetypes = { 'html', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'css' }
  elseif lsp == 'eslint' then
    config.filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }
    config.settings = {
      codeAction = {
        disableRuleComment = {
          enable = true,
          location = "separateLine"
        },
        showDocumentation = {
          enable = true
        }
      },
      codeActionOnSave = {
        enable = true,
        mode = "all"
      },
      format = false,
      nodePath = "",
      onIgnoredFiles = "off",
      packageManager = "npm",
      quiet = false,
      rulesCustomizations = {},
      run = "onType",
      useESLintClass = false,
      validate = "on",
      workingDirectory = {
        mode = "location"
      }
    }
  end

  require('lspconfig')[lsp].setup(config)
end

-- Configure TypeScript server with nvim-lsp-ts-utils for better auto-imports
require('lspconfig').ts_ls.setup({
  on_attach = function(client, bufnr)
    -- Setup nvim-lsp-ts-utils for enhanced TypeScript functionality
    local ts_utils = require('nvim-lsp-ts-utils')
    ts_utils.setup({
      enable_import_on_completion = true,
      import_all_timeout = 5000,
      import_all_priorities = {
        same_file = 1,
        local_files = 2,
        buffer_content = 3,
        buffers = 4,
      },
      import_all_scan_buffers = 100,
      import_all_select_source = false,
      auto_organize_imports = true,
      update_imports_on_move = true,
      require_confirmation_on_move = false,
      watch_dir = nil,
    })
    ts_utils.setup_client(client)
    
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
  settings = {
    typescript = {
      suggest = {
        autoImports = true,
        includeCompletionsForModuleExports = true,
      },
      inlayHints = {
        enabled = true,
      },
      preferences = {
        includePackageJsonAutoImports = "auto",
        includeCompletionsForImportStatements = true,
        includeCompletionsWithSnippetText = true,
        includeCompletionsWithInsertText = true,
        allowIncompleteCompletions = true,
      },
    },
    javascript = {
      suggest = {
        autoImports = true,
        includeCompletionsForModuleExports = true,
      },
      inlayHints = {
        enabled = true,
      },
      preferences = {
        includePackageJsonAutoImports = "auto",
        includeCompletionsForImportStatements = true,
        includeCompletionsWithSnippetText = true,
        includeCompletionsWithInsertText = true,
        allowIncompleteCompletions = true,
      },
    },
  },
  init_options = {
    preferences = {
      includePackageJsonAutoImports = "auto",
      includeCompletionsForImportStatements = true,
    },
    hostInfo = "neovim",
  },
})

-- Turn on lsp status information
require('fidget').setup()

-- Example custom configuration for lua
--
-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

require('lspconfig').lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = { enable = false },
    },
  },
}

vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { silent = true, noremap = true })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'sh',
  callback = function()
    vim.lsp.start({
      name = 'bash-language-server',
      cmd = { 'bash-language-server', 'start' },
    })
  end,
})

