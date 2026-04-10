require("gitsigns").setup({
  -- Signs in the sign column (like your reference)
  signs = {
    add          = { text = "┃", show_count = false },
    change       = { text = "┃", show_count = false },
    delete       = { text = "_", show_count = false },
    topdelete    = { text = "‾", show_count = false },
    changedelete = { text = "~", show_count = false },
    untracked    = { text = "┆", show_count = false },
  },
  signs_staged = {
    add          = { text = "┃", show_count = false },
    change       = { text = "┃", show_count = false },
    delete       = { text = "_", show_count = false },
    topdelete    = { text = "‾", show_count = false },
    changedelete = { text = "~", show_count = false },
    untracked    = { text = "┆", show_count = false },
  },
  signs_staged_enable = true,
  signcolumn = true,
  numhl = false,
  linehl = false,
  word_diff = false,
  watch_gitdir = { follow_files = true },
  auto_attach = true,
  attach_to_untracked = false,
  current_line_blame = false,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "right_align", -- blame on the right side of the window
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
  sign_priority = 6,
  update_debounce = 100,
  max_file_length = 40000,
  preview_config = {
    border = "single",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
  on_attach = function(bufnr)
    local gs = require("gitsigns")
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation: next/prev hunk
    map("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gs.next_hunk()
      end
    end, { desc = "Next hunk" })
    map("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gs.prev_hunk()
      end
    end, { desc = "Prev hunk" })

    -- Stage / reset
    map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
    map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
    map("v", "<leader>hs", function()
      gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "Stage hunk" })
    map("v", "<leader>hr", function()
      gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "Reset hunk" })
    map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
    map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })

    -- Preview & blame
    map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
    map("n", "<leader>hb", function()
      gs.blame_line({ full = true })
      -- Move blame window to the right (gitsigns opens it on the left by default)
      vim.schedule(function()
        vim.cmd("wincmd L")
      end)
    end, { desc = "Blame line" })
    map("n", "<leader>tB", gs.toggle_current_line_blame, { desc = "Toggle line blame" })

    -- Diff
    map("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })
    map("n", "<leader>hD", function()
      gs.diffthis("~")
    end, { desc = "Diff this (~)" })

    -- Text object: select hunk
    map({ "o", "x" }, "ih", gs.select_hunk, { desc = "Select hunk" })
  end,
})

