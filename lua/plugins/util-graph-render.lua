return {
  enabled = false,
  '3rd/diagram.nvim',
  dependencies = {
    {
      '3rd/image.nvim',
      opts = {
        scale_factor = 5,
        width = 2048,
        height = 2048,
      },
    }, -- you'd probably want to configure image.nvim manually instead of doing this
  },
  opts = { -- you can just pass {}, defaults below
    events = {
      -- render_buffer = { 'InsertLeave', 'BufWinEnter', 'TextChanged' },
      render_buffer = { 'BufWritePost' },
      clear_buffer = { 'BufLeave' },
    },
    renderer_options = {
      mermaid = {
        background = nil, -- nil | "transparent" | "white" | "#hex"
        theme = nil, -- nil | "default" | "dark" | "forest" | "neutral"
        scale = nil, -- nil | 1 (default) | 2  | 3 | ...
        width = nil, -- nil | 800 | 400 | ...
        height = nil, -- nil | 600 | 300 | ...
        cli_args = nil, -- nil | { "--no-sandbox" } | { "-p", "/path/to/puppeteer" } | ...
      },
      plantuml = {
        charset = nil,
        cli_args = nil, -- nil | { "-Djava.awt.headless=true" } | ...
      },
    },
  },
}
