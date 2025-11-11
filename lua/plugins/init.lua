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

require('render-markdown').setup({
    heading = {
        -- Useful context to have when evaluating values.
        -- | level    | the number of '#' in the heading marker         |
        -- | sections | for each level how deeply nested the heading is |

        -- Turn on / off heading icon & background rendering.
        enabled = true,
        -- Additional modes to render headings.
        render_modes = false,
        -- Turn on / off atx heading rendering.
        atx = true,
        -- Turn on / off setext heading rendering.
        setext = true,
        -- Turn on / off sign column related rendering.
        sign = true,
        -- Replaces '#+' of 'atx_h._marker'.
        -- Output is evaluated depending on the type.
        -- | function | `value(context)`              |
        -- | string[] | `cycle(value, context.level)` |
        icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
        -- Determines how icons fill the available space.
        -- | right   | '#'s are concealed and icon is appended to right side                      |
        -- | inline  | '#'s are concealed and icon is inlined on left side                        |
        -- | overlay | icon is left padded with spaces and inserted on left hiding additional '#' |
        position = 'overlay',
        -- Added to the sign column if enabled.
        -- Output is evaluated by `cycle(value, context.level)`.
        signs = { '󰫎 ' },
        -- Width of the heading background.
        -- | block | width of the heading text |
        -- | full  | full width of the window  |
        -- Can also be a list of the above values evaluated by `clamp(value, context.level)`.
        width = 'full',
        -- Amount of margin to add to the left of headings.
        -- Margin available space is computed after accounting for padding.
        -- If a float < 1 is provided it is treated as a percentage of available window space.
        -- Can also be a list of numbers evaluated by `clamp(value, context.level)`.
        left_margin = 0,
        -- Amount of padding to add to the left of headings.
        -- Output is evaluated using the same logic as 'left_margin'.
        left_pad = 0,
        -- Amount of padding to add to the right of headings when width is 'block'.
        -- Output is evaluated using the same logic as 'left_margin'.
        right_pad = 0,
        -- Minimum width to use for headings when width is 'block'.
        -- Can also be a list of integers evaluated by `clamp(value, context.level)`.
        min_width = 0,
        -- Determines if a border is added above and below headings.
        -- Can also be a list of booleans evaluated by `clamp(value, context.level)`.
        border = false,
        -- Always use virtual lines for heading borders instead of attempting to use empty lines.
        border_virtual = false,
        -- Highlight the start of the border using the foreground highlight.
        border_prefix = false,
        -- Used above heading for border.
        above = '▄',
        -- Used below heading for border.
        below = '▀',
        -- Highlight for the heading icon and extends through the entire line.
        -- Output is evaluated by `clamp(value, context.level)`.
        backgrounds = {
            'RenderMarkdownH1Bg',
            'RenderMarkdownH2Bg',
            'RenderMarkdownH3Bg',
            'RenderMarkdownH4Bg',
            'RenderMarkdownH5Bg',
            'RenderMarkdownH6Bg',
        },
        -- Highlight for the heading and sign icons.
        -- Output is evaluated using the same logic as 'backgrounds'.
        foregrounds = {
            'RenderMarkdownH1',
            'RenderMarkdownH2',
            'RenderMarkdownH3',
            'RenderMarkdownH4',
            'RenderMarkdownH5',
            'RenderMarkdownH6',
        },
        -- Define custom heading patterns which allow you to override various properties based on
        -- the contents of a heading.
        -- The key is for healthcheck and to allow users to change its values, value type below.
        -- | pattern    | matched against the heading text @see :h lua-patterns |
        -- | icon       | optional override for the icon                        |
        -- | background | optional override for the background                  |
        -- | foreground | optional override for the foreground                  |
        custom = {},
    },
    paragraph = {
        -- Useful context to have when evaluating values.
        -- | text | text value of the node |

        -- Turn on / off paragraph rendering.
        enabled = true,
        -- Additional modes to render paragraphs.
        render_modes = false,
        -- Amount of margin to add to the left of paragraphs.
        -- If a float < 1 is provided it is treated as a percentage of available window space.
        -- Output is evaluated depending on the type.
        -- | function | `value(context)` |
        -- | number   | `value`          |
        left_margin = 0,
        -- Amount of padding to add to the first line of each paragraph.
        -- Output is evaluated using the same logic as 'left_margin'.
        indent = 0,
        -- Minimum width to use for paragraphs.
        min_width = 0,
    },
    code = {
        -- Turn on / off code block & inline code rendering.
        enabled = true,
        -- Additional modes to render code blocks.
        render_modes = false,
        -- Turn on / off sign column related rendering.
        sign = true,
        -- Whether to conceal nodes at the top and bottom of code blocks.
        conceal_delimiters = true,
        -- Turn on / off language heading related rendering.
        language = true,
        -- Determines where language icon is rendered.
        -- | right | right side of code block |
        -- | left  | left side of code block  |
        position = 'left',
        -- Whether to include the language icon above code blocks.
        language_icon = true,
        -- Whether to include the language name above code blocks.
        language_name = true,
        -- Whether to include the language info above code blocks.
        language_info = true,
        -- Amount of padding to add around the language.
        -- If a float < 1 is provided it is treated as a percentage of available window space.
        language_pad = 0,
        -- A list of language names for which background highlighting will be disabled.
        -- Likely because that language has background highlights itself.
        -- Use a boolean to make behavior apply to all languages.
        -- Borders above & below blocks will continue to be rendered.
        disable_background = { 'diff' },
        -- Width of the code block background.
        -- | block | width of the code block  |
        -- | full  | full width of the window |
        width = 'full',
        -- Amount of margin to add to the left of code blocks.
        -- If a float < 1 is provided it is treated as a percentage of available window space.
        -- Margin available space is computed after accounting for padding.
        left_margin = 0,
        -- Amount of padding to add to the left of code blocks.
        -- If a float < 1 is provided it is treated as a percentage of available window space.
        left_pad = 0,
        -- Amount of padding to add to the right of code blocks when width is 'block'.
        -- If a float < 1 is provided it is treated as a percentage of available window space.
        right_pad = 0,
        -- Minimum width to use for code blocks when width is 'block'.
        min_width = 0,
        -- Determines how the top / bottom of code block are rendered.
        -- | none  | do not render a border                               |
        -- | thick | use the same highlight as the code body              |
        -- | thin  | when lines are empty overlay the above & below icons |
        -- | hide  | conceal lines unless language name or icon is added  |
        border = 'hide',
        -- Used above code blocks to fill remaining space around language.
        language_border = '█',
        -- Added to the left of language.
        language_left = '',
        -- Added to the right of language.
        language_right = '',
        -- Used above code blocks for thin border.
        above = '▄',
        -- Used below code blocks for thin border.
        below = '▀',
        -- Turn on / off inline code related rendering.
        inline = true,
        -- Icon to add to the left of inline code.
        inline_left = '',
        -- Icon to add to the right of inline code.
        inline_right = '',
        -- Padding to add to the left & right of inline code.
        inline_pad = 0,
        -- Highlight for code blocks.
        highlight = 'RenderMarkdownCode',
        -- Highlight for code info section, after the language.
        highlight_info = 'RenderMarkdownCodeInfo',
        -- Highlight for language, overrides icon provider value.
        highlight_language = nil,
        -- Highlight for border, use false to add no highlight.
        highlight_border = 'RenderMarkdownCodeBorder',
        -- Highlight for language, used if icon provider does not have a value.
        highlight_fallback = 'RenderMarkdownCodeFallback',
        -- Highlight for inline code.
        highlight_inline = 'RenderMarkdownCodeInline',
        -- Determines how code blocks & inline code are rendered.
        -- | none     | { enabled = false }                           |
        -- | normal   | { language = false }                          |
        -- | language | { disable_background = true, inline = false } |
        -- | full     | uses all default values                       |
        style = 'full',
    },
    dash = {
        -- Useful context to have when evaluating values.
        -- | width | width of the current window |

        -- Turn on / off thematic break rendering.
        enabled = true,
        -- Additional modes to render dash.
        render_modes = false,
        -- Replaces '---'|'***'|'___'|'* * *' of 'thematic_break'.
        -- The icon gets repeated across the window's width.
        icon = '─',
        -- Width of the generated line.
        -- If a float < 1 is provided it is treated as a percentage of available window space.
        -- Output is evaluated depending on the type.
        -- | function | `value(context)`    |
        -- | number   | `value`             |
        -- | full     | width of the window |
        width = 'full',
        -- Amount of margin to add to the left of dash.
        -- If a float < 1 is provided it is treated as a percentage of available window space.
        left_margin = 0,
        -- Highlight for the whole line generated from the icon.
        highlight = 'RenderMarkdownDash',
    },
    bullet = {
        -- Useful context to have when evaluating values.
        -- | level | how deeply nested the list is, 1-indexed          |
        -- | index | how far down the item is at that level, 1-indexed |
        -- | value | text value of the marker node                     |

        -- Turn on / off list bullet rendering
        enabled = true,
        -- Additional modes to render list bullets
        render_modes = false,
        -- Replaces '-'|'+'|'*' of 'list_item'.
        -- If the item is a 'checkbox' a conceal is used to hide the bullet instead.
        -- Output is evaluated depending on the type.
        -- | function   | `value(context)`                                    |
        -- | string     | `value`                                             |
        -- | string[]   | `cycle(value, context.level)`                       |
        -- | string[][] | `clamp(cycle(value, context.level), context.index)` |
        icons = { '●', '○', '◆', '◇' },
        -- Replaces 'n.'|'n)' of 'list_item'.
        -- Output is evaluated using the same logic as 'icons'.
        ordered_icons = function(ctx)
            local value = vim.trim(ctx.value)
            local index = tonumber(value:sub(1, #value - 1))
            return ('%d.'):format(index > 1 and index or ctx.index)
        end,
        -- Padding to add to the left of bullet point.
        -- Output is evaluated depending on the type.
        -- | function | `value(context)` |
        -- | integer  | `value`          |
        left_pad = 0,
        -- Padding to add to the right of bullet point.
        -- Output is evaluated using the same logic as 'left_pad'.
        right_pad = 0,
        -- Highlight for the bullet icon.
        -- Output is evaluated using the same logic as 'icons'.
        highlight = 'RenderMarkdownBullet',
        -- Highlight for item associated with the bullet point.
        -- Output is evaluated using the same logic as 'icons'.
        scope_highlight = {},
        -- Priority to assign to scope highlight.
        scope_priority = nil,
    },
    checkbox = {
        -- Checkboxes are a special instance of a 'list_item' that start with a 'shortcut_link'.
        -- There are two special states for unchecked & checked defined in the markdown grammar.

        -- Turn on / off checkbox state rendering.
        enabled = true,
        -- Additional modes to render checkboxes.
        render_modes = false,
        -- Render the bullet point before the checkbox.
        bullet = false,
        -- Padding to add to the left of checkboxes.
        left_pad = 0,
        -- Padding to add to the right of checkboxes.
        right_pad = 1,
        unchecked = {
            -- Replaces '[ ]' of 'task_list_marker_unchecked'.
            icon = '󰄱 ',
            -- Highlight for the unchecked icon.
            highlight = 'RenderMarkdownUnchecked',
            -- Highlight for item associated with unchecked checkbox.
            scope_highlight = nil,
        },
        checked = {
            -- Replaces '[x]' of 'task_list_marker_checked'.
            icon = '󰱒 ',
            -- Highlight for the checked icon.
            highlight = 'RenderMarkdownChecked',
            -- Highlight for item associated with checked checkbox.
            scope_highlight = nil,
        },
        -- Define custom checkbox states, more involved, not part of the markdown grammar.
        -- As a result this requires neovim >= 0.10.0 since it relies on 'inline' extmarks.
        -- The key is for healthcheck and to allow users to change its values, value type below.
        -- | raw             | matched against the raw text of a 'shortcut_link'           |
        -- | rendered        | replaces the 'raw' value when rendering                     |
        -- | highlight       | highlight for the 'rendered' icon                           |
        -- | scope_highlight | optional highlight for item associated with custom checkbox |
        -- stylua: ignore
        custom = {
            todo = { raw = '[-]', rendered = '󰥔 ', highlight = 'RenderMarkdownTodo', scope_highlight = nil },
        },
        -- Priority to assign to scope highlight.
        scope_priority = nil,
    },
    quote = {
        -- Turn on / off block quote & callout rendering.
        enabled = true,
        -- Additional modes to render quotes.
        render_modes = false,
        -- Replaces '>' of 'block_quote'.
        icon = '▋',
        -- Whether to repeat icon on wrapped lines. Requires neovim >= 0.10. This will obscure text
        -- if incorrectly configured with :h 'showbreak', :h 'breakindent' and :h 'breakindentopt'.
        -- A combination of these that is likely to work follows.
        -- | showbreak      | '  ' (2 spaces)   |
        -- | breakindent    | true              |
        -- | breakindentopt | '' (empty string) |
        -- These are not validated by this plugin. If you want to avoid adding these to your main
        -- configuration then set them in win_options for this plugin.
        repeat_linebreak = false,
        -- Highlight for the quote icon.
        -- If a list is provided output is evaluated by `cycle(value, level)`.
        highlight = {
            'RenderMarkdownQuote1',
            'RenderMarkdownQuote2',
            'RenderMarkdownQuote3',
            'RenderMarkdownQuote4',
            'RenderMarkdownQuote5',
            'RenderMarkdownQuote6',
        },
    },
    pipe_table = {
        -- Turn on / off pipe table rendering.
        enabled = true,
        -- Additional modes to render pipe tables.
        render_modes = false,
        -- Pre configured settings largely for setting table border easier.
        -- | heavy  | use thicker border characters     |
        -- | double | use double line border characters |
        -- | round  | use round border corners          |
        -- | none   | does nothing                      |
        preset = 'none',
        -- Determines how individual cells of a table are rendered.
        -- | overlay | writes completely over the table, removing conceal behavior and highlights |
        -- | raw     | replaces only the '|' characters in each row, leaving the cells unmodified |
        -- | padded  | raw + cells are padded to maximum visual width for each column             |
        -- | trimmed | padded except empty space is subtracted from visual width calculation      |
        cell = 'padded',
        -- Adjust the computed width of table cells using custom logic.
        cell_offset = function()
            return 0
        end,
        -- Amount of space to put between cell contents and border.
        padding = 1,
        -- Minimum column width to use for padded or trimmed cell.
        min_width = 0,
        -- Characters used to replace table border.
        -- Correspond to top(3), delimiter(3), bottom(3), vertical, & horizontal.
        -- stylua: ignore
        border = {
            '┌', '┬', '┐',
            '├', '┼', '┤',
            '└', '┴', '┘',
            '│', '─',
        },
        -- Turn on / off top & bottom lines.
        border_enabled = true,
        -- Always use virtual lines for table borders instead of attempting to use empty lines.
        -- Will be automatically enabled if indentation module is enabled.
        border_virtual = false,
        -- Gets placed in delimiter row for each column, position is based on alignment.
        alignment_indicator = '━',
        -- Highlight for table heading, delimiter, and the line above.
        head = 'RenderMarkdownTableHead',
        -- Highlight for everything else, main table rows and the line below.
        row = 'RenderMarkdownTableRow',
        -- Highlight for inline padding used to add back concealed space.
        filler = 'RenderMarkdownTableFill',
        -- Determines how the table as a whole is rendered.
        -- | none   | { enabled = false }        |
        -- | normal | { border_enabled = false } |
        -- | full   | uses all default values    |
        style = 'full',
    },
    callout = {
        -- Callouts are a special instance of a 'block_quote' that start with a 'shortcut_link'.
        -- The key is for healthcheck and to allow users to change its values, value type below.
        -- | raw        | matched against the raw text of a 'shortcut_link', case insensitive |
        -- | rendered   | replaces the 'raw' value when rendering                             |
        -- | highlight  | highlight for the 'rendered' text and quote markers                 |
        -- | quote_icon | optional override for quote.icon value for individual callout       |
        -- | category   | optional metadata useful for filtering                              |

        note      = { raw = '[!NOTE]', rendered = '󰋽 Note', highlight = 'RenderMarkdownInfo', category = 'github' },
        tip       = { raw = '[!TIP]', rendered = '󰌶 Tip', highlight = 'RenderMarkdownSuccess', category = 'github' },
        important = { raw = '[!IMPORTANT]', rendered = '󰅾 Important', highlight = 'RenderMarkdownHint', category = 'github' },
        warning   = { raw = '[!WARNING]', rendered = '󰀪 Warning', highlight = 'RenderMarkdownWarn', category = 'github' },
        caution   = { raw = '[!CAUTION]', rendered = '󰳦 Caution', highlight = 'RenderMarkdownError', category = 'github' },
        -- Obsidian: https://help.obsidian.md/Editing+and+formatting/Callouts
        abstract  = { raw = '[!ABSTRACT]', rendered = '󰨸 Abstract', highlight = 'RenderMarkdownInfo', category = 'obsidian' },
        summary   = { raw = '[!SUMMARY]', rendered = '󰨸 Summary', highlight = 'RenderMarkdownInfo', category = 'obsidian' },
        tldr      = { raw = '[!TLDR]', rendered = '󰨸 Tldr', highlight = 'RenderMarkdownInfo', category = 'obsidian' },
        info      = { raw = '[!INFO]', rendered = '󰋽 Info', highlight = 'RenderMarkdownInfo', category = 'obsidian' },
        todo      = { raw = '[!TODO]', rendered = '󰗡 Todo', highlight = 'RenderMarkdownInfo', category = 'obsidian' },
        hint      = { raw = '[!HINT]', rendered = '󰌶 Hint', highlight = 'RenderMarkdownSuccess', category = 'obsidian' },
        success   = { raw = '[!SUCCESS]', rendered = '󰄬 Success', highlight = 'RenderMarkdownSuccess', category = 'obsidian' },
        check     = { raw = '[!CHECK]', rendered = '󰄬 Check', highlight = 'RenderMarkdownSuccess', category = 'obsidian' },
        done      = { raw = '[!DONE]', rendered = '󰄬 Done', highlight = 'RenderMarkdownSuccess', category = 'obsidian' },
        question  = { raw = '[!QUESTION]', rendered = '󰘥 Question', highlight = 'RenderMarkdownWarn', category = 'obsidian' },
        help      = { raw = '[!HELP]', rendered = '󰘥 Help', highlight = 'RenderMarkdownWarn', category = 'obsidian' },
        faq       = { raw = '[!FAQ]', rendered = '󰘥 Faq', highlight = 'RenderMarkdownWarn', category = 'obsidian' },
        attention = { raw = '[!ATTENTION]', rendered = '󰀪 Attention', highlight = 'RenderMarkdownWarn', category = 'obsidian' },
        failure   = { raw = '[!FAILURE]', rendered = '󰅖 Failure', highlight = 'RenderMarkdownError', category = 'obsidian' },
        fail      = { raw = '[!FAIL]', rendered = '󰅖 Fail', highlight = 'RenderMarkdownError', category = 'obsidian' },
        missing   = { raw = '[!MISSING]', rendered = '󰅖 Missing', highlight = 'RenderMarkdownError', category = 'obsidian' },
        danger    = { raw = '[!DANGER]', rendered = '󱐌 Danger', highlight = 'RenderMarkdownError', category = 'obsidian' },
        error     = { raw = '[!ERROR]', rendered = '󱐌 Error', highlight = 'RenderMarkdownError', category = 'obsidian' },
        bug       = { raw = '[!BUG]', rendered = '󰨰 Bug', highlight = 'RenderMarkdownError', category = 'obsidian' },
        example   = { raw = '[!EXAMPLE]', rendered = '󰉹 Example', highlight = 'RenderMarkdownHint', category = 'obsidian' },
        quote     = { raw = '[!QUOTE]', rendered = '󱆨 Quote', highlight = 'RenderMarkdownQuote', category = 'obsidian' },
        cite      = { raw = '[!CITE]', rendered = '󱆨 Cite', highlight = 'RenderMarkdownQuote', category = 'obsidian' },
    },
    link = {
        -- Turn on / off inline link icon rendering.
        enabled = true,
        -- Additional modes to render links.
        render_modes = false,
        -- How to handle footnote links, start with a '^'.
        footnote = {
            -- Turn on / off footnote rendering.
            enabled = true,
            -- Inlined with content.
            icon = '󰯔 ',
            -- Replace value with superscript equivalent.
            superscript = true,
            -- Added before link content.
            prefix = '',
            -- Added after link content.
            suffix = '',
        },
        -- Inlined with 'image' elements.
        image = '󰥶 ',
        -- Inlined with 'email_autolink' elements.
        email = '󰀓 ',
        -- Fallback icon for 'inline_link' and 'uri_autolink' elements.
        hyperlink = '󰌹 ',
        -- Applies to the inlined icon as a fallback.
        highlight = 'RenderMarkdownLink',
        -- Applies to WikiLink elements.
        wiki = {
            icon = '󱗖 ',
            body = function()
                return nil
            end,
            highlight = 'RenderMarkdownWikiLink',
            scope_highlight = nil,
        },
        -- Define custom destination patterns so icons can quickly inform you of what a link
        -- contains. Applies to 'inline_link', 'uri_autolink', and wikilink nodes. When multiple
        -- patterns match a link the one with the longer pattern is used.
        -- The key is for healthcheck and to allow users to change its values, value type below.
        -- | pattern   | matched against the destination text                            |
        -- | icon      | gets inlined before the link text                               |
        -- | kind      | optional determines how pattern is checked                      |
        -- |           | pattern | @see :h lua-patterns, is the default if not set       |
        -- |           | suffix  | @see :h vim.endswith()                                |
        -- | priority  | optional used when multiple match, uses pattern length if empty |
        -- | highlight | optional highlight for 'icon', uses fallback highlight if empty |
        custom = {
            web = { pattern = '^http', icon = '󰖟 ' },
            discord = { pattern = 'discord%.com', icon = '󰙯 ' },
            github = { pattern = 'github%.com', icon = '󰊤 ' },
            gitlab = { pattern = 'gitlab%.com', icon = '󰮠 ' },
            google = { pattern = 'google%.com', icon = '󰊭 ' },
            neovim = { pattern = 'neovim%.io', icon = ' ' },
            reddit = { pattern = 'reddit%.com', icon = '󰑍 ' },
            stackoverflow = { pattern = 'stackoverflow%.com', icon = '󰓌 ' },
            wikipedia = { pattern = 'wikipedia%.org', icon = '󰖬 ' },
            youtube = { pattern = 'youtube%.com', icon = '󰗃 ' },
        },
    },
    sign = {
        -- Turn on / off sign rendering.
        enabled = true,
        -- Applies to background of sign text.
        highlight = 'RenderMarkdownSign',
    },
    indent = {
        -- Mimic org-indent-mode behavior by indenting everything under a heading based on the
        -- level of the heading. Indenting starts from level 2 headings onward by default.

        -- Turn on / off org-indent-mode.
        enabled = false,
        -- Additional modes to render indents.
        render_modes = false,
        -- Amount of additional padding added for each heading level.
        per_level = 2,
        -- Heading levels <= this value will not be indented.
        -- Use 0 to begin indenting from the very first level.
        skip_level = 1,
        -- Do not indent heading titles, only the body.
        skip_heading = false,
        -- Prefix added when indenting, one per level.
        icon = '▎',
        -- Priority to assign to extmarks.
        priority = 0,
        -- Applied to icon.
        highlight = 'RenderMarkdownIndent',
    },
})
