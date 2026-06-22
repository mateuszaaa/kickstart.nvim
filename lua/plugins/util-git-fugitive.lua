local function pick_branch(prompt, callback)
  local branches = vim.fn.systemlist 'git branch --format="%(refname:short)"'
  local current = vim.trim(vim.fn.system 'git branch --show-current')

  -- Build priority entries to insert at the top
  local priority = { 'HEAD' }

  -- Add origin/<current_branch> if it exists
  if current ~= '' then
    local remote_ref = 'origin/' .. current
    if vim.fn.system('git rev-parse --verify ' .. remote_ref .. ' 2>/dev/null') ~= '' then
      table.insert(priority, remote_ref)
    end
  end

  -- Add origin/main or origin/master if the local branch exists and isn't current
  for _, name in ipairs { 'main', 'master' } do
    if name ~= current and vim.tbl_contains(branches, name) then
      table.insert(priority, 'origin/' .. name)
      break
    end
  end

  -- Remove priority items from branches list to avoid duplicates, then prepend
  for i = #priority, 1, -1 do
    for j, b in ipairs(branches) do
      if b == priority[i] then
        table.remove(branches, j)
        break
      end
    end
    table.insert(branches, 1, priority[i])
  end

  vim.ui.select(branches, { prompt = prompt }, function(choice)
    if choice then
      callback(choice)
    end
  end)
end

return {
  'tpope/vim-fugitive',
  lazy = false,
  keys = {
    { '<leader>gg', '<cmd>Git<cr>', desc = 'git status' },
    {
      '<leader>gd',
      function()
        if vim.wo.diff then
          vim.cmd 'diffoff | only'
          return
        end
        pick_branch('Gvdiffsplit', function(branch)
          vim.cmd('Gvdiffsplit ' .. branch)
        end)
      end,
      desc = 'git diff (toggle)',
    },
    {
      '<leader>gD',
      function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == 'DiffviewFiles' then
            vim.cmd 'DiffviewClose'
            return
          end
        end
        pick_branch('DiffviewOpen', function(branch)
          vim.cmd('DiffviewOpen ' .. branch .. ' --imply-local')
        end)
      end,
      desc = 'diffview (toggle)',
    },
  },
}
