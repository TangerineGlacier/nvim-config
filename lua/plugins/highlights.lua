-- Custom highlight groups disabled - let themes handle syntax highlighting naturally
-- This prevents weird/bright colors from overriding your chosen theme

-- Remove ALL highlighting effects - only keep colors for syntax, no backgrounds or effects
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        -- Get all highlight groups and remove highlighting effects
        local function clear_highlight_effects(group_name)
            local hl = vim.api.nvim_get_hl(0, { name = group_name })
            if hl.fg then
                vim.api.nvim_set_hl(0, group_name, {
                    fg = hl.fg,
                    bg = "NONE",
                    bold = false,
                    italic = false,
                    underline = false,
                    undercurl = false,
                    strikethrough = false,
                    reverse = false,
                    standout = false,
                })
            end
        end
        
        -- Clear all syntax highlighting groups
        local syntax_groups = {
            -- Basic syntax groups
            "Statement", "Keyword", "Conditional", "Repeat", "Label", "Operator", 
            "Exception", "Include", "Define", "Macro", "PreCondit", "StorageClass", 
            "Structure", "Typedef", "Function", "Identifier", "Constant", "String", 
            "Character", "Number", "Boolean", "Float", "Type", "Special", "SpecialChar",
            "Tag", "Delimiter", "SpecialComment", "Debug", "Underlined", "Error", "Todo",
            "Comment", "PreProc", "NonText", "EndOfBuffer", "LineNr", "CursorLine",
            "CursorLineNr", "SignColumn", "StatusLine", "StatusLineNC", "VertSplit",
            "WinSeparator", "ModeMsg", "MoreMsg", "Question", "WarningMsg", "ErrorMsg", 
            "IncSearch", "Search", "Substitute", "MatchParen", "SpellBad", "SpellCap", 
            "SpellRare", "SpellLocal",
            -- LSP diagnostic groups
            "DiagnosticError", "DiagnosticWarn", "DiagnosticInfo", "DiagnosticHint",
            "DiagnosticOk", "DiagnosticSignError", "DiagnosticSignWarn", "DiagnosticSignInfo",
            "DiagnosticSignHint", "DiagnosticSignOk", "DiagnosticVirtualTextError",
            "DiagnosticVirtualTextWarn", "DiagnosticVirtualTextInfo", "DiagnosticVirtualTextHint",
            "DiagnosticVirtualTextOk", "DiagnosticUnderlineError", "DiagnosticUnderlineWarn",
            "DiagnosticUnderlineInfo", "DiagnosticUnderlineHint", "DiagnosticUnderlineOk",
            "DiagnosticFloatingError", "DiagnosticFloatingWarn", "DiagnosticFloatingInfo",
            "DiagnosticFloatingHint", "DiagnosticFloatingOk", "DiagnosticSignOther",
            "DiagnosticVirtualTextOther", "DiagnosticUnderlineOther", "DiagnosticFloatingOther",
            -- Treesitter groups
            "TSAnnotation", "TSAttribute", "TSBoolean", "TSCharacter", "TSComment", "TSConditional",
            "TSConstant", "TSConstBuiltin", "TSConstMacro", "TSConstructor", "TSError", "TSException",
            "TSField", "TSFloat", "TSFunction", "TSFuncBuiltin", "TSFuncMacro", "TSInclude",
            "TSKeyword", "TSKeywordFunction", "TSKeywordOperator", "TSLabel", "TSMethod",
            "TSNamespace", "TSNone", "TSNumber", "TSOperator", "TSParameter", "TSParameterReference",
            "TSProperty", "TSPunctDelimiter", "TSPunctBracket", "TSPunctSpecial", "TSRepeat",
            "TSString", "TSStringEscape", "TSStringRegex", "TSStringSpecial", "TSSymbol",
            "TSTag", "TSTagDelimiter", "TSText", "TSTitle", "TSType", "TSTypeBuiltin",
            "TSVariable", "TSVariableBuiltin", "TSTagAttribute", "TSURI", "TSMath",
            "TSEnvironment", "TSEnvironmentName", "TSNote", "TSWarning", "TSDanger",
            -- CMP groups
            "CmpItemAbbr", "CmpItemAbbrDeprecated", "CmpItemAbbrMatch", "CmpItemAbbrMatchFuzzy",
            "CmpItemKind", "CmpItemMenu", "CmpItemKindSnippet", "CmpItemKindText",
            "CmpItemKindMethod", "CmpItemKindFunction", "CmpItemKindConstructor", "CmpItemKindField",
            "CmpItemKindVariable", "CmpItemKindClass", "CmpItemKindInterface", "CmpItemKindModule",
            "CmpItemKindProperty", "CmpItemKindUnit", "CmpItemKindValue", "CmpItemKindEnum",
            "CmpItemKindKeyword", "CmpItemKindSnippet", "CmpItemKindColor", "CmpItemKindFile",
            "CmpItemKindReference", "CmpItemKindFolder", "CmpItemKindEnumMember", "CmpItemKindConstant",
            "CmpItemKindStruct", "CmpItemKindEvent", "CmpItemKindOperator", "CmpItemKindTypeParameter",
            -- Telescope groups
            "TelescopeNormal", "TelescopePreviewNormal", "TelescopePromptNormal", "TelescopeResultsNormal",
            "TelescopeSelection", "TelescopeSelectionCaret", "TelescopeMultiSelection", "TelescopeMultiIcon",
            "TelescopeTitle", "TelescopePromptTitle", "TelescopePreviewTitle", "TelescopeResultsTitle",
            "TelescopeBorder", "TelescopePromptBorder", "TelescopePreviewBorder", "TelescopeResultsBorder",
            "TelescopeMatching", "TelescopePromptPrefix", "TelescopePreviewLine", "TelescopePreviewMatch",
            "TelescopePromptCounter", "TelescopeResultsDiffAdd", "TelescopeResultsDiffChange", "TelescopeResultsDiffDelete",
            -- Other common groups
            "NormalFloat", "FloatBorder", "FloatTitle", "FloatFooter", "Pmenu", "PmenuSel",
            "PmenuSbar", "PmenuThumb", "TabLine", "TabLineFill", "TabLineSel", "QuickFixLine",
            "ColorColumn", "Conceal", "Cursor", "lCursor", "CursorIM", "TermCursor", "TermCursorNC",
            "DiffAdd", "DiffChange", "DiffDelete", "DiffText", "Directory", "EndOfBuffer",
            "ErrorMsg", "Folded", "FoldColumn", "SignColumn", "Ignore", "LineNrAbove",
            "LineNrBelow", "MsgArea", "MsgSeparator", "MoreMsg", "NonText", "NormalNC",
            "Question", "QuickFixLine", "Search", "SpecialKey", "SpellBad", "SpellCap",
            "SpellLocal", "SpellRare", "StatusLine", "StatusLineNC", "TabLine", "TabLineFill",
            "TabLineSel", "Title", "Visual", "VisualNOS", "WarningMsg", "Whitespace",
            "WildMenu", "WinBar", "WinBarNC", "WinSeparator"
        }
        
        for _, group in ipairs(syntax_groups) do
            clear_highlight_effects(group)
        end
        
        -- Also clear any groups that might have been created by plugins
        local all_groups = vim.fn.getcompletion("", "highlight")
        for _, group in ipairs(all_groups) do
            if not vim.tbl_contains({"Visual", "VisualNOS", "IncSearch", "Search", "Substitute"}, group) then
                clear_highlight_effects(group)
            end
        end
    end,
})

