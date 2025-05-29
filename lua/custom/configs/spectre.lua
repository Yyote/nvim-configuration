
local opts = {
  mapping={
--     ['tab'] = {
--         map = '<Tab>',
--         cmd = "<cmd>lua require('spectre').tab()<cr>",
--         desc = 'next query'
--     },
--     ['shift-tab'] = {
--         map = '<S-Tab>',
--         cmd = "<cmd>lua require('spectre').tab_shift()<cr>",
--         desc = 'previous query'
--     },
--     ['toggle_line'] = {
--         map = "dd",
--         cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
--         desc = "toggle item"
--     },
    ['run_replace'] = {
        map = "<leader>R",
        cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
        desc = "replace all"
    },
    ['run_current_replace'] = {
      map = "<leader>rc",
      cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
      desc = "replace current line"
    },
    ['enter_file'] = {
        map = "<cr>",
        cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
        desc = "open file"
    },
  },
  find_engine = {
    ['ag'] = {
      cmd = "ag",
      args = {
          '-u',
          '--vimgrep',
          '--literal',
          '--case-sensitive',
       } ,
      options = {
        ['ignore-case'] = {
          value= "-i",
          icon="[I]",
          desc="ignore case"
        },
        ['hidden'] = {
          value="--hidden",
          desc="hidden file",
          icon="[H]"
        },
      },
    },
  },
  default = {
      find = {
         --pick one of item in find_engine
         cmd = "ag",
         options = {"ignore-case"}
      },
      replace={
          --pick one of item in replace_engine
          cmd = "sed"
      },
  },
}

vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
    desc = "Toggle Spectre"
})
vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
    desc = "Search current word"
})
vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
    desc = "Search current word"
})
vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
    desc = "Search on current file"
})
return opts
