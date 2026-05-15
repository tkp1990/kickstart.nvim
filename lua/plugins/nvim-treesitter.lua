local ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'vimdoc', 'vim', 'bash' }

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local ts = require('nvim-treesitter')

      local function is_installed(lang)
        if type(ts.get_installed) ~= 'function' then return true end
        local ok, list = pcall(ts.get_installed)
        if not ok or type(list) ~= 'table' then return true end
        return vim.list_contains(list, lang)
      end

      vim.api.nvim_create_autocmd('FileType', {
        pattern = ensure_installed,
        callback = function(args)
          local lang = args.match
          if not is_installed(lang) and type(ts.install) == 'function' then
            pcall(ts.install, { lang })
          end
          pcall(vim.treesitter.start)
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local ok_s, select = pcall(require, 'nvim-treesitter-textobjects.select')
      local ok_m, move = pcall(require, 'nvim-treesitter-textobjects.move')
      local ok_w, swap = pcall(require, 'nvim-treesitter-textobjects.swap')
      if not (ok_s and ok_m and ok_w) then
        vim.notify('nvim-treesitter-textobjects: main-branch modules not available; run :Lazy update', vim.log.levels.WARN)
        return
      end

      local select_map = {
        aa = '@parameter.outer',
        ia = '@parameter.inner',
        af = '@function.outer',
        ['if'] = '@function.inner',
        ac = '@class.outer',
        ic = '@class.inner',
      }
      for lhs, capture in pairs(select_map) do
        vim.keymap.set({ 'x', 'o' }, lhs, function()
          select.select_textobject(capture, 'textobjects')
        end, { desc = 'Select ' .. capture })
      end

      local move_modes = { 'n', 'x', 'o' }
      local function map_move(lhs, fn, capture)
        vim.keymap.set(move_modes, lhs, function()
          fn(capture, 'textobjects')
        end, { desc = capture })
      end
      map_move(']m', move.goto_next_start, '@function.outer')
      map_move(']]', move.goto_next_start, '@class.outer')
      map_move(']M', move.goto_next_end, '@function.outer')
      map_move('][', move.goto_next_end, '@class.outer')
      map_move('[m', move.goto_previous_start, '@function.outer')
      map_move('[[', move.goto_previous_start, '@class.outer')
      map_move('[M', move.goto_previous_end, '@function.outer')
      map_move('[]', move.goto_previous_end, '@class.outer')

      vim.keymap.set('n', '<leader>a', function()
        swap.swap_next('@parameter.inner')
      end, { desc = 'Swap parameter next' })
      vim.keymap.set('n', '<leader>A', function()
        swap.swap_previous('@parameter.inner')
      end, { desc = 'Swap parameter previous' })
    end,
  },
}
