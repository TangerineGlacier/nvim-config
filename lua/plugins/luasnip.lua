-- In your lazy setup (e.g. lua/plugins.lua)
return {
    -- LuaSnip
    {
      "L3MON4D3/LuaSnip",
      opts = {},
      event = "InsertEnter",
    },
    -- Optionally, nvim-cmp if you want completion
    {
      "hrsh7th/nvim-cmp",
      opts = function(_, opts)
        local luasnip = require("luasnip")
        opts.snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        }
        -- ... your cmp configuration
        return opts
      end,
    },
    -- (Other plugins…)
  }
  