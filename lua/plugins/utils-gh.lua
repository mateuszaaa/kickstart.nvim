return {
  'ldelossa/gh.nvim',
  dependencies = {
    {
      'ldelossa/litee.nvim',
      config = function()
        require('litee.lib').setup()
      end,
    },
  },
  config = function()
    require('litee.gh').setup {
      icon_set = 'nerd',
    }
  end,
}
