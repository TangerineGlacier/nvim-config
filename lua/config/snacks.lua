-- ~/.config/nvim/lua/plugins.lua

return {
    -- Other plugins
    { 'folke/snacks.nvim', 
      config = function() 
        require('snacks').setup({
          -- Your custom configurations go here
          -- Example: 
          -- mapping = true,
          -- border = 'single',
        })
      end 
    },
  }
  