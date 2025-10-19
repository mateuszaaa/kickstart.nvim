return {
  'Exafunction/codeium.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'hrsh7th/nvim-cmp',
  },
  config = function()
    require('codeium').setup {
      virtual_text = {
        enabled = true,
        manual = false,
        idle_delay = 75,
        virtual_text_priority = 65535,
        map_keys = true,
        accept_key = '<Tab>',
        next_key = '<M-]>',
        prev_key = '<M-[>',
        clear_key = '<C-]>',
      },
    }
  end,
}
