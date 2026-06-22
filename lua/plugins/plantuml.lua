return {
  'javiorfo/nvim-soil',

  -- Optional for puml syntax highlighting:
  dependencies = { 'javiorfo/nvim-nyctophilia' },

  lazy = true,
  enabled = false,
  ft = 'plantuml',
  config = function()
    require('soil').setup {
      actions = {
        redraw = false,
      },
      image = {
        darkmode = false, -- Enable or disable darkmode
        format = 'png', -- Choose between png or svg
        execute_to_open = function(img)
          return 'open -g -a Preview ' .. img
        end,
      },
    }

    -- Use BufWritten which fires after buffer is fully written
    vim.api.nvim_create_autocmd('BufWritePost', {
      pattern = { '*.puml', '*.plantuml', '*.pu' },
      callback = function()
        vim.schedule(function()
          vim.cmd 'silent! Soil'
        end)
      end,
      desc = 'Generate PlantUML diagram on save',
    })
  end,
}
