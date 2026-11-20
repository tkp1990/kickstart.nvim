--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================

Kickstart.nvim is *not* a distribution.

Kickstart.nvim is a template for your own configuration.
  The goal is that you can read every line of code, top-to-bottom, understand
  what your configuration is doing, and modify it to suit your needs.

  Once you've done that, you should start exploring, configuring and tinkering to
  explore Neovim!

  If you don't know anything about Lua, I recommend taking some time to read through
  a guide. One possible example:
  - https://learnxinyminutes.com/docs/lua/


  And then you can explore or search through `:help lua-guide`
  - https://neovim.io/doc/user/lua-guide.html


Kickstart Guide:

I have left several `:help X` comments throughout the init.lua
You should run that command and read that help section for more information.

In addition, I have some `NOTE:` items throughout the file.
These are for you, the reader to help understand what is happening. Feel free to delete
them once you know what you're doing, but they should serve as a guide for when you
are first encountering a few different constructs in your nvim config.

-- [[ Plugin manager: vim.pack, built into nvim 0.12. Plugins live in lua/plugins.lua ]]
vim.loader.enable() -- byte-compile cache for faster startup

require 'vim-options'
require 'plugins'

-- [[ Highlight on yank ]]
-- See `:help vim.hl.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.hl.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Replace your old leader key group definitions with this new format
require('which-key').add {
  -- Normal mode leader mappings
  { '<leader>s', group = '[S]earch' },
  { '<leader>c', group = '[C]ode' },
  { '<leader>d', group = '[D]ocument' },
  { '<leader>g', group = '[G]it' },
  -- { "<leader>h", group = "Git [H]unk" },
  { '<leader>w', group = '[W]orkspace' },
  { '<leader>t', group = '[T]oggle' },
  { '<leader>x', group = 'Diagnostics' },
  { '<leader>r', group = '[R]ename' },
  -- Visual mode leader mappings (separate registration)
  { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
  { '<leader>', group = 'VISUAL <leader>', mode = 'v' },
}
