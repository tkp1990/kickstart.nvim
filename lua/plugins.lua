-- [[ Plugins via vim.pack ]]  See `:help vim.pack`
--   :lua vim.pack.update()            update everything (review buffer, :w to apply)
--   :lua vim.pack.del { 'name' }      remove a plugin after deleting it from the list below
-- Versions are pinned in nvim-pack-lock.json (commit it to reproduce installs).

-- Build steps, run after a plugin is installed or updated. Must exist before vim.pack.add.
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind, path = ev.data.spec.name, ev.data.kind, ev.data.path
    if kind ~= 'install' and kind ~= 'update' then return end

    local function run(cmd)
      local res = vim.system(cmd, { cwd = path }):wait()
      if res.code ~= 0 then vim.notify(name .. ': `' .. table.concat(cmd, ' ') .. '` failed\n' .. (res.stderr or ''), vim.log.levels.ERROR) end
    end

    if name == 'nvim-treesitter' then
      if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
      vim.cmd 'TSUpdate'
    elseif name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
      run { 'make' }
    elseif name == 'LuaSnip' and vim.fn.executable 'make' == 1 then
      run { 'make', 'install_jsregexp' }
    end
  end,
})

-- Must be set before rust.vim loads
vim.g.rustfmt_autosave = 0

local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add {
  -- Shared libraries
  gh 'nvim-lua/plenary.nvim',
  gh 'MunifTanjim/nui.nvim',
  gh 'nvim-tree/nvim-web-devicons',
  gh 'nvim-mini/mini.icons',

  -- UI
  gh 'rebelot/kanagawa.nvim',
  gh 'rcarriga/nvim-notify',
  gh 'folke/noice.nvim',
  gh 'goolord/alpha-nvim',
  gh 'nvim-lualine/lualine.nvim',
  gh 'SmiteshP/nvim-navic',
  gh 'folke/which-key.nvim',
  gh 'lukas-reineke/indent-blankline.nvim',
  gh 'folke/todo-comments.nvim',
  gh 'folke/trouble.nvim',
  { src = gh 'nvim-neo-tree/neo-tree.nvim', version = 'v3.x' },
  { src = gh 'akinsho/toggleterm.nvim', version = vim.version.range '*' },

  -- Editing
  gh 'tpope/vim-sleuth',
  gh 'numToStr/Comment.nvim',
  gh 'windwp/nvim-autopairs',
  gh 'folke/flash.nvim',

  -- Git
  gh 'tpope/vim-fugitive',
  gh 'tpope/vim-rhubarb',
  gh 'lewis6991/gitsigns.nvim',

  -- Telescope
  gh 'nvim-telescope/telescope.nvim',
  gh 'nvim-telescope/telescope-fzf-native.nvim',

  -- Treesitter
  { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' },
  { src = gh 'nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
  gh 'nvim-treesitter/nvim-treesitter-context',

  -- Completion
  gh 'hrsh7th/nvim-cmp',
  gh 'L3MON4D3/LuaSnip',
  gh 'saadparwaiz1/cmp_luasnip',
  gh 'hrsh7th/cmp-nvim-lsp',
  gh 'hrsh7th/cmp-path',
  gh 'hrsh7th/cmp-buffer',
  gh 'rafamadriz/friendly-snippets',

  -- LSP, formatting, linting
  gh 'mason-org/mason.nvim',
  gh 'mason-org/mason-lspconfig.nvim',
  gh 'neovim/nvim-lspconfig',
  gh 'j-hui/fidget.nvim',
  gh 'folke/lazydev.nvim',
  gh 'saecki/crates.nvim',
  gh 'rust-lang/rust.vim',
  gh 'stevearc/conform.nvim',
  gh 'mfussenegger/nvim-lint',

  -- Debugging
  gh 'mfussenegger/nvim-dap',
  gh 'rcarriga/nvim-dap-ui',
  gh 'nvim-neotest/nvim-nio',
  gh 'jay-babu/mason-nvim-dap.nvim',
  gh 'leoluz/nvim-dap-go',
}

-- [[ Configure plugins ]]  Order matters: theme first, then things others depend on.
require 'plugins.theme'
require('mini.icons').setup()
require('which-key').setup {}
require('Comment').setup {}

-- Adds git related signs to the gutter, as well as utilities for managing changes
-- See `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gs.nav_hunk 'next'
      end
    end, { desc = 'Jump to next hunk' })

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gs.nav_hunk 'prev'
      end
    end, { desc = 'Jump to previous hunk' })

    -- Actions
    -- visual mode
    map('v', '<leader>hs', function()
      gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'stage git hunk' })
    map('v', '<leader>hr', function()
      gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'reset git hunk' })
    -- normal mode
    map('n', '<leader>hs', gs.stage_hunk, { desc = 'git stage hunk' })
    map('n', '<leader>hr', gs.reset_hunk, { desc = 'git reset hunk' })
    map('n', '<leader>hS', gs.stage_buffer, { desc = 'git Stage buffer' })
    -- ponytail: undo_stage_hunk is deprecated; <leader>hs on a staged hunk unstages it
    map('n', '<leader>hR', gs.reset_buffer, { desc = 'git Reset buffer' })
    map('n', '<leader>hp', gs.preview_hunk, { desc = 'preview git hunk' })
    map('n', '<leader>hi', gs.preview_hunk_inline, { desc = 'preview git hunk inline' })
    map('n', '<leader>hb', function()
      gs.blame_line { full = false }
    end, { desc = 'git blame line' })
    map('n', '<leader>hd', gs.diffthis, { desc = 'git diff against index' })
    map('n', '<leader>hD', function()
      gs.diffthis '~'
    end, { desc = 'git diff against last commit' })
    map('n', '<leader>hq', gs.setqflist, { desc = 'git hunks to quickfix (file)' })
    map('n', '<leader>hQ', function()
      gs.setqflist 'all'
    end, { desc = 'git hunks to quickfix (repo)' })

    -- Toggles
    map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'toggle git blame line' })
    map('n', '<leader>tw', gs.toggle_word_diff, { desc = 'toggle git word diff' })

    -- Text object
    map({ 'o', 'x' }, 'ih', gs.select_hunk, { desc = 'select git hunk' })
  end,
}

require 'plugins.telescope'
require 'plugins.notify'
require 'plugins.alpha'
require 'plugins.lualine'
require 'plugins.navic'
require 'plugins.indent_line'
require 'plugins.todo-comments'
require 'plugins.trouble'
require 'plugins.neotree'
require 'plugins.toggleterm'
require 'plugins.flash'
require 'plugins.nvim-treesitter'
require 'plugins.treesitter-context'
require 'plugins.nvim-cmp'
require 'plugins.autopairs'
require 'plugins.nvim-lspconfig'
require 'plugins.conform'
require 'plugins.lint'
require 'plugins.debug'
