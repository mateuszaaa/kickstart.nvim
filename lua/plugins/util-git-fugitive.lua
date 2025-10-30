return {
  'tpope/vim-fugitive',
  lazy = false,
  keys = {
    { '<leader>gg', '<cmd>Git<cr>', desc = 'git status' },
    { '<leader>gd', '<cmd>Gvdiffsplit HEAD<cr>', desc = 'git diff' },
    { '<leader>gD', ':Gvdiffsplit HEAD~0', desc = 'git diff HEAD' },
  },
}
