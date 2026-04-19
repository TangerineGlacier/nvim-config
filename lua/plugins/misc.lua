-- worktree settings
require('git-worktree').setup()

-- Go
local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
   require('go.format').goimport()
  end,
  group = format_sync_grp,
})

require('go').setup({
  -- Disable some features that might cause issues
  goimport = 'goimports',
  gofmt = 'golines',
  max_line_len = 120,
  tag_transform = false,
  test_dir = '',
  comment_placeholder = '',
  linter = 'golint',
  linter_flags = {},
  lint_prompt_style = 'vt',
  dap_debug = true,
  dap_debug_keymap = true,
  dap_debug_gui = true,
  dap_debug_vt = true,
  build_tags = '',
  textobjects = true,
  test_runner = 'go',
  run_in_floaterm = false,
  floaterm = {
    posititon = 'auto',
    width = 0.45,
    height = 0.98,
    title_colors = 'nord',
  },
  trouble = true,
  test_efm = true,
  luasnip = true,
  -- Fix for GoIfErr command
  iferr_vertical = false,
  iferr_abbrev = true,
  -- go.nvim maps <space>e to diagnostic float on Go buffers; leader is space, so that overrides Neotree.
  lsp_on_client_start = function(_, bufnr)
    pcall(vim.keymap.del, "n", "<space>e", { buffer = bufnr })
    vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float, {
      buffer = bufnr,
      silent = true,
      noremap = true,
      desc = "Diagnostic float (was <space>e from go.nvim)",
    })
  end,
})

-- Neovim 0.11 ships vim.lsp.codelens without enable(); go.nvim still calls it.
-- Use refresh({ bufnr = 0 }) when enable is missing (newer nightlies may add enable).
do
  local m = require("go.codelens")
  function m.refresh()
    local gopls = require("go.lsp").client()
    require("go.utils").log("refresh codelens")
    if not gopls then
      return
    end
    if _GO_NVIM_CFG.lsp_codelens == true then
      if vim.lsp.codelens.enable then
        vim.lsp.codelens.enable(true, { bufnr = 0 })
      else
        vim.lsp.codelens.refresh({ bufnr = 0 })
      end
    else
      require("go.utils").log("refresh codelens")
      vim.lsp.codelens.clear(gopls.id, 0)
    end
  end
end

-- Add command to clear Go temporary files
vim.api.nvim_create_user_command('GoClearTemp', function()
  -- Clear any temporary Go files that might be causing issues
  vim.cmd('silent! !find /tmp -name "*iferr*" -delete 2>/dev/null || true')
  vim.cmd('silent! !find /tmp -name "*go*" -name "*.go" -delete 2>/dev/null || true')
  vim.notify("Go temporary files cleared", vim.log.levels.INFO)
end, { desc = "Clear Go temporary files" })

