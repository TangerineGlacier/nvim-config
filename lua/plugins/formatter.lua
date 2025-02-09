return {
    {
      "mhartington/formatter.nvim",
      config = function()
        require("formatter").setup({
          logging = false,  -- Enable to debug formatting issues
          filetype = {
            python = {
              -- Format Python files with Black
              function()
                return {
                  exe = "black",         -- Ensure Black is installed: pip install black
                  args = {"--quiet", "-"},-- Use '-' to read from stdin
                  stdin = true,
                }
              end,
            },
            json = {
              -- Format JSON files with Prettier
              function()
                return {
                  exe = "prettier",      -- Ensure Prettier is installed: npm install -g prettier
                  args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0)},
                  stdin = true,
                }
              end,
            },
            javascript = {
              -- Format JavaScript files with Prettier
              function()
                return {
                  exe = "prettier",
                  args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0)},
                  stdin = true,
                }
              end,
            },
            typescript = {
              -- Format TypeScript files with Prettier
              function()
                return {
                  exe = "prettier",
                  args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0)},
                  stdin = true,
                }
              end,
            },
            go = {
              -- Format Go files with gofmt (you may use goimports if you prefer)
              function()
                return {
                  exe = "gofmt",  -- gofmt is included with Go
                  args = {},
                  stdin = true,
                }
              end,
            },
          },
        })
  
        -- Key Mapping: Bind Option+Shift+F (represented as <A-F>) to format the current file
        vim.keymap.set("n", "<A-F>", ":Format<CR>", { noremap = true, silent = true })
      end,
    },
  }
  