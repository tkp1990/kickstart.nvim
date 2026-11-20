require('trouble').setup {}

local function toggle(mode)
  return function() require('trouble').toggle(mode) end
end
vim.keymap.set('n', '<leader>xx', toggle 'diagnostics', { desc = 'Trouble Diagnostics' })
vim.keymap.set('n', '<leader>xX', toggle 'buf_diagnostics', { desc = 'Trouble Buffer Diagnostics' })
vim.keymap.set('n', '<leader>xs', toggle 'symbols', { desc = 'Trouble Symbols' })
vim.keymap.set('n', '<leader>xl', toggle 'loclist', { desc = 'Trouble Location List' })
vim.keymap.set('n', '<leader>xq', toggle 'qflist', { desc = 'Trouble Quickfix List' })
vim.keymap.set('n', 'gR', toggle 'lsp_references', { desc = 'Trouble References' })
