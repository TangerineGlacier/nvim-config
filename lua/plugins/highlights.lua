-- Custom highlight groups for HTML
vim.api.nvim_set_hl(0, 'htmlTag', { fg = '#F7768E' }) -- Red color for tags
vim.api.nvim_set_hl(0, 'htmlTagName', { fg = '#F7768E' }) -- Red color for tag names
vim.api.nvim_set_hl(0, 'htmlArg', { fg = '#BB9AF7', italic = true }) -- Purple color for attributes
vim.api.nvim_set_hl(0, 'htmlString', { fg = '#9ECE6A' }) -- Green color for attribute values
vim.api.nvim_set_hl(0, 'htmlSpecialTagName', { fg = '#F7768E' }) -- Red color for special tags
vim.api.nvim_set_hl(0, 'htmlEndTag', { fg = '#F7768E' }) -- Red color for closing tags 