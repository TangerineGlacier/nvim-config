local ls = require("luasnip")
local s = ls.s      -- snippet
local t = ls.text_node
local f = ls.function_node

-- A helper function to get the current filename without extension.
local function filename_no_ext()
  return vim.fn.expand("%:t:r")
end

-- Define the snippet for both javascriptreact and typescriptreact filetypes.
ls.add_snippets({ "javascriptreact", "typescriptreact" }, {
  s("rafce", {
    t("import React from 'react'"),
    t({ "", "" }),
    t("const "),
    f(filename_no_ext, {}),  -- use current file name for the component name
    t(" = () => {"),
    t({ "", "  return (" }),
    t({ "", "    <div>" }),
    f(filename_no_ext, {}),
    t("</div>"),
    t({ "", "  )" }),
    t({ "", "}" }),
    t({ "", "" }),
    t("export default "),
    f(filename_no_ext, {}),
  }),
})
