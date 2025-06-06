-- File: ~/.config/nvim/lua/nvim-tangerine.lua
-- nvim-tangerine: A simple Neovim plugin for inline code auto‐completion using Ollama.
--
-- This version now supports multi‐line suggestions.

local M = {}

local timer = vim.loop.new_timer()

-- Flag to prevent immediate subsequent server calls after a completion is accepted.
M.ignore_autocomplete_request = false
-- Flag to control whether auto-completion requests are sent.
M.auto_enabled = true
-- Hold the current suggestion ghost (if any). It now stores either:
--    { extmark_id = number, missing = string }
-- or { extmark_ids = {number,...}, missing = string } for multi‐line suggestions.
M.current_suggestion = nil
-- Create (or get) our namespace for extmarks/virtual text.
local ns = vim.api.nvim_create_namespace("nvim-tangerine")

--------------------------------------------------------------------------------
-- Compute the missing text by finding the longest common prefix between what
-- is already typed (before the cursor) and the full suggested line.
--------------------------------------------------------------------------------
local function compute_missing_text(suggestion)
  local line = vim.api.nvim_get_current_line()
  local col = vim.fn.col('.') -- current cursor column (1-indexed)
  local typed_before = line:sub(1, col - 1)
  local common = ""
  local max = math.min(#typed_before, #suggestion)
  for i = 1, max do
    local sub_typed = typed_before:sub(1, i)
    local sub_suggest = suggestion:sub(1, i)
    if sub_typed == sub_suggest then
      common = sub_typed
    else
      break
    end
  end
  local missing = suggestion:sub(#common + 1)
  return missing, col
end

--------------------------------------------------------------------------------
-- Request a code completion from the Ollama endpoint.
-- Optimized to send a smaller context window for faster completions.
--------------------------------------------------------------------------------
local function request_completion()
  local buf = vim.api.nvim_get_current_buf()
  local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
  local cursor = vim.api.nvim_win_get_cursor(0)
  local current_row = cursor[1]
  -- Get a window of context: 50 lines before and 10 lines after the current line.
  local start_line = math.max(current_row - 50, 0)
  local end_line = current_row + 10
  local lines = vim.api.nvim_buf_get_lines(buf, start_line, end_line, false)
  local context = table.concat(lines, "\n")

  local prompt = string.format(
    "Filetype: %s\nCursor: %d:%d\n\nComplete the code by appending only the missing text that maintains syntactic correctness. " ..
    "Do not include any commentary or extra formatting. Use the following code context for reference:\n\n%s",
    filetype, cursor[1], cursor[2], context
  )

  local payload = vim.fn.json_encode({
    model = "deepseek-coder:6.7b",
    prompt = prompt,
    stream = false,
  })

  local cmd = {
    "curl", "-s", "-X", "POST",
    "http://localhost:11434/api/generate",
    "-H", "Content-Type: application/json",
    "-d", payload,
  }

  local output_lines = {}

  vim.fn.jobstart(cmd, {
    on_stdout = function(_, data, _)
      if data and not vim.tbl_isempty(data) then
        for _, line in ipairs(data) do
          if line and line ~= "" then
            table.insert(output_lines, line)
          end
        end
      end
    end,
    on_stderr = function(_, data, _)
      if data and not vim.tbl_isempty(data) then
        vim.schedule(function()
          -- Uncomment for debugging:
          -- print("nvim-tangerine error (stderr): " .. vim.inspect(data))
        end)
      end
    end,
    on_exit = function(_, exit_code, _)
      vim.schedule(function()
        if exit_code ~= 0 then return end
        vim.notify("tangerine activated...", vim.log.levels.INFO)

        local raw_response = table.concat(output_lines, "\n")
        raw_response = raw_response:gsub("^%s+", ""):gsub("%s+$", "")
        if raw_response == "" then return end

        local suggestion = raw_response
        if raw_response:sub(1, 1) == "{" then
          local ok, decoded = pcall(vim.fn.json_decode, raw_response)
          if ok and type(decoded) == "table" and decoded.response and decoded.response ~= "" then
            suggestion = decoded.response
          else
            suggestion = raw_response
          end
        end

        suggestion = suggestion:gsub("^%d+%.%s*", "")
        suggestion = suggestion:gsub("^%s+", ""):gsub("%s+$", "")
        if suggestion == "" then return end

        -- Clear any existing suggestion ghost.
        if M.current_suggestion then
          if M.current_suggestion.extmark_ids then
            for _, id in ipairs(M.current_suggestion.extmark_ids) do
              vim.api.nvim_buf_del_extmark(0, ns, id)
            end
          elseif M.current_suggestion.extmark_id then
            vim.api.nvim_buf_del_extmark(0, ns, M.current_suggestion.extmark_id)
          end
          M.current_suggestion = nil
        end

        local cursor = vim.api.nvim_win_get_cursor(0)
        local row = cursor[1] - 1
        local col = cursor[2]
        local suggestion_lines = vim.split(suggestion, "\n", { plain = true })

        -- Display inline suggestion at end-of-line.
        local inline_suggestion = table.concat(suggestion_lines, "")
        local extmark_id = vim.api.nvim_buf_set_extmark(0, ns, row, col, {
          virt_text = { { inline_suggestion, "Comment" } },
          virt_text_pos = "eol",
          hl_mode = "combine",
        })
        M.current_suggestion = { extmark_id = extmark_id, missing = suggestion }
      end)
    end,
  })
end

--------------------------------------------------------------------------------
-- on_text_change is triggered on TextChangedI.
--------------------------------------------------------------------------------
local function on_text_change()
  local buf = vim.api.nvim_get_current_buf()
  local disabled_extensions = { sql = true, md = true }
  local file_name = vim.api.nvim_buf_get_name(buf)
  local ext = file_name:match("^.+%.(%w+)$")
  if ext and disabled_extensions[ext] then return end
  if vim.api.nvim_buf_get_option(buf, "buftype") ~= "" then return end

  local disallowed_filetypes = {
    TelescopePrompt = true, NvimTree = true, dashboard = true,
    fzf = true, ["neo-tree"] = true, quickfix = true,
  }
  local ft = vim.api.nvim_buf_get_option(buf, "filetype")
  if disallowed_filetypes[ft] then return end
  if M.ignore_autocomplete_request or not M.auto_enabled then return end

  if M.current_suggestion then
    if M.current_suggestion.extmark_ids then
      for _, id in ipairs(M.current_suggestion.extmark_ids) do
        vim.api.nvim_buf_del_extmark(0, ns, id)
      end
    elseif M.current_suggestion.extmark_id then
      vim.api.nvim_buf_del_extmark(0, ns, M.current_suggestion.extmark_id)
    end
    M.current_suggestion = nil
  end

  timer:stop()
  timer:start(4000, 0, vim.schedule_wrap(function() request_completion() end))
end

--------------------------------------------------------------------------------
-- Accept the current ghost suggestion and insert its text.
--------------------------------------------------------------------------------
function M.accept_suggestion()
  if not M.current_suggestion then
    return vim.api.nvim_replace_termcodes("<C-S-Tab>", true, true, true)
  end

  local suggestion = M.current_suggestion.missing
  -- Remove ghost text extmarks
  if M.current_suggestion.extmark_ids then
    for _, id in ipairs(M.current_suggestion.extmark_ids) do
      vim.api.nvim_buf_del_extmark(0, ns, id)
    end
  elseif M.current_suggestion.extmark_id then
    vim.api.nvim_buf_del_extmark(0, ns, M.current_suggestion.extmark_id)
  end
  M.current_suggestion = nil

  vim.schedule(function()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local suggestion_lines = vim.split(suggestion, "\n", { plain = true })
    local current_line = vim.api.nvim_get_current_line()
    local before_cursor = current_line:sub(1, col)
    local after_cursor = current_line:sub(col + 1)

    -- Define closing delimiters that we want to handle.
    local closing_chars = { [")"] = true, ['"'] = true, ["'"] = true, ["}"] = true, ["]"] = true }
    local next_char = after_cursor:sub(1, 1)

    -- If there's a closing delimiter immediately after the cursor
    -- and the suggestion ends with the same character, remove that trailing delimiter.
    if closing_chars[next_char] and suggestion:sub(-1) == next_char then
      suggestion = suggestion:sub(1, -2)
      suggestion_lines = vim.split(suggestion, "\n", { plain = true })
    end

    if #suggestion_lines == 1 then
      local new_line = before_cursor .. suggestion_lines[1] .. after_cursor
      vim.api.nvim_set_current_line(new_line)
      vim.api.nvim_win_set_cursor(0, { row, col + #suggestion_lines[1] })
    else
      -- Insert the first line into the current line.
      local first_line = before_cursor .. suggestion_lines[1]
      vim.api.nvim_set_current_line(first_line)
      -- Insert the remaining lines below.
      local new_lines = {}
      for i = 2, #suggestion_lines do
        table.insert(new_lines, suggestion_lines[i])
      end
      vim.api.nvim_buf_set_lines(0, row, row, false, new_lines)
      local new_cursor_row = row + #suggestion_lines - 1
      local new_cursor_line = vim.api.nvim_buf_get_lines(0, new_cursor_row, new_cursor_row + 1, false)[1]
      vim.api.nvim_win_set_cursor(0, { new_cursor_row + 1, #new_cursor_line })
    end
  end)

  M.ignore_autocomplete_request = true
  vim.defer_fn(function() M.ignore_autocomplete_request = false end, 1000)
  return ""
end

--------------------------------------------------------------------------------
-- Ctrl+Shift+Tab mapping: accept suggestion if available.
--------------------------------------------------------------------------------
function M.ctrl_shift_tab_complete()
  if M.current_suggestion then
    return M.accept_suggestion()
  else
    return vim.api.nvim_replace_termcodes("<C-S-Tab>", true, true, true)
  end
end

--------------------------------------------------------------------------------
-- Enable auto-completion.
--------------------------------------------------------------------------------
function M.auto_on()
  M.auto_enabled = true
  vim.notify("Tangerine auto completion enabled", vim.log.levels.INFO)
end

--------------------------------------------------------------------------------
-- Disable auto-completion.
--------------------------------------------------------------------------------
function M.auto_off()
  M.auto_enabled = false
  vim.notify("Tangerine auto completion disabled", vim.log.levels.INFO)
end

--------------------------------------------------------------------------------
-- Clear any existing ghost suggestion.
--------------------------------------------------------------------------------
function M.clear_suggestion()
  if M.current_suggestion then
    if M.current_suggestion.extmark_ids then
      for _, id in ipairs(M.current_suggestion.extmark_ids) do
        vim.api.nvim_buf_del_extmark(0, ns, id)
      end
    elseif M.current_suggestion.extmark_id then
      vim.api.nvim_buf_del_extmark(0, ns, M.current_suggestion.extmark_id)
    end
    M.current_suggestion = nil
  end
end

--------------------------------------------------------------------------------
-- Helper: Open a modal floating window with header and ESC [x] to close.
--------------------------------------------------------------------------------
local function open_floating_window(content)
  local width = math.floor(vim.o.columns * 0.5)
  local height = math.floor(vim.o.lines * 0.5)
  local header = "Tangerine code summary of this file"
  local close_text = "[x] esc"
  local header_len = #header
  local close_len = #close_text
  local total_padding = width - 4 - header_len - close_len
  if total_padding < 1 then total_padding = 1 end
  local spaces = string.rep(" ", total_padding)
  local header_line = "  " .. header .. spaces .. close_text

  local lines = { header_line, "" }
  for _, line in ipairs(vim.split(content, "\n")) do
    table.insert(lines, "  " .. line)
  end
  table.insert(lines, "")

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  local opts = {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
  }
  vim.api.nvim_open_win(buf, true, opts)
  vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>close<CR>", { noremap = true, silent = true })
end

--------------------------------------------------------------------------------
-- Describe the current file.
--------------------------------------------------------------------------------
function M.describe_file()
  local buf = vim.api.nvim_get_current_buf()
  local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local context = table.concat(lines, "\n")

  vim.notify("Tangerine is analysing....", vim.log.levels.INFO)

  local prompt = string.format(
    "You are a code analysis assistant. Analyze the following %s file and provide a concise, clear description of its functionality, purpose, and notable features. " ..
    "Do not include any code snippets, commentary, or extraneous text; provide only the description.\n\n%s",
    filetype, context
  )

  local payload = vim.fn.json_encode({
    model = "deepseek-coder:6.7b",
    prompt = prompt,
    stream = false,
  })

  local cmd = { "curl", "-s", "-X", "POST",
                "http://localhost:11434/api/generate",
                "-H", "Content-Type: application/json",
                "-d", payload }
  local output_lines = {}

  vim.fn.jobstart(cmd, {
    on_stdout = function(_, data, _)
      if data and not vim.tbl_isempty(data) then
        for _, line in ipairs(data) do
          if line and line ~= "" then table.insert(output_lines, line) end
        end
      end
    end,
    on_stderr = function(_, data, _)
      if data and not vim.tbl_isempty(data) then
        vim.schedule(function() end)
      end
    end,
    on_exit = function(_, exit_code, _)
      vim.schedule(function()
        if exit_code ~= 0 then
          vim.notify("Error generating file description", vim.log.levels.ERROR)
          return
        end
        local raw_response = table.concat(output_lines, "\n")
        raw_response = raw_response:gsub("^%s+", ""):gsub("%s+$", "")
        if raw_response == "" then
          vim.notify("No description received", vim.log.levels.WARN)
          return
        end
        local ok, decoded = pcall(vim.fn.json_decode, raw_response)
        local description = raw_response
        if ok and type(decoded) == "table" and decoded.response and decoded.response ~= "" then
          description = decoded.response
        else
          local json_text = raw_response:match("^(%b{})")
          if json_text then
            ok, decoded = pcall(vim.fn.json_decode, json_text)
            if ok and type(decoded) == "table" and decoded.response and decoded.response ~= "" then
              description = decoded.response
            end
          end
        end
        description = description:gsub("^%d+%.%s*", ""):gsub("^%s+", ""):gsub("%s+$", "")
        local cleaned_lines = {}
        for _, line in ipairs(vim.split(description, "\n")) do
          if not line:match("^%s*[%d,%s]+%s*$") then table.insert(cleaned_lines, line) end
        end
        description = table.concat(cleaned_lines, "\n")
        if description == "" then return end

        open_floating_window(description)
        vim.notify("File description generated", vim.log.levels.INFO)
      end)
    end,
  })
end

--------------------------------------------------------------------------------
-- Generate a project context using Tree-sitter and Ollama.
--------------------------------------------------------------------------------
function M.generate_project_context()
  -- Helper: read file contents.
  local function read_file(path)
    local f = io.open(path, "r")
    if not f then return nil end
    local content = f:read("*a")
    f:close()
    return content
  end

  -- Helper: recursively scan directory for files, skipping unwanted directories/files.
  local function scan_dir(directory)
    local result = {}
    local scandir = vim.loop.fs_scandir(directory)
    if scandir then
      while true do
        local name, type = vim.loop.fs_scandir_next(scandir)
        if not name then break end
        if name:sub(1,1) == "." or name == "node_modules" or name == "modules" or name == "packages" or name == "pips" or name == "venv" or name == ".git" or name == ".hg" or name == ".svn" then
          goto continue
        end
        local full_path = directory .. "/" .. name
        if type == "file" then
          table.insert(result, full_path)
        elseif type == "directory" then
          local subfiles = scan_dir(full_path)
          for _, sub in ipairs(subfiles) do table.insert(result, sub) end
        end
        ::continue::
      end
    end
    return result
  end

  local git_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
  local project_root = (#git_root > 0 and git_root) or vim.fn.getcwd()

  local files = scan_dir(project_root)
  if #files == 0 then
    vim.notify("No files found in project root: " .. project_root, vim.log.levels.WARN)
    return
  end

  if #files > 2000 then
    files = { unpack(files, 1, 200) }
  end

  local ext_to_lang = {
    lua = "lua", py = "python", js = "javascript", jsx = "javascript",
    ts = "typescript", tsx = "typescript",
  }

  local language_queries = {
    lua = [[
      (function_declaration name: (identifier) @name)
      (local_function name: (identifier) @name)
    ]],
    python = [[
      (function_definition name: (identifier) @name)
      (class_definition name: (identifier) @name)
    ]],
    javascript = [[
      (function_declaration name: (identifier) @name)
      (class_declaration name: (identifier) @name)
    ]],
    typescript = [[
      (function_declaration name: (identifier) @name)
      (class_declaration name: (identifier) @name)
    ]],
  }

  local file_summaries = {}
  local total = #files
  local processed = 0
  local progress_notif = nil

  for _, file in ipairs(files) do
    processed = processed + 1
    if processed % 5 == 0 or processed == total then
      progress_notif = vim.notify(string.format("Analyzing file %d/%d", processed, total), vim.log.levels.INFO, { replace = progress_notif })
    end

    local ext = file:match("^.+%.([^.]+)$")
    if ext then ext = ext:lower() end
    local lang = ext_to_lang[ext]
    if lang and language_queries[lang] then
      local content = read_file(file)
      if content and #content > 0 then
        local tmp_buf = vim.api.nvim_create_buf(false, true)
        local lines = vim.split(content, "\n")
        vim.api.nvim_buf_set_lines(tmp_buf, 0, -1, false, lines)
        local ok, parser = pcall(vim.treesitter.get_parser, tmp_buf, lang)
        if ok and parser then
          local tree = parser:parse()[1]
          local root = tree:root()
          local query_string = language_queries[lang]
          local query_ok, query = pcall(vim.treesitter.query.parse, lang, query_string)
          local defs = {}
          if query_ok and query then
            for _, node, _ in query:iter_captures(root, tmp_buf, 0, -1) do
              local name = vim.treesitter.get_node_text(node, tmp_buf)
              if name and #name > 0 then table.insert(defs, name) end
            end
          end
          local rel_path = file:gsub("^" .. vim.pesc(project_root) .. "/?", "")
          if #defs == 0 then defs = { "No definitions found" } end
          table.insert(file_summaries, string.format("%s (%s): %s", rel_path, lang, table.concat(defs, ", ")))
        end
        vim.api.nvim_buf_delete(tmp_buf, { force = true })
      end
    end
  end

  if #file_summaries == 0 then
    vim.notify("No files with supported languages found for summary.", vim.log.levels.WARN)
    return
  end

  vim.notify("Combining file summaries and generating project context...", vim.log.levels.INFO)

  local project_context = table.concat(file_summaries, "\n")
  local prompt = string.format(
    "You are a code analysis assistant. Given the following file summaries from a project:\n\n%s\n\n" ..
    "Please provide a concise overall summary of what this project does, its primary functionality, structure, and purpose. " ..
    "Do not include code samples or extraneous formatting.",
    project_context
  )

  local payload = vim.fn.json_encode({
    model = "deepseek-coder:6.7b",
    prompt = prompt,
    stream = false,
  })

  local cmd = { "curl", "-s", "-X", "POST",
                "http://localhost:11434/api/generate",
                "-H", "Content-Type: application/json",
                "-d", payload }
  local output_lines = {}

  vim.fn.jobstart(cmd, {
    on_stdout = function(_, data, _)
      if data and not vim.tbl_isempty(data) then
        for _, line in ipairs(data) do
          if line and line ~= "" then table.insert(output_lines, line) end
        end
      end
    end,
    on_stderr = function(_, data, _)
      if data and not vim.tbl_isempty(data) then
        vim.schedule(function() end)
      end
    end,
    on_exit = function(_, exit_code, _)
      vim.schedule(function()
        if exit_code ~= 0 then
          vim.notify("Error generating project context", vim.log.levels.ERROR)
          return
        end

        local raw_response = table.concat(output_lines, "\n")
        raw_response = raw_response:gsub("^%s+", ""):gsub("%s+$", "")
        if raw_response == "" then
          vim.notify("No project context received", vim.log.levels.WARN)
          return
        end

        local summary = raw_response
        if raw_response:sub(1, 1) == "{" then
          local ok, decoded = pcall(vim.fn.json_decode, raw_response)
          if ok and type(decoded) == "table" and decoded.response and decoded.response ~= "" then
            summary = decoded.response
          else
            summary = raw_response
          end
        end

        summary = summary:gsub("^%d+%.%s*", ""):gsub("^%s+", ""):gsub("%s+$", "")

        open_floating_window(summary)
        vim.notify("Project context generated", vim.log.levels.INFO)
      end)
    end,
  })
end

--------------------------------------------------------------------------------
-- Setup autocommands, key mappings, and user commands.
--------------------------------------------------------------------------------
function M.setup()
  vim.api.nvim_create_autocmd("TextChangedI", {
    pattern = "*",
    callback = on_text_change,
    desc = "Trigger nvim-tangerine code completion after 4 seconds of inactivity",
  })

  vim.api.nvim_create_autocmd("CompleteDone", {
    pattern = "*",
    callback = function()
      M.ignore_autocomplete_request = true
      vim.defer_fn(function() M.ignore_autocomplete_request = false end, 1000)
    end,
    desc = "Ignore server request immediately after completion",
  })

  vim.api.nvim_create_autocmd("CursorMovedI", {
    pattern = "*",
    callback = function()
      if M.current_suggestion then
        if M.current_suggestion.extmark_ids then
          for _, id in ipairs(M.current_suggestion.extmark_ids) do
            vim.api.nvim_buf_del_extmark(0, ns, id)
          end
        elseif M.current_suggestion.extmark_id then
          vim.api.nvim_buf_del_extmark(0, ns, M.current_suggestion.extmark_id)
        end
        M.current_suggestion = nil
      end
    end,
    desc = "Clear ghost suggestion when moving the cursor in Insert mode",
  })

  vim.keymap.set("i", "<C-S-Tab>", function() return M.ctrl_shift_tab_complete() end,
                   { expr = true, noremap = true, silent = true })

  vim.api.nvim_create_user_command("TangerineAuto", function(opts)
    local buf = vim.api.nvim_get_current_buf()
    local file_name = vim.api.nvim_buf_get_name(buf)
    local ext = file_name:match("^.+%.(%w+)$")
    local disabled_extensions = { sql = true, md = true }
    if ext and disabled_extensions[ext] and opts.args == "on" then
      vim.notify("Auto completion is disabled for ." .. ext .. " files", vim.log.levels.WARN)
      return
    end
    if opts.args == "on" then
      M.auto_on()
    elseif opts.args == "off" then
      M.auto_off()
    else
      vim.notify("Usage: :TangerineAuto [on|off]", vim.log.levels.ERROR)
    end
  end, { nargs = 1, complete = function() return {"on", "off"} end })

  vim.api.nvim_create_user_command("TangerineDescribeFile", function() M.describe_file() end, { nargs = 0 })

  vim.api.nvim_create_user_command("TangerineProjectContext", function() M.generate_project_context() end, { nargs = 0 })
end

return M
