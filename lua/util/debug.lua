-- ~/.config/nvim/lua/util/debug.lua
local debug = {}

function debug.dump(...)
  -- A more advanced dump, or simply use vim.inspect for now:
  print("[DEBUG]", vim.inspect({...}))
end

return debug
