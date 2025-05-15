local api = require("nvim-tree.api")


local function edit_or_open()
  local node = api.tree.get_node_under_cursor()
  if node.nodes ~= nil then
    -- If it's a folder, expand or collapse it
    api.node.open.edit()
  else
    -- If it's a file, open it and close the tree
    api.node.open.edit()
    api.tree.close()
  end
end

local function vsplit_preview()
  local node = api.tree.get_node_under_cursor()
  if node.nodes ~= nil then
    api.node.open.edit()
  else
    -- Open file in vertical split
    api.node.open.vertical()
  end
  -- Keep focus on tree
  api.tree.focus()
end

local options = {
  filters = {
    dotfiles = false,
    exclude = { vim.fn.stdpath "config" .. "/lua/custom" },
  },
  disable_netrw = true,
  hijack_netrw = true,
  hijack_cursor = true,
  hijack_unnamed_buffer_when_opening = false,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  view = {
    adaptive_size = false,
    side = "left",
    width = 30,
    preserve_window_proportions = true,
    mappings = {
      list = {
        { key = "l", action = "custom", action_cb = edit_or_open },
        { key = "L", action = "custom", action_cb = vsplit_preview },
        { key = "h", action = "close_node" },
        { key = "H", action = "collapse_all" },
      },
    },
  },
  git = {
    enable = false,
    ignore = true,
  },
  filesystem_watchers = {
    enable = true,
  },
  actions = {
    open_file = {
      resize_window = true,
    },
  },
  renderer = {
    root_folder_label = false,
    highlight_git = false,
    highlight_opened_files = "none",

    indent_markers = {
      enable = false,
    },

    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = false,
      },

      glyphs = {
        default = "󰈚",
        symlink = "",
        folder = {
          default = "",
          empty = "",
          empty_open = "",
          open = "",
          symlink = "",
          symlink_open = "",
          arrow_open = "",
          arrow_closed = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
}

return options
