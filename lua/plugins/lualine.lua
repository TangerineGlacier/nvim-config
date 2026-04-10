-- Status line styled with user palette
-- Palette: #161617 #1B1B1D #2A2A2D #3E3E43 | #C9C7CD #9998A8 #C1C0D4 | #E29ECA #90B99F #F5A191 #EA83A5 #ACA1CF
-- Icons use Nerd Fonts (e.g. MesloLGS NF); codepoints: branch e0a0, file e70b, encoding f031, position f0ac
local lualine = require("lualine")

local icon = function(codepoint)
  return vim.fn.nr2char(codepoint)
end

local p = {
  -- Backgrounds (dark → lighter)
  bg      = "#1B1B1D",
  bg_hi   = "#2A2A2D",
  bg_hi2  = "#3E3E43",
  -- Foregrounds
  fg      = "#C9C7CD",
  fg_dim  = "#9998A8",
  fg_hi   = "#C1C0D4",
  -- Accents (from palette)
  mauve   = "#E29ECA",
  mint    = "#90B99F",
  coral   = "#F5A191",
  pink    = "#EA83A5",
  lavender = "#ACA1CF",
  sep     = "#57575F",
}

local function mode_text()
  local mode = vim.fn.mode()
  local names = {
    n = "NORMAL",
    i = "INSERT",
    v = "VISUAL",
    V = "V-LINE",
    ["\22"] = "V-BLOCK",
    c = "COMMAND",
    R = "REPLACE",
    Rv = "V-REPLACE",
    t = "TERMINAL",
  }
  return names[mode] or string.upper(mode)
end

local function scroll_position()
  local top = vim.fn.line("w0")
  local bot = vim.fn.line("w$")
  local last = vim.fn.line("$")
  if top <= 1 then return "Top" end
  if bot >= last then return "Bot" end
  local pct = math.floor((top - 1) / math.max(1, last) * 100)
  return pct .. "%%"
end

local function hide_in_width(cond)
  return function() return vim.fn.winwidth(0) > (cond or 80) end
end

-- Mode (a) and location (z) use accent background so they stand out
local sl = {
  a = { fg = "#1B1B1D", bg = p.mauve, gui = "bold" },   -- NORMAL / INSERT etc
  b = { fg = p.fg, bg = p.bg },
  c = { fg = p.fg, bg = p.bg },
  x = { fg = p.fg_dim, bg = p.bg },
  y = { fg = p.fg_dim, bg = p.bg },
  z = { fg = "#1B1B1D", bg = p.mauve, gui = "bold" },   -- line:col e.g. 1:1
}

local lualine_config = {
  options = {
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    theme = {
      normal   = sl,
      insert   = sl,
      visual   = sl,
      replace  = sl,
      command  = sl,
      inactive = {
        a = { fg = p.fg_dim, bg = p.bg },
        b = { fg = p.fg_dim, bg = p.bg },
        c = { fg = p.fg_dim, bg = p.bg },
        x = { fg = p.fg_dim, bg = p.bg },
        y = { fg = p.fg_dim, bg = p.bg },
        z = { fg = p.fg_dim, bg = p.bg },
      },
    },
  },
  sections = {
    lualine_a = {
      { mode_text },
    },
    lualine_b = {
      {
        "branch",
        icon = icon(0xe0a0), -- 
        color = { fg = p.mint, bg = p.bg },
        cond = hide_in_width(60),
      },
      {
        "b:gitsigns_status_dict",
        fmt = function(d)
          if not d or not d.head then return nil end
          local add = d.added and ("+" .. d.added) or ""
          local ch = d.changed and (" ~" .. d.changed) or ""
          local del = d.removed and (" -" .. d.removed) or ""
          if add == "" and ch == "" and del == "" then return d.head:sub(1, 7) end
          return (d.head:sub(1, 7) or "") .. " | " .. add .. ch .. del
        end,
        color = function()
          return { fg = p.fg_dim, bg = p.bg }
        end,
        cond = hide_in_width(70),
      },
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = { error = icon(0xf06a), warn = icon(0xf071), info = icon(0xf05a), hint = icon(0xf0eb) },
        diagnostics_color = {
          error = { fg = p.coral },
          warn  = { fg = p.coral },
          info  = { fg = p.lavender },
          hint  = { fg = p.lavender },
        },
        cond = hide_in_width(70),
      },
      {
        "filename",
        path = 0,
        file_status = true,
        symbols = { modified = icon(0xf044), readonly = icon(0xf023), unnamed = icon(0xe5fe) },
        cond = function()
          return vim.bo.filetype ~= "neo-tree"
        end,
      },
    },
    lualine_c = {
      { function() return "%=" end },
    },
    lualine_x = {
      { "encoding", fmt = string.lower, icon = icon(0xf031) },
      { "fileformat", fmt = string.lower, icons_enabled = true },
      {
        "filetype",
        icons_enabled = true,
        cond = function()
          return vim.bo.filetype ~= "neo-tree"
        end,
      },
    },
    lualine_y = {},
    lualine_z = {
      { scroll_position, color = { fg = "#1B1B1D", bg = p.mauve }, icon = icon(0xf0ac) },
      -- Line:col only – swapped: dark bg, mauve text (inverted from mode block)
      { "location", color = { fg = p.mauve, bg = p.bg, gui = "bold" }, icon = icon(0xf0ac) },
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = { { "filename", path = 0 } },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { "location" },
  },
}

lualine.setup(lualine_config)

-- Re-apply lualine after colorscheme loads so file buffers get the same
-- mode/location colors as the dashboard (colorscheme overrides them otherwise).
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("LualineColors", { clear = true }),
  callback = function()
    vim.defer_fn(function()
      lualine.setup(lualine_config)
    end, 10)
  end,
})

-- Hide status line entirely when the file tree (neo-tree) is focused
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  group = vim.api.nvim_create_augroup("LualineHideInFileTree", { clear = true }),
  callback = function()
    if vim.bo.filetype == "neo-tree" then
      vim.opt.laststatus = 0
    else
      vim.opt.laststatus = 2
    end
  end,
})
