return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")

    -- REQUIRED
    harpoon:setup()
    -- REQUIRED

    -- Basic telescope configuration
    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
          results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
      }):find()
    end

    -- Function to mark file and show notification
    local function mark_file(index)
      local list = harpoon:list()
      list:add()
      local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':t')
      vim.notify(string.format("Harpoon marked '%s' as %d", filename, index), vim.log.levels.INFO, {
        title = "Harpoon",
        timeout = 2000,
      })
    end

    -- Keymaps for marking files with Option+number (using M- for macOS)
    vim.keymap.set("n", "<leader>m1", function() mark_file(1) end, { desc = "Mark file as 1" })
    vim.keymap.set("n", "<leader>m2", function() mark_file(2) end, { desc = "Mark file as 2" })
    vim.keymap.set("n", "<leader>m3", function() mark_file(3) end, { desc = "Mark file as 3" })
    vim.keymap.set("n", "<leader>m4", function() mark_file(4) end, { desc = "Mark file as 4" })
    vim.keymap.set("n", "<leader>m5", function() mark_file(5) end, { desc = "Mark file as 5" })
    vim.keymap.set("n", "<leader>m6", function() mark_file(6) end, { desc = "Mark file as 6" })
    vim.keymap.set("n", "<leader>m7", function() mark_file(7) end, { desc = "Mark file as 7" })
    vim.keymap.set("n", "<leader>m8", function() mark_file(8) end, { desc = "Mark file as 8" })
    vim.keymap.set("n", "<leader>m9", function() mark_file(9) end, { desc = "Mark file as 9" })

    
    -- Keymaps for jumping to marked files (using leader)
    vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Go to harpoon file 1" })
    vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Go to harpoon file 2" })
    vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Go to harpoon file 3" })
    vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Go to harpoon file 4" })
    vim.keymap.set("n", "<leader>5", function() harpoon:list():select(5) end, { desc = "Go to harpoon file 5" })  
    vim.keymap.set("n", "<leader>6", function() harpoon:list():select(6) end, { desc = "Go to harpoon file 6" })
    vim.keymap.set("n", "<leader>7", function() harpoon:list():select(7) end, { desc = "Go to harpoon file 7" })
    vim.keymap.set("n", "<leader>8", function() harpoon:list():select(8) end, { desc = "Go to harpoon file 8" })
    vim.keymap.set("n", "<leader>9", function() harpoon:list():select(9) end, { desc = "Go to harpoon file 9" })
    -- Keep the menu toggle for reference
    vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Toggle harpoon quick menu" })
    vim.keymap.set("n", "<leader>p", function() toggle_telescope(harpoon:list()) end, { desc = "Open harpoon window" })

    -- Keymap to unmark the current file
    vim.keymap.set("n", "<leader>mu", function()
      local harpoon = require("harpoon")
      local list = harpoon:list()
      local current_file = vim.fn.expand("%:p")
      local current_real = vim.loop.fs_realpath(current_file)
      for i, item in ipairs(list.items) do
        if vim.loop.fs_realpath(item.value) == current_real then
          list:remove_at(i)
          vim.notify("Harpoon unmarked: " .. vim.fn.fnamemodify(current_file, ":t"), vim.log.levels.INFO, { title = "Harpoon" })
          return
        end
      end
      vim.notify("File not found in Harpoon list", vim.log.levels.WARN, { title = "Harpoon" })
    end, { desc = "Unmark current file from Harpoon" })

    -- Keymap to clear all harpoon files
    vim.keymap.set("n", "<leader>mp", function()
      local harpoon = require("harpoon")
      local list = harpoon:list()
      list:clear()
      vim.notify("Cleared all Harpoon marks", vim.log.levels.INFO, { title = "Harpoon" })
    end, { desc = "Clear all Harpoon marks" })
  end,
} 
