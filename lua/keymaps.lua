vim.api.nvim_set_keymap("i", "jj", "<Esc>", {noremap=false})
-- twilight
vim.api.nvim_set_keymap("n", "tw", ":Twilight<enter>", {noremap=false})
-- buffers
vim.api.nvim_set_keymap("n", "tk", ":blast<enter>", {noremap=false})
vim.api.nvim_set_keymap("n", "tj", ":bfirst<enter>", {noremap=false})
vim.api.nvim_set_keymap("n", "th", ":bprev<enter>", {noremap=false})
vim.api.nvim_set_keymap("n", "tl", ":bnext<enter>", {noremap=false})
vim.api.nvim_set_keymap("n", "td", ":bdelete<enter>", {noremap=false})
-- files
vim.api.nvim_set_keymap("n", "QQ", ":q!<enter>", {noremap=false})
vim.api.nvim_set_keymap("n", "WW", ":w!<enter>", {noremap=false})
vim.api.nvim_set_keymap("n", "E", "$", {noremap=false})
vim.api.nvim_set_keymap("n", "B", "^", {noremap=false})
vim.api.nvim_set_keymap("n", "TT", ":TransparentToggle<CR>", {noremap=true})
vim.api.nvim_set_keymap("n", "ss", ":noh<CR>", {noremap=true})
--
-- splits
--
vim.api.nvim_set_keymap("n", "<C-W>,", ":vertical resize -10<CR>", {noremap=true})
vim.api.nvim_set_keymap("n", "<C-W>.", ":vertical resize +10<CR>", {noremap=true})
vim.keymap.set('n', '<space><space>', "<cmd>set nohlsearch<CR>")
-- Quicker close split
vim.keymap.set("n", "<leader>qq", ":q<CR>",
  {silent = true, noremap = true}
)
-- split terminal 

local terminal_buf = nil  -- Store terminal buffer ID

function ToggleTerminal()
  if terminal_buf and vim.api.nvim_buf_is_valid(terminal_buf) then
    -- If terminal is open, close it
    vim.api.nvim_command("bd! " .. terminal_buf)
    terminal_buf = nil
  else
    -- If terminal is closed, reopen it
    vim.api.nvim_command("belowright split | terminal")
    terminal_buf = vim.api.nvim_get_current_buf()
  end
end

function NewTerminal()
  vim.api.nvim_command("belowright split | terminal")
  terminal_buf = vim.api.nvim_get_current_buf()  -- Update to last opened terminal
end

-- Keymaps
vim.api.nvim_set_keymap('n', '<C-`>', ':lua ToggleTerminal()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-`>', '<C-\\><C-n>:lua ToggleTerminal()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-S-`>', ':lua NewTerminal()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-S-`>', '<C-\\><C-n>:lua NewTerminal()<CR>', { noremap = true, silent = true })


-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Noice
vim.api.nvim_set_keymap("n", "<leader>nn", ":Noice dismiss<CR>", {noremap=true})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.keymap.set("n", "<leader>e", "<cmd>GoIfErr<cr>", { silent = true, noremap = true })
  end,
})
-- vim.keymap.set("n", "<D-p>", ":NvimTreeToggle<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<D-p>", ":Telescope find_files<CR>", { silent = true, noremap = true })

vim.keymap.set('n', '<leader>l', ':Lazy<CR>', { noremap = true, silent = true })
