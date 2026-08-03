return {
  'ldelossa/gh.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    {
      'ldelossa/litee.nvim',
      config = function()
        -- must match litee.gh's icon_set below: litee derives the tree's syntax
        -- highlights from *this* set, so a mismatch leaves gh icons uncoloured.
        require('litee.lib').setup {
          tree = {
            icon_set = 'codicons',
            -- litee defaults IndentGuide to U+23B8, which MesloLGS has no glyph
            -- for; it lands on every indent of every line. U+2502 is present.
            icon_set_custom = { IndentGuide = '│' },
          },
        }
      end,
    },
  },
  config = function()
    local gh_config = require 'litee.gh.config'

    require('litee.gh').setup {
      icon_set = 'codicons',
    }

    -- gh.nvim has no devicon support: every file node renders the same static
    -- "File" glyph. It also drops the additions/deletions the API already
    -- returned, showing the bare status word instead. Wrap the marshallers to
    -- fix both, leaving the viewed/notification icons the marshaller picked.
    local STATUS = { modified = 'M', added = 'A', removed = 'D', renamed = 'R', copied = 'C', changed = 'M' }
    local devicons = require 'nvim-web-devicons'
    local marshal = require 'litee.gh.pr.marshal'
    for _, fn in ipairs { 'marshal_pr_node', 'marshal_pr_file_node' } do
      local orig = marshal[fn]
      marshal[fn] = function(node)
        local name, detail, icon = orig(node)
        if node.file == nil then
          return name, detail, icon
        end
        if icon == gh_config.icon_set['File'] then
          icon = devicons.get_icon(name, vim.fn.fnamemodify(name, ':e'), { default = true })
        end
        local f = node.file
        local add, del = f['additions'], f['deletions']
        if type(add) == 'number' and type(del) == 'number' then
          detail = string.format('%s  +%d −%d', STATUS[f['status']] or '?', add, del)
        end
        return name, detail, icon
      end
    end

    -- gh.nvim emits one node per path component, so a deep file shows up as
    -- crates > outlayer > seed-injection > src. Merge single-child directory
    -- chains into one node the way diffview's file panel does.
    local files_changed = require 'litee.gh.pr.files_changed'
    local build_files_changed_tree = files_changed.build_files_changed_tree
    files_changed.build_files_changed_tree = function(files, depth, prev_tree)
      local root = build_files_changed_tree(files, depth, prev_tree)

      local function collapse(n)
        while n.changed_file_dir and #n.children == 1 and n.children[1].changed_file_dir do
          local c = n.children[1]
          n.details.name = n.details.name .. '/' .. c.details.name
          -- adopt the deepest dir's identity: its children are now ours
          n.key, n.name, n.children, n.expanded = c.key, c.name, c.children, c.expanded
        end
        for _, c in ipairs(n.children) do
          collapse(c)
        end
      end
      collapse(root)

      -- litee rebuilds depth_table from each node's own depth field, and
      -- add_node only re-stamps top-level children, so re-stamp the subtree.
      local function redepth(n, d)
        n.depth = d
        for _, c in ipairs(n.children) do
          redepth(c, d + 1)
        end
      end
      redepth(root, depth)

      -- build() matched previous expand state by (depth, key), but collapsing
      -- moves nodes to shallower depths so those lookups miss. Re-apply it by
      -- key alone, which is stable across a refresh.
      if prev_tree ~= nil and prev_tree.depth_table ~= nil then
        local was_expanded = {}
        for _, nodes in pairs(prev_tree.depth_table) do
          for _, n in ipairs(nodes) do
            if n.changed_file_dir then
              was_expanded[n.key] = n.expanded
            end
          end
        end
        local function restore(n)
          if n.changed_file_dir and was_expanded[n.key] ~= nil then
            n.expanded = was_expanded[n.key]
          end
          for _, c in ipairs(n.children) do
            restore(c)
          end
        end
        restore(root)
      end

      return root
    end

    -- litee hardcodes LTSymbol to a flat #87afd7 and applies it to every \w in
    -- the panel, and leaves 13 of the groups its icon_hls table references
    -- undefined entirely. Link them all to theme groups so the panel follows
    -- the colourscheme instead of looking monotone.
    local function style()
      local link = {
        LTSymbol = 'Normal', -- was the flat blue over all word chars
        LTSymbolDetail = 'Comment',
        LTIndentGuide = 'Comment',
        LTExpandedGuide = 'Comment',
        LTCollapsedGuide = 'Comment',
        LTDefault = 'NonText',
        LTGitPullRequest = 'Added',
        LTGitCommit = 'Special',
        LTGitBranch = 'Constant',
        LTGitCompare = 'Function',
        LTDiffAdded = 'Added',
        LTSuccess = 'DiagnosticOk',
        LTFailure = 'DiagnosticError',
        LTWarning = 'DiagnosticWarn',
        LTInfo = 'DiagnosticInfo',
        LTComment = 'Function',
        LTMultiComment = 'Function',
        LTAccount = 'Identifier',
        LTURI = 'Directory',
      }
      for from, to in pairs(link) do
        vim.api.nvim_set_hl(0, from, { link = to })
      end
    end
    style()
    vim.api.nvim_create_autocmd('ColorScheme', { callback = style })

    -- litee colours tree icons with `syn match`, so devicon glyphs need their
    -- own rules or they render in the default panel colour. Hook the same call
    -- litee makes from post_window_create: it runs with the panel window
    -- focused, which is what `:syn` needs.
    local lib_win = require 'litee.lib.util.window'
    local set_tree_highlights = lib_win.set_tree_highlights
    lib_win.set_tree_highlights = function()
      set_tree_highlights()
      if vim.bo.filetype ~= 'pr' or vim.b.gh_devicon_hl then
        return
      end
      vim.b.gh_devicon_hl = true
      local seen = {}
      for _, i in pairs(devicons.get_icons()) do
        if i.name ~= nil and not seen[i.icon] then
          seen[i.icon] = true
          vim.cmd(string.format('syn match DevIcon%s /%s/', i.name, i.icon))
        end
      end
    end
  end,
}
