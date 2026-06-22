return {
  'mateuszaaa/claudecode.nvim',
  dependencies = { 'folke/snacks.nvim' },
  config = function()
    require('claudecode').setup {
      terminal = {
        provider = 'none',
      },
    }

    -- Global terminal mode window navigation (works in any terminal including Claude)
    vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]], { desc = 'Go to left window' })
    vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]], { desc = 'Go to lower window' })
    vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]], { desc = 'Go to upper window' })
    vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]], { desc = 'Go to right window' })
  end,
  keys = {
    { '<leader>a', nil, desc = 'AI/Claude Code' },
    { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
    { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
    { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
    { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
    { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Claude model' },
    { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
    {
      '<leader>as',
      '<cmd>ClaudeCodeTreeAdd<cr>',
      desc = 'Add file',
      ft = { 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw' },
    },
    -- Diff management
    { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
    { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
  },
}
