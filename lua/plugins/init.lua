-- All plugins have lazy=true by default,to load a plugin on startup just lazy=false
-- List of all default plugins & their definitions
local default_plugins = {

  "nvim-lua/plenary.nvim",

  {
    "NvChad/base46",
    branch = "v2.0",
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  {
    "NvChad/ui",
    branch = "v2.0",
    lazy = false,
  },

  {
    "zbirenbaum/nvterm",
    init = function()
      require("core.utils").load_mappings "nvterm"
    end,
    config = function(_, opts)
      require "base46.term"
      require("nvterm").setup(opts)
    end,
  },

  {
    "NvChad/nvim-colorizer.lua",
    event = "User FilePost",
    config = function(_, opts)
      require("colorizer").setup(opts)

      -- execute colorizer as soon as possible
      vim.defer_fn(function()
        require("colorizer").attach_to_buffer(0)
      end, 0)
    end,
  },

  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      return { override = require "nvchad.icons.devicons" }
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "devicons")
      require("nvim-web-devicons").setup(opts)
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    version = "3.5.4",
    event = "User FilePost",
    opts = function()
      return require("plugins.configs.others").blankline
    end,
    config = function(_, opts)
      require("core.utils").load_mappings "blankline"
      dofile(vim.g.base46_cache .. "blankline")
      require("indent_blankline").setup(opts)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = function()
      return require "plugins.configs.treesitter"
    end,
    -- config = function(_, opts)
    config = function()
      dofile(vim.g.base46_cache .. "syntax")
      require("nvim-treesitter.configs").setup(require("custom.configs.nvim-treesitter"))
    end,
  },

  -- git stuff
  {
    "lewis6991/gitsigns.nvim",
    event = "User FilePost",
    opts = function()
      return require("plugins.configs.others").gitsigns
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "git")
      require("gitsigns").setup(opts)
    end,
  },

  -- lsp stuff
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    opts = function()
      return require "plugins.configs.mason"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "mason")
      require("mason").setup(opts)

      -- custom nvchad cmd to install all mason binaries listed
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        if opts.ensure_installed and #opts.ensure_installed > 0 then
          vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
        end
      end, {})

      vim.g.mason_binaries_list = opts.ensure_installed
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    config = function()
      require "plugins.configs.lspconfig"
    end,
  },

  -- load luasnips + cmp related in insert mode only
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("plugins.configs.others").luasnip(opts)
        end,
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
    },
    opts = function()
      return require "plugins.configs.cmp"
    end,
    config = function(_, opts)
      require("cmp").setup(opts)
    end,
  },

  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "Comment toggle current line" },
      { "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
      { "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
      { "gbc", mode = "n", desc = "Comment toggle current block" },
      { "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
      { "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
    },
    init = function()
      require("core.utils").load_mappings "comment"
    end,
    config = function(_, opts)
      require("Comment").setup(opts)
    end,
  },

  -- file managing , picker etc
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    init = function()
      require("core.utils").load_mappings "nvimtree"
    end,
    opts = function()
      return require "plugins.configs.nvimtree"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "nvimtree")
      require("nvim-tree").setup(opts)
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    init = function()
      require("core.utils").load_mappings "telescope"
    end,
    opts = function()
      return require "plugins.configs.telescope"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "telescope")
      local telescope = require "telescope"
      telescope.setup(opts)

      -- load extensions
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
  },

  -- Only load whichkey after all the gui
  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    init = function()
      require("core.utils").load_mappings "whichkey"
    end,
    cmd = "WhichKey",
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "whichkey")
      require("which-key").setup(opts)
    end,
  },
  {
    "ludovicchabant/vim-gutentags",            -- plugin repository[1]
    event = { "BufReadPost", "BufNewFile" },   -- lazy-load when a file opens
    init = function()
      -- where tag files are written (optional but keeps project roots clean)
      vim.g.gutentags_cache_dir = vim.fn.stdpath("cache") .. "/tags"
      -- recognised project roots in addition to .git/.hg (example)
      vim.g.gutentags_project_root = { ".git", "Makefile", "package.json" }
    end,
  },
  {
    "SmiteshP/nvim-navic",
    dependencies = "neovim/nvim-lspconfig",
    opts = {},
  },
}

local config = require("core.utils").load_config()

if #config.plugins > 0 then
  table.insert(default_plugins, { import = config.plugins })
end

require("lazy").setup(default_plugins, config.lazy_nvim)
-- require("ibl").setup()
local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}

local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)



require("ibl").setup { indent = { highlight = highlight } }
-- require("nvim-rg").setup()

vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"

require("trouble").setup()

require("nvim-navic").setup({
      highlight = true,
})

