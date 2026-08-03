return {
  'ahkohd/difft.nvim',
  keys = {
    {
      '<leader>dd',
      function()
        require('util-branch-picker').pick(function(branch)
          local file = vim.fn.shellescape(vim.fn.expand '%')
          Difft.diff { cmd = "GIT_EXTERNAL_DIFF='difft --color=always' git diff " .. branch .. ' -- ' .. file }
        end)
      end,
      desc = 'difft against branch',
    },
  },
  config = function()
    require('difft').setup {
      command = "GIT_EXTERNAL_DIFF='difft --color=always' git diff origin/main", -- or "jj diff --no-pager"
      layout = 'float', -- nil (buffer), "float", or "ivy_taller"
    }
  end,
}
