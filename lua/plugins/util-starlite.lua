return {
  'ironhouzi/starlite-nvim',
  config = function()
    local starlite = require 'starlite'
    vim.keymap.set('n', '*', starlite.star, { silent = true })
    vim.keymap.set('n', 'g*', starlite.g_star, { silent = true })
    vim.keymap.set('n', '#', starlite.hash, { silent = true })
    vim.keymap.set('n', 'g#', starlite.g_hash, { silent = true })
  end,
}
