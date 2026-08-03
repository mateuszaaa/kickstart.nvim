return {
  'dlyongemallo/diffview-plus.nvim',
  version = '*',
  config = function()
    require('diffview').setup {
      enhanced_diff_hl = true, -- word-level highlighting within changed lines
      diff_binaries = false, -- skip binary files (keeps the view clean)
      watch_index = true, -- auto-refresh when git index changes
      view = {
        cycle_layouts = {
          default = { 'diff2_horizontal', 'diff1_inline' },
        },
      },
    }
  end,
}
