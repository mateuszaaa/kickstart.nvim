return {
  -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    -- Mason must be loaded before its dependents so we need to set it up here.
    -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
    { 'mason-org/mason.nvim', opts = {} },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Useful status updates for LSP.
    { 'j-hui/fidget.nvim', opts = {} },

    -- Allows extra capabilities provided by blink.cmp
    'saghen/blink.cmp',
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        -- NOTE: Remember that Lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself.
        vim.diagnostic.config {
          signs = true,
          underline = false,
          update_in_insert = false,
          severity_sort = true,
          virtual_lines = { current_line = true, severity = { min = 'ERROR' } },
          virtual_text = {
            prefix = '●', -- or '■', '▶', etc.
            spacing = 2,
            current_line = false,
            severity = { min = 'ERROR' },
          },
        }

        if vim.lsp.inlay_hint then
          vim.lsp.inlay_hint.enable(true)
        end

        local signs = { Error = '', Warn = '', Hint = '', Info = '' }
        for type, icon in pairs(signs) do
          local hl = 'DiagnosticSign' .. type
          vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end

        local opts = { noremap = true, silent = true, buffer = event.buf }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<leader>cq', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
        vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Show diagnostic in float' })

        vim.keymap.set('n', '<leader>cf', function()
          vim.lsp.buf.format { async = true }
        end, opts)

        vim.keymap.set('n', '<leader>th', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
        end, opts)
      end,
    })

    -- vim.diagnostic.config {
    --   severity_sort = true,
    --   float = { border = 'rounded', source = 'if_many' },
    --   underline = { severity = vim.diagnostic.severity.ERROR },
    --   signs = vim.g.have_nerd_font and {
    --     text = {
    --       [vim.diagnostic.severity.ERROR] = '󰅚 ',
    --       [vim.diagnostic.severity.WARN] = '󰀪 ',
    --       [vim.diagnostic.severity.INFO] = '󰋽 ',
    --       [vim.diagnostic.severity.HINT] = '󰌶 ',
    --     },
    --   } or {},
    --   virtual_text = {
    --     source = 'if_many',
    --     spacing = 2,
    --     format = function(diagnostic)
    --       local diagnostic_message = {
    --         [vim.diagnostic.severity.ERROR] = diagnostic.message,
    --         [vim.diagnostic.severity.WARN] = diagnostic.message,
    --         [vim.diagnostic.severity.INFO] = diagnostic.message,
    --         [vim.diagnostic.severity.HINT] = diagnostic.message,
    --       }
    --       return diagnostic_message[diagnostic.severity]
    --     end,
    --   },
    -- }

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP specification.
    --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    local servers = {
      -- rust-analyzer is autoconfigured by rustceans.nvim plugin
      -- rust_analyzer = {},
      lua_ls = {
        -- cmd = { ... },
        -- filetypes = { ... },
        -- capabilities = {},
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
    }

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua', -- Used to format Lua code
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }
    require('mason-lspconfig').setup {
      ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
      automatic_installation = false,
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for ts_ls)
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
  end,
}
