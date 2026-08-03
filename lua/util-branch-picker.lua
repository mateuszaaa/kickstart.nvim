local M = {}

local function build()
  local prev = vim.g.diff_prev_branch
  local current = vim.trim(vim.fn.system 'git branch --show-current')
  local list, seen = {}, {}
  local function add(name)
    if name and name ~= '' and not seen[name] then
      seen[name] = true
      list[#list + 1] = name
    end
  end

  add(prev)
  add 'HEAD'
  if current ~= '' then
    add('origin/' .. current)
  end
  add 'origin/main'
  add 'origin/master'
  for _, name in ipairs(vim.fn.systemlist 'git for-each-ref --format=%(refname:short) refs/heads refs/remotes') do
    if not name:match '^origin/HEAD' then
      add(name)
    end
  end

  return list, prev
end

---@param callback fun(branch: string)
function M.pick(callback)
  local list, prev = build()
  vim.ui.select(list, {
    prompt = 'Diff against:',
    format_item = function(item)
      return item == prev and (item .. '  (prev choice)') or item
    end,
  }, function(choice)
    if choice then
      vim.g.diff_prev_branch = choice
      callback(choice)
    end
  end)
end

return M
