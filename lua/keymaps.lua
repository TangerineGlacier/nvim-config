-- CMD key shortcuts for text editing
vim.api.nvim_set_keymap("i", "jj", "<Esc>", {noremap=false})
-- Twilight
vim.api.nvim_set_keymap("n", "tw", ":Twilight<enter>", {noremap=false})
-- Buffers
vim.api.nvim_set_keymap("n", "tk", ":blast<enter>", {noremap=false})
vim.api.nvim_set_keymap("n", "tj", ":bfirst<enter>", {noremap=false})
vim.api.nvim_set_keymap("n", "th", ":bprev<enter>", {noremap=false})
vim.api.nvim_set_keymap("n", "tl", ":bnext<enter>", {noremap=false})
vim.api.nvim_set_keymap("n", "td", ":bdelete<enter>", {noremap=false})
-- Files
vim.api.nvim_set_keymap("n", "QQ", ":q!<enter>", {noremap=false})
vim.api.nvim_set_keymap("n", "WW", ":w!<enter>", {noremap=false})
vim.api.nvim_set_keymap("n", "E", "$", {noremap=false})
vim.api.nvim_set_keymap("n", "B", "^", {noremap=false})
vim.api.nvim_set_keymap("n", "TT", ":TransparentToggle<CR>", {noremap=true})
vim.api.nvim_set_keymap("n", "ss", ":noh<CR>", {noremap=true})

-- Clear search highlights with Escape
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { silent = true })

-- Splits
vim.api.nvim_set_keymap("n", "<C-W>,", ":vertical resize -10<CR>", {noremap=true})
vim.api.nvim_set_keymap("n", "<C-W>.", ":vertical resize +10<CR>", {noremap=true})
vim.keymap.set('n', '<space><space>', "<cmd>set nohlsearch<CR>")

-- Quicker close split
vim.keymap.set("n", "<leader>qq", ":q<CR>", {silent = true, noremap = true})

-- Terminal Split
local terminal_buf = nil
function ToggleTerminal()
  if terminal_buf and vim.api.nvim_buf_is_valid(terminal_buf) then
    vim.api.nvim_command("bd! " .. terminal_buf)
    terminal_buf = nil
  else
    vim.api.nvim_command("belowright split | terminal")
    terminal_buf = vim.api.nvim_get_current_buf()
  end
end

function NewTerminal()
  vim.api.nvim_command("belowright split | terminal")
  terminal_buf = vim.api.nvim_get_current_buf()
end

-- Terminal Keymaps
vim.api.nvim_set_keymap('n', '<C-`>', ':lua ToggleTerminal()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-`>', '<C-\\><C-n>:lua ToggleTerminal()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-S-`>', ':lua NewTerminal()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-S-`>', '<C-\\><C-n>:lua NewTerminal()<CR>', { noremap = true, silent = true })

-- Swap between files
vim.keymap.set("n", "<C-S-Right>", ":bnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-S-Left>", ":bprevious<CR>", { noremap = true, silent = true })

-- CMD Key Navigation
vim.api.nvim_set_keymap("n", "<D-Up>", "gg", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<D-Down>", "G", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<D-Left>", "^", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<D-Right>", "$", { noremap = true, silent = true })

-- CMD+A for Select All
vim.api.nvim_set_keymap("n", "<D-a>", "ggVG", { noremap = true, silent = true })

-- CMD+C to Copy
vim.api.nvim_set_keymap("v", "<D-c>", "\"+y", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<D-c>", "V\"+y", { noremap = true, silent = true })

-- CMD+X to Cut
vim.api.nvim_set_keymap("v", "<D-x>", "\"+d", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<D-x>", "V\"+d", { noremap = true, silent = true })

-- CMD+V to Paste
vim.api.nvim_set_keymap("n", "<D-v>", "\"+p", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<D-v>", "<C-r>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<D-v>", "\"+p", { noremap = true, silent = true })

-- Better defaults
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
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

-- File Explorer
vim.keymap.set("n", "<D-p>", ":Telescope find_files<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<D-S-P>", "<cmd>Telescope live_grep<CR>", { noremap = true, silent = true })


vim.keymap.set('n', '<leader>l', ':Lazy<CR>', { noremap = true, silent = true })
