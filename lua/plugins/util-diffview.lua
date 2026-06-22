return {
  'sindrets/diffview.nvim',
  config = function()
    require('diffview').setup {
      enhanced_diff_hl = true, -- word-level highlighting within changed lines
      diff_binaries = false, -- skip binary files (keeps the view clean)
      watch_index = true, -- auto-refresh when git index changes
    }
  end,
}
