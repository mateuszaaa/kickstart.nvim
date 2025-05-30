return {
  'vim-mark/vim-mark',
  init = function()
    vim.keymap.set('n', '<Leader>gggg', '<Plug>MarkSearchAnyNext')
    vim.keymap.set('n', '<Leader>M', '<Plug>MarkClear')
  end,
  dependencies = {
    'inkarkat/vim-ingo-library',
  },
}