-- Also run immediately to apply to current colorscheme
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        -- Trigger the colorscheme callback
        vim.cmd("doautocmd ColorScheme")
    end,
})

-- Uncomment the section below if you want custom HTML highlights back:
--[[
local function setup_html_highlights()
    local function highlight_exists(name)
        return vim.fn.hlexists(name) == 1
    end
    
    if not highlight_exists('htmlTag') then
        vim.api.nvim_set_hl(0, 'htmlTag', { fg = '#F7768E' })
    end
    if not highlight_exists('htmlTagName') then
        vim.api.nvim_set_hl(0, 'htmlTagName', { fg = '#F7768E' })
    end
    if not highlight_exists('htmlArg') then
        vim.api.nvim_set_hl(0, 'htmlArg', { fg = '#BB9AF7', italic = true })
    end
    if not highlight_exists('htmlString') then
        vim.api.nvim_set_hl(0, 'htmlString', { fg = '#9ECE6A' })
    end
    if not highlight_exists('htmlSpecialTagName') then
        vim.api.nvim_set_hl(0, 'htmlSpecialTagName', { fg = '#F7768E' })
    end
    if not highlight_exists('htmlEndTag') then
        vim.api.nvim_set_hl(0, 'htmlEndTag', { fg = '#F7768E' })
    end
end

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = setup_html_highlights,
})

setup_html_highlights()
--]] 