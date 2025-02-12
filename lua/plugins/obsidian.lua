require("obsidian").setup({
  workspaces = {
    {
      name = "personal",
      path = "~/Documents/ObsidianVault/Tangerine Vault",  -- update this to your vault path
    },
  },
  -- Override the default note id function
  note_id_func = function(title)
    if not title or title == "" then
      -- Fallback: if no title is provided, use a timestamp
      return vim.fn.strftime("%Y%m%d%H%M%S")
    end
    -- Convert title to a URL/filename friendly slug:
    local slug = title
      :gsub("%s+", "-")           -- replace spaces with dashes
      :gsub("[^%w%-]", "")        -- remove non-alphanumeric characters except dash
      :lower()                    -- convert to lowercase
    return slug
  end,
  completion = {
    nvim_cmp = true,  -- if you are using nvim-cmp for completion
  },
  mappings = {
    ["<leader>on"] = { action = "new", opts = { desc = "New Note" } },
    ["<leader>od"] = { action = "today", opts = { desc = "Open Daily Note" } },
  },
})
