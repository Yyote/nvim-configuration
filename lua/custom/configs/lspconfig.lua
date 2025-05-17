local config = require("plugins.configs.lspconfig")

local on_attach = config.on_attach
local capabilities = config.capabilities

local lspconfig = require("lspconfig")


-- root_dir = function(filename)
--   return util.root_pattern(unpack(root_files))(filename) or util.path.dirname(filename)
-- end,
lspconfig.clangd.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.signatureHelpProvider = false
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
}

lspconfig.pyright.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"python"},
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        autoImportCompletions = true,
        typeCheckingMode = "basic",

        diagnosticMode = "workspace",
        useLibraryCodeForTypes = false, 

        extraPaths = {
          "/opt/ros/humble/include",
        },
      },
    },
  }
})
