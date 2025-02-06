if vim.loader then
	vim.loader.enable()
  end
  
  -- Attempt to require "util.debug" safely.
  local ok, debug_util = pcall(require, "util.debug")
  if not ok then
	-- Fallback implementation if the module isn't found.
	debug_util = {
	  dump = function(...)
		print("[DEBUG]", ...)
	  end,
	}

  end
  
  _G.dd = function(...)
	debug_util.dump(...)
  end
  vim.print = _G.dd
  
  require("config.lazy")
  