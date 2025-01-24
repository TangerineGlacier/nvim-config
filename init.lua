local require = require
vim.opt.relativenumber = true
vim.opt.number = true
-- core module
require("core.option")
require("core.autocmd")
require("core.nvimmap")
require("core.plugmap")

-- Install lazy neovim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	require("core.bootstrap").lazy(lazypath)
else
	require("core.bootstrap").boot(lazypath)
end