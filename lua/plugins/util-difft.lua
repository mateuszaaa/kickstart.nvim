return {
  'ahkohd/difft.nvim',
  keys = {
    {
      '<leader>d',
      function()
        if Difft.is_visible() then
          Difft.hide()
        else
          local file = vim.fn.shellescape(vim.fn.expand('%'))
          Difft.diff({ cmd = "GIT_EXTERNAL_DIFF='difft --color=always' git diff origin/main -- " .. file })
        end
      end,
      desc = 'Toggle Difft against origin/main',
    },
    {
      '<leader>D',
      function()
        local rev = vim.fn.input('Branch/revision: ')
        if rev == '' then return end
        local file = vim.fn.shellescape(vim.fn.expand('%'))
        Difft.diff({ cmd = "GIT_EXTERNAL_DIFF='difft --color=always' git diff " .. rev .. ' -- ' .. file })
      end,
      desc = 'Difft current file against branch/revision',
    },
  },
  config = function()
    require('difft').setup {
      command = "GIT_EXTERNAL_DIFF='difft --color=always' git diff origin/main", -- or "jj diff --no-pager"
      layout = 'ivy_taller', -- nil (buffer), "float", or "ivy_taller"
    }
  end,
}
