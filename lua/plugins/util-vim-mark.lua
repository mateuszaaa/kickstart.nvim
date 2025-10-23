return {
  'inkarkat/vim-mark',
  init = function()
    vim.keymap.set('n', '<Leader>gggg', '<Plug>MarkSearchAnyNext')
    vim.keymap.set('n', '<Leader>gggggg', '<Plug>MarkClear')
    vim.keymap.set('n', '<Leader>ggggggg', '<Plug>MarkSearchNext')
    vim.keymap.set('n', '<Leader>gggggggg', '<Plug>MarkSearchPrev')
    vim.keymap.set('n', '<Leader>ggggggggg', '<Plug>MarkRegex')
    vim.keymap.set('n', '<Leader>gggggggggg', '<Plug>MarkSearchCurrentNext')
    vim.keymap.set('n', '<Leader>ggggggggggg', '<Plug>MarkSearchCurrentPrev')
    vim.keymap.set('n', '<Leader>gggggggggggg', '<Plug>MarkSearchAllNext')
    vim.keymap.set('n', '<Leader>ggggggggggggg', '<Plug>MarkSearchAllPrev')
  end,
  dependencies = {
    'inkarkat/vim-ingo-library',
  },
}
