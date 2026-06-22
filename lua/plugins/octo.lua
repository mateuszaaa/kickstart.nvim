return {
  'pwntester/octo.nvim',
  enabled = true,

  dependencies = {
    'nvim-lua/plenary.nvim',
    'ibhagwan/fzf-lua', -- lighter than telescope, needed for octo pickers (e.g. pending_threads)
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('octo').setup {
      picker = 'fzf-lua',
      use_local_fs = true, --
      ssh_aliases = { ['defuse-github.com'] = 'github.com' },
    }
    -- Patch octo notify to guard against nil msg (fixes nvim_echo invalid chunk error)
    local notify = require('octo.notify')
    notify.notify = function(msg, level)
      if msg == nil then return end
      vim.notify(tostring(msg), level or vim.log.levels.INFO)
    end
  end,
}
