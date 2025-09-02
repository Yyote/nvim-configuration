local plugins = {
  {
    "nvimtools/none-ls.nvim",
    ft = {"python"},
    opts = function()
      return require "custom.configs.null-ls"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "pyright",
        "pylint",
        "mypy",
        "ruff",
        "clangd",
        "shellcheck",
        "lemminx",
        "rust-analyzer",
        "cmake-language-server",
        "lua-language-server",
        "marksman",
        "gopls",
      },
    },
  },
  { "neovim/nvim-lspconfig", config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },
  {
    "nvim-lua/plenary.nvim",
--     opts = {},
  },
  {
    "nvim-pack/nvim-spectre",
    opts = {},
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    'tanvirtin/vgit.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons' },
    -- Lazy loading on 'VimEnter' event is necessary.
    event = 'VimEnter',
    config = function() require("vgit").setup() end,
  },
  {
    'dcampos/nvim-snippy',
    opts = {},
  },
  ---@module "neominimap.config.meta"
  {
    "Isrothy/neominimap.nvim",
    version = "v3.x.x",
    lazy = false, -- NOTE: NO NEED to Lazy load
    mark = {
      enabled = true,
      mode = "icon",
      priority = 10,
      key = "m",
      show_builtins = false,
    },
    -- Optional. You can alse set your own keybindings
    keys = {
      -- Global Minimap Controls
      { "<leader>nm", "<cmd>Neominimap Toggle<cr>", desc = "Toggle global minimap" },
      { "<leader>no", "<cmd>Neominimap Enable<cr>", desc = "Enable global minimap" },
      { "<leader>nc", "<cmd>Neominimap Disable<cr>", desc = "Disable global minimap" },
      { "<leader>nr", "<cmd>Neominimap Refresh<cr>", desc = "Refresh global minimap" },
  
      -- Window-Specific Minimap Controls
      { "<leader>nwt", "<cmd>Neominimap WinToggle<cr>", desc = "Toggle minimap for current window" },
      { "<leader>nwr", "<cmd>Neominimap WinRefresh<cr>", desc = "Refresh minimap for current window" },
      { "<leader>nwo", "<cmd>Neominimap WinEnable<cr>", desc = "Enable minimap for current window" },
      { "<leader>nwc", "<cmd>Neominimap WinDisable<cr>", desc = "Disable minimap for current window" },
  
      -- Tab-Specific Minimap Controls
      { "<leader>ntt", "<cmd>Neominimap TabToggle<cr>", desc = "Toggle minimap for current tab" },
      { "<leader>ntr", "<cmd>Neominimap TabRefresh<cr>", desc = "Refresh minimap for current tab" },
      { "<leader>nto", "<cmd>Neominimap TabEnable<cr>", desc = "Enable minimap for current tab" },
      { "<leader>ntc", "<cmd>Neominimap TabDisable<cr>", desc = "Disable minimap for current tab" },
  
      -- Buffer-Specific Minimap Controls
      { "<leader>nbt", "<cmd>Neominimap BufToggle<cr>", desc = "Toggle minimap for current buffer" },
      { "<leader>nbr", "<cmd>Neominimap BufRefresh<cr>", desc = "Refresh minimap for current buffer" },
      { "<leader>nbo", "<cmd>Neominimap BufEnable<cr>", desc = "Enable minimap for current buffer" },
      { "<leader>nbc", "<cmd>Neominimap BufDisable<cr>", desc = "Disable minimap for current buffer" },
  
      ---Focus Controls
      { "<leader>nf", "<cmd>Neominimap Focus<cr>", desc = "Focus on minimap" },
      { "<leader>nu", "<cmd>Neominimap Unfocus<cr>", desc = "Unfocus minimap" },
      { "<leader>ns", "<cmd>Neominimap ToggleFocus<cr>", desc = "Switch focus on minimap" },
    },
    init = function()
      -- The following options are recommended when layout == "float"
      vim.opt.wrap = false
      vim.opt.sidescrolloff = 36 -- Set a large value
  
      --- Put your configuration here
      ---@type Neominimap.UserConfig
      vim.g.neominimap = {
        auto_enable = false,
      }
    end,
  },
  {
    "Pocco81/HighStr.nvim",
  },
}

-- require("ibl").setup()


return plugins
