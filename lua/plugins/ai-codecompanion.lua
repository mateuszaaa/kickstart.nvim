return {
  'olimorris/codecompanion.nvim',
  -- config = true,
  config = function()
    require('codecompanion').setup {
      strategies = {
        chat = {
          adapter = 'openai',
        },
        inline = {
          adapter = 'openai',
        },
        cmd = {
          adapter = 'openai',
        },
      },
      adapters = {
        openai = function()
          return require('codecompanion.adapters').extend('openai', {
            schema = {
              model = {
                default = 'gpt-4o',
              },
            },
          })
        end,
      },
    }
  end,
  keys = {
    { '<leader>ac', '<cmd>CodeCompanionChat Toggle<cr>', desc = 'AI prompts' },
    { '<leader>ac', ':CodeCompanion<cr>', mode = 'v', desc = 'AI prompts' },
    { '<leader>ac', ':CodeCompanion<cr>', desc = 'AI prompts' },
    { '<leader>aa', ':CodeCompanionAction<cr>', desc = 'AI actions' },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
}
