local function close_diffs_windows()
  local split = require 'diffs.split'
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_is_valid(win) then
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.api.nvim_buf_get_name(buf):match '^diffs://' then
        if not split.close_pair(buf) then
          pcall(vim.api.nvim_win_close, win, false)
        end
      end
    end
  end
end

-- The split layout opens two paired windows; turn them into two side-by-side
-- floating windows. Alignment is content-based padding and scrollbind is a
-- window option, so both keep working in floats.
local function floatify_split_pair()
  local wins = {}
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_buf_get_name(buf):match '^diffs://split:' then
      local ok, side = pcall(vim.api.nvim_buf_get_var, buf, 'diffs_split_side')
      wins[ok and side or 'left'] = win
    end
  end
  if not wins.left or not wins.right then
    return
  end

  local cols, lines = vim.o.columns, vim.o.lines
  local gap = 2
  local each = math.floor((cols - gap) * 0.45)
  local height = math.floor(lines * 0.85)
  local row = math.max(1, math.floor((lines - height) / 2))
  local left_col = math.max(0, math.floor((cols - each * 2 - gap) / 2))

  vim.api.nvim_win_set_config(wins.left, {
    relative = 'editor',
    width = each,
    height = height,
    row = row,
    col = left_col,
    border = 'rounded',
  })
  vim.api.nvim_win_set_config(wins.right, {
    relative = 'editor',
    width = each,
    height = height,
    row = row,
    col = left_col + each + gap,
    border = 'rounded',
  })
end

return {
  'barrettruth/diffs.nvim',
  lazy = false,
  init = function()
    vim.g.diffs = {
      integrations = {
        fugitive = true,
        gitsigns = true,
        telescope = true,
        difftastic = true,
      },
    }
  end,
  keys = {
    {
      '<leader>dD',
      function()
        close_diffs_windows()
        require('util-branch-picker').pick(function(branch)
          require('diffs.commands').diff_command('++layout=split ' .. branch, false)
          floatify_split_pair()
        end)
      end,
      desc = 'diff against branch (split, float)',
    },
  },
}