vim.api.nvim_set_hl(0, "NavicIconsFile",          { fg = "#ffffff", bg = "#1e222a" })
vim.api.nvim_set_hl(0, "NavicIconsModule",        { fg = "#ffb86c", bg = "#1e222a" })
vim.api.nvim_set_hl(0, "NavicIconsNamespace",     { fg = "#8be9fd", bg = "#1e222a" })
vim.api.nvim_set_hl(0, "NavicIconsPackage",       { fg = "#bd93f9", bg = "#1e222a" })
vim.api.nvim_set_hl(0, "NavicIconsClass",         { fg = "#61afef", bg = "#1e222a" })
vim.api.nvim_set_hl(0, "NavicIconsMethod",        { fg = "#98c379", bg = "#1e222a" })
vim.api.nvim_set_hl(0, "NavicIconsProperty",      { fg = "#e5c07b", bg = "#1e222a" })
vim.api.nvim_set_hl(0, "NavicIconsField",         { fg = "#e06c75", bg = "#1e222a" })
vim.api.nvim_set_hl(0, "NavicIconsConstructor",   { fg = "#d19a66", bg = "#1e222a" })
vim.api.nvim_set_hl(0, "NavicIconsEnum",          { fg = "#56b6c2", bg = "#1e222a" })
vim.api.nvim_set_hl(0, "NavicIconsInterface",     { fg = "#61afef", bg = "#1e222a" })
vim.api.nvim_set_hl(0, "NavicIconsFunction",      { fg = "#c678dd", bg = "#1e222a" })
vim.api.nvim_set_hl(0, "NavicIconsVariable",      { fg = "#e06c75", bg = "#1e222a" })
vim.api.nvim_set_hl(0, "NavicIconsConstant",      { fg = "#ffb86c", bg = "#1e222a" })
vim.api.nvim_set_hl(0, "NavicIconsString",        { fg = "#98c379", bg = "#1e222a" })
vim.api.nvim_set_hl(0, "NavicIconsNumber",        { fg = "#d19a66", bg = "#1e222a" })
vim.api.nvim_set_hl(0, "NavicIconsBoolean",       { fg = "#bd93f9", bg = "#1e222a" })
vim.api.nvim_set_hl(0, "NavicIconsArray",         { fg = "#8be9fd", bg = "#1e222a" })
vim.api.nvim_set_hl(0, "NavicIconsObject",        { fg = "#ff79c6", bg = "#1e222a" })
vim.api.nvim_set_hl(0, "NavicIconsKey",           { fg = "#f1fa8c", bg = "#1e222a" })
vim.api.nvim_set_hl(0, "NavicIconsNull",          { fg = "#f8f8f2", bg = "#1e222a" })
vim.api.nvim_set_hl(0, "NavicIconsEnumMember",    { fg = "#56b6c2", bg = "#1e222a" })
vim.api.nvim_set_hl(0, "NavicIconsStruct",        { fg = "#61afef", bg = "#1e222a" })
vim.api.nvim_set_hl(0, "NavicIconsEvent",         { fg = "#ffb86c", bg = "#1e222a" })
vim.api.nvim_set_hl(0, "NavicIconsOperator",      { fg = "#ff79c6", bg = "#1e222a" })
vim.api.nvim_set_hl(0, "NavicIconsTypeParameter", { fg = "#bd93f9", bg = "#1e222a" })
vim.api.nvim_set_hl(0, "NavicText",               { fg = "#abb2bf", bg = "#1e222a" })
vim.api.nvim_set_hl(0, "NavicSeparator",          { fg = "#5c6370", bg = "#1e222a" })

require("spectre").setup(require("custom.configs.spectre"))

require("custom.configs.linenum")
require("custom.configs.nvim-treesitter-textobjects")

require("snippy").setup(require("custom.configs.snippy"))
require "custom/configs/filetypes"
-- require("plugins/configs/gutentags.lua").setup()
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setqflist)
--

-- local function set_navic_highlights()
--   vim.api.nvim_set_hl(0, "@lsp.type.function",      { fg = "#C678DD" })
--   vim.api.nvim_set_hl(0, "@lsp.type.class",         { fg = "#61AFEF" })
--   vim.api.nvim_set_hl(0, "@lsp.type.method",        { fg = "#98C379" })
--   vim.api.nvim_set_hl(0, "@lsp.type.property",      { fg = "#E5C07B" })
--   vim.api.nvim_set_hl(0, "@lsp.type.variable",      { fg = "#E06C75" })
--   vim.api.nvim_set_hl(0, "@lsp.type.enum",          { fg = "#56B6C2" })
--   vim.api.nvim_set_hl(0, "@lsp.type.interface",     { fg = "#61AFEF" })
--   vim.api.nvim_set_hl(0, "@lsp.type.namespace",     { fg = "#ABB2BF" })
--   vim.api.nvim_set_hl(0, "@lsp.type.struct",        { fg = "#56B6C2" })
--   vim.api.nvim_set_hl(0, "@lsp.type.constructor",   { fg = "#D19A66" })
--   vim.api.nvim_set_hl(0, "@lsp.type.enumMember",    { fg = "#E06C75" })
--   vim.api.nvim_set_hl(0, "@lsp.type.typeParameter", { fg = "#D19A66" })
--   vim.api.nvim_set_hl(0, "@lsp.type.parameter",     { fg = "#E5C07B" })
--   vim.api.nvim_set_hl(0, "@lsp.type.macro",         { fg = "#C678DD" })
--   vim.api.nvim_set_hl(0, "@lsp.type.keyword",       { fg = "#FF79C6" })
--   vim.api.nvim_set_hl(0, "@lsp.type.modifier",      { fg = "#56B6C2" })
-- end
--
-- set_navic_highlights()
-- vim.api.nvim_create_autocmd("ColorScheme", {
--   pattern = "*",
--   callback = set_navic_highlights,
-- })
