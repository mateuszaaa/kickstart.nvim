return {
  'tiagovla/tokyodark.nvim',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  config = function()
    vim.cmd.colorscheme 'tokyodark'
    vim.api.nvim_set_hl(0, 'DiffAdd', { bg = '#1a3a1a' })
    vim.api.nvim_set_hl(0, 'DiffChange', { bg = '#1a2a3a' })
    vim.api.nvim_set_hl(0, 'DiffDelete', { bg = '#3a1a1a' })
    vim.api.nvim_set_hl(0, 'DiffText', { bg = '#2a4a2a' })
  end,
}
