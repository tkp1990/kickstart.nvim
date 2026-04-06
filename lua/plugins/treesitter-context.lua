return {
  'nvim-treesitter/nvim-treesitter-context',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    max_lines = 4,
    multiline_threshold = 20,
  },
  keys = {
    {
      '<leader>tc',
      function()
        require('treesitter-context').toggle()
      end,
      desc = '[T]oggle Treesitter [C]ontext',
    },
  },
}
