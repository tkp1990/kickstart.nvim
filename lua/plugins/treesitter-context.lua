require('treesitter-context').setup {
  max_lines = 4,
  multiline_threshold = 20,
}

vim.keymap.set('n', '<leader>tc', function()
  require('treesitter-context').toggle()
end, { desc = '[T]oggle Treesitter [C]ontext' })
