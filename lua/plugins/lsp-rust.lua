return {
  'mrcjkb/rustaceanvim',
  version = '^6', -- Recommended
  lazy = false, -- This plugin is already lazy
  keys = {
    { '<leader>rc', '<cmd>RustLsp flyCheck<cr>', desc = 'flycheck' },
    { '<leader>rs', '<cmd>RustAnalyzer start<cr>', desc = 'LspStart' },
    { '<leader>rR', '<cmd>RustAnalyzer restart<cr>', desc = 'LspRestart' },
    { '<leader>rS', '<cmd>RustAnalyzer stop<cr>', desc = 'LspStop' },
    { '<leader>rr', '<cmd>RustLsp runnables<cr>', desc = 'Rust runables' },
    { '<leader>rt', '<cmd>RustLsp testables<cr>', desc = 'Rust tests' },
    { '<leader>rd', '<cmd>RustLsp debuggables<cr>', desc = 'Rust debuggables' },
  },
  config = function()
    vim.g.rustaceanvim = {
      -- Plugin configuration
      tools = {},
      -- LSP configuration
      server = {
        on_attach = function(client, bufnr)
          vim.keymap.set(
            'n',
            'K', -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
            function()
              vim.cmd.RustLsp { 'hover', 'actions' }
            end,
            { silent = true, buffer = bufnr }
          )
          -- you can also put keymaps in here
        end,

        default_settings = {
          -- rust-analyzer language server configuration
          ['rust-analyzer'] = {
            inlayHints = true,
            checkOnSave = true,
            cargo = {
              allFeatures = false,
              loadOutDirsFromCheck = true,
              runBuildScripts = false,
            },
            check = {
              command = 'check',
            },
            -- Add clippy lints for Rust.
            procMacro = {
              enable = true,
              -- ignored = {
              -- ["async-trait"] = { "async_trait" },
              -- ["napi-derive"] = { "napi" },
              -- ["async-recursion"] = { "async_recursion" },
              -- },
            },
          },
        },
      },
      -- DAP configuration
      dap = {},
    }
  end,
}
