return {
  'olimorris/codecompanion.nvim',
  enabled = false,
  -- config = true,
  config = function()
    require('codecompanion').setup {
      strategies = {
        chat = {
          adapter = 'ollama',
        },
        inline = {
          adapter = 'ollama',
        },
        agent = {
          adapter = 'ollama',
        },
      },
      adapters = {
        -- acp = {
        --   claude_code = function()
        --     return require('codecompanion.adapters').extend('claude_code', {
        --       env = {
        --         CLAUDE_CODE_OAUTH_TOKEN = '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',
        --       },
        --     })
        --   end,
        -- },
        http = {
          ollama = function()
            return require('codecompanion.adapters').extend('openai_compatible', {
              env = {
                url = 'http://localhost:1234',
                api_key = 'lm-studio',
              },
            })
          end,
        },
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
