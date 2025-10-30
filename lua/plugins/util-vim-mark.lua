return {
  'inkarkat/vim-mark',
  init = function()
    vim.keymap.set('n', '<Leader>gzzzz', '<Plug>MarkSearchAnyNext')
    vim.keymap.set('n', '<Leader>gzzzzz', '<Plug>MarkClear')
    vim.keymap.set('n', '<Leader>gzzzzzg', '<Plug>MarkSearchNext')
    vim.keymap.set('n', '<Leader>gzzzzzgg', '<Plug>MarkSearchPrev')
    vim.keymap.set('n', '<Leader>gzzzzzggg', '<Plug>MarkRegex')
    vim.keymap.set('n', '<Leader>gzzzzzgggg', '<Plug>MarkSearchCurrentNext')
    vim.keymap.set('n', '<Leader>gzzzzzggggg', '<Plug>MarkSearchCurrentPrev')
    vim.keymap.set('n', '<Leader>gzzzzzgggggg', '<Plug>MarkSearchAllNext')
    vim.keymap.set('n', '<Leader>gzzzzzggggggg', '<Plug>MarkSearchAllPrev')
  end,
  dependencies = {
    'inkarkat/vim-ingo-library',
  },
}
