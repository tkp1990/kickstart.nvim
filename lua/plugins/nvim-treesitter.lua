local ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'vimdoc', 'vim', 'bash' }

local ts = require 'nvim-treesitter'
ts.install(ensure_installed) -- async, no-op for parsers already installed

local function try_attach(buf, lang)
  -- Buffer may be gone by the time an async install finishes
  if not vim.api.nvim_buf_is_valid(buf) then return end
  if not vim.treesitter.language.add(lang) then return end
  vim.treesitter.start(buf, lang)
  -- Only use treesitter indent when the language has an indent query
  if vim.treesitter.query.get(lang, 'indents') then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local buf = args.buf
    local lang = vim.treesitter.language.get_lang(args.match)
    if not lang then return end

    if vim.list_contains(ensure_installed, lang) and not vim.list_contains(ts.get_installed 'parsers', lang) then
      ts.install(lang):await(function() try_attach(buf, lang) end)
    else
      -- Attaches if a parser exists (installed or bundled with nvim), otherwise no-op
      try_attach(buf, lang)
    end
  end,
})

-- [[ nvim-treesitter-textobjects ]]
local select = require 'nvim-treesitter-textobjects.select'
local move = require 'nvim-treesitter-textobjects.move'
local swap = require 'nvim-treesitter-textobjects.swap'

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
  swap.swap_next '@parameter.inner'
end, { desc = 'Swap parameter next' })
vim.keymap.set('n', '<leader>A', function()
  swap.swap_previous '@parameter.inner'
end, { desc = 'Swap parameter previous' })
