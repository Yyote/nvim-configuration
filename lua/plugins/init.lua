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
        "nluavim-tree/nvim-web-devicons",
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
        main = "ibl",
        event = "User FilePost",
        opts = {},
        -- opts = function()
        --     return require("plugins.configs.others").blankline
        -- end,
        config = function(_, opts)
            require("core.utils").load_mappings "blankline"
            dofile(vim.g.base46_cache .. "blankline")
            require("ibl").setup(opts)
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
            { "gcc", mode = "n",          desc = "Comment toggle current line" },
            { "gc",  mode = { "n", "o" }, desc = "Comment toggle linewise" },
            { "gc",  mode = "x",          desc = "Comment toggle linewise (visual)" },
            { "gbc", mode = "n",          desc = "Comment toggle current block" },
            { "gb",  mode = { "n", "o" }, desc = "Comment toggle blockwise" },
            { "gb",  mode = "x",          desc = "Comment toggle blockwise (visual)" },
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
        "ludovicchabant/vim-gutentags",          -- plugin repository[1]
        event = { "BufReadPost", "BufNewFile" }, -- lazy-load when a file opens
        init = function()
            -- where tag files are written (optional but keeps project roots clean)
            vim.g.gutentags_cache_dir = vim.fn.stdpath("cache") .. "/tags"
            -- recognised project roots in addition to .git/.hg (example)
            vim.g.gutentags_project_root = { ".git", "Makefile", "package.json" }
        end,
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



-- Keybindings
vim.api.nvim_set_keymap(
    "v",
    "<F1>",
    ":<c-u>HSHighlight 1<CR>",
    {
        noremap = true,
        silent = true
    }
)
vim.api.nvim_set_keymap(
    "v",
    "<F2>",
    ":<c-u>HSHighlight 2<CR>",
    {
        noremap = true,
        silent = true
    }
)
vim.api.nvim_set_keymap(
    "v",
    "<F3>",
    ":<c-u>HSHighlight 3<CR>",
    {
        noremap = true,
        silent = true
    }
)
vim.api.nvim_set_keymap(
    "v",
    "<F4>",
    ":<c-u>HSHighlight 4<CR>",
    {
        noremap = true,
        silent = true
    }
)

vim.api.nvim_set_keymap(
    "v",
    "<F12>",
    ":<c-u>HSRmHighlight<CR>",
    {
        noremap = true,
        silent = true
    }
)



-- Normal mode bindings:

-- buffer splits
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Horizontal Split" })
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Vertical Split" })

-- quit
vim.keymap.set("n", "<leader>q", ":ConfirmQuit<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>qa", ":ConfirmQuitAll<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>Q", ":q!<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>Qa", ":qa!<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>wq", ":wq<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>wqa", ":wqa<CR>", { desc = "Quit" })


require("ibl").setup { indent = { highlight = highlight } }
-- require("nvim-rg").setup()


require("trouble").setup()

require("high-str")

require("spectre").setup(require("custom.configs.spectre"))

require("custom.configs.linenum")
require("custom.configs.nvim-treesitter-textobjects")

require("snippy").setup(require("custom.configs.snippy"))
require "custom/configs/filetypes"
-- require("plugins/configs/gutentags.lua").setup()
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setqflist)

-- Define custom highlight
vim.api.nvim_set_hl(0, "TabSpaceMismatch", {
    fg = "#ff0000",    -- red text
    bg = "#662727",    -- dark gray background
    undercurl = false, -- wavy underline
    sp = "#ff6b6b"     -- underline color
})

require("tabs-vs-spaces").setup {
    -- Preferred indentation. Possible values: "auto"|"tabs"|"spaces".
    -- "auto" detects the dominant indentation style in a buffer and highlights deviations.
    indentation = "spaces",
    -- Use a string like "DiagnosticUnderlineError" to link the `TabsVsSpace` highlight to another highlight.
    -- Or a table valid for `nvim_set_hl` - e.g. { fg = "MediumSlateBlue", undercurl = true }.
    highlight = "TabSpaceMismatch",
    -- Priority of highight matches.
    priority = 20,
    ignore = {
        filetypes = { "go" },
        -- Works for normal buffers by default.
        buftypes = {
            "acwrite",
            "help",
            "nofile",
            "nowrite",
            "quickfix",
            "terminal",
            "prompt",
        },
    },
    standartize_on_save = false,
    -- Enable or disable user commands see Readme.md/#Commands for more info.
    user_commands = true,
}

-- In your NvChad config, add a Go-specific override
vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        vim.opt_local.expandtab = false -- Use actual tabs
        vim.opt_local.tabstop = 4       -- Display tabs as 4 spaces width
        vim.opt_local.shiftwidth = 4    -- Indent with 4 spaces worth
    end,
})


require("noice").setup({
    cmdline = {
        enabled = true,
        view = "cmdline_popup",
        format = {
            cmdline = { pattern = "^:", icon = "", lang = "" }, -- Disable vim lang
        },
    },
})

require("notify").setup({
    background_colour = "#000000", -- Set to any valid hex color
})
