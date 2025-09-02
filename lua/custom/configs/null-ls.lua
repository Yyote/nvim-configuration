local null_ls = require('null-ls')

local opts = {
    sources = {
        null_ls.builtins.formatting.gofmt,
        null_ls.builtins.formatting.goimports_reviser,
        null_ls.builtins.formatting.golines,
    },
   -- sources = {
   --    null_ls.builtins.diagnostics.mypy,
   --    null_ls.builtins.diagnostics.ruff,
   -- }
}
return opts
