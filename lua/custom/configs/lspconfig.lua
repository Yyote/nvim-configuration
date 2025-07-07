local config = require("plugins.configs.lspconfig")

local on_attach = config.on_attach
local capabilities = config.capabilities

local lspconfig = require("lspconfig")
local navic = require("nvim-navic")


-- root_dir = function(filename)
--   return util.root_pattern(unpack(root_files))(filename) or util.path.dirname(filename)
-- end,
lspconfig.clangd.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.signatureHelpProvider = false
    on_attach = function(client, bufnr)
      client.server_capabilities.signatureHelpProvider = false
      if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
      end
      if on_attach then on_attach(client, bufnr) end
    end
    opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts) -- Trigger code actions (quickfixes)
  end,
  capabilities = capabilities,
}

lspconfig.pyright.setup({
  on_attach = function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
      navic.attach(client, bufnr)
    end
    if on_attach then on_attach(client, bufnr) end
  end,
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


-- -- Function to show diagnostics in the quickfix list
-- local function show_diagnostics_in_quickfix()
--   vim.diagnostic.setqflist() -- Populate the quickfix list with all diagnostics
-- end

-- -- Keybindings for quickfix navigation and actions
-- vim.api.nvim_set_keymap('n', '<leader>q', ':lua vim.diagnostic.setqflist()<CR>', { noremap = true, silent = true }) -- Open quickfix list with diagnostics
-- vim.api.nvim_set_keymap('n', '<leader>qf', ':copen<CR>', { noremap = true, silent = true }) -- Open quickfix window
-- vim.api.nvim_set_keymap('n', '<leader>qn', ':cnext<CR>', { noremap = true, silent = true }) -- Go to next quickfix item
-- vim.api.nvim_set_keymap('n', '<leader>qp', ':cprev<CR>', { noremap = true, silent = true }) -- Go to previous quickfix item
-- vim.api.nvim_set_keymap('n', '<leader>qc', ':cclose<CR>', { noremap = true, silent = true }) -- Close quickfix window
