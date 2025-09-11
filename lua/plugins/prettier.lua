return {
    -- Disabled to prevent conflicts with conform.nvim
    -- {
    --   "MunifTanjim/prettier.nvim",
    --   bin = "prettierd",
    --   filetypes = {
    --     "css",
    --     "html",
    --     "javascript",
    --     "javascriptreact",
    --     "typescript",
    --     "typescriptreact",
    --     "json",
    --     "scss",
    --     "yaml",
    --     "lua",
    --     "analog",
    --     "ag",
    --   },
    --   cli_args = {
    --     "--single-quote",
    --     "--trailing-comma=es5",
    --     "--tab-width=2",
    --     "--semi=true",
    --     "--print-width=80"
    --   },
    -- },
    {
      "williamboman/mason.nvim",
      opts = function(_, opts)
        table.insert(opts.ensure_installed, "prettierd")
      end,
    },
    {
      "stevearc/conform.nvim",
      optional = true,
      opts = {
        formatters_by_ft = {
          ["javascript"] = { { "prettierd", "prettier" } },
          ["javascriptreact"] = { { "prettierd", "prettier" } },
          ["typescript"] = { { "prettierd", "prettier" } },
          ["typescriptreact"] = { { "prettierd", "prettier" } },
          ["vue"] = { { "prettierd", "prettier" } },
          ["css"] = { { "prettierd", "prettier" } },
          ["scss"] = { { "prettierd", "prettier" } },
          ["less"] = { { "prettierd", "prettier" } },
          ["html"] = { { "prettierd", "prettier" } },
          ["json"] = { { "prettierd", "prettier" } },
          ["jsonc"] = { { "prettierd", "prettier" } },
          ["yaml"] = { { "prettierd", "prettier" } },
          ["graphql"] = { { "prettierd", "prettier" } },
          ["handlebars"] = { { "prettierd", "prettier" } },
          ["analog"] = { { "prettierd", "prettier" } },
          ["ag"] = { { "prettierd", "prettier" } },
        },
      },
    },
  }
