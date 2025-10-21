return {
  'inkarkat/vim-mark',
  init = function()
    vim.keymap.set('n', '<Leader>gggg', '<Plug>MarkSearchAnyNext')
    vim.keymap.set('n', '<Leader>gggggg', '<Plug>MarkClear')
    vim.keymap.set('n', '<Leader>ggggggg', '<Plug>MarkSearchNext')
    vim.keymap.set('n', '<Leader>gggggggg', '<Plug>MarkSearchPrev')
  end,
  dependencies = {
    'inkarkat/vim-ingo-library',
  },
}
