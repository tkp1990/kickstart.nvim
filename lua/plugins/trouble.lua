return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  cmd = 'Trouble',
  keys = {
    {
      '<leader>xx',
      function()
        require('trouble').toggle 'diagnostics'
      end,
      desc = 'Trouble Diagnostics',
    },
    {
      '<leader>xX',
      function()
        require('trouble').toggle 'buf_diagnostics'
      end,
      desc = 'Trouble Buffer Diagnostics',
    },
    {
      '<leader>xs',
      function()
        require('trouble').toggle 'symbols'
      end,
      desc = 'Trouble Symbols',
    },
    {
      '<leader>xl',
      function()
        require('trouble').toggle 'loclist'
      end,
      desc = 'Trouble Location List',
    },
    {
      '<leader>xq',
      function()
        require('trouble').toggle 'qflist'
      end,
      desc = 'Trouble Quickfix List',
    },
    {
      'gR',
      function()
        require('trouble').toggle 'lsp_references'
      end,
      desc = 'Trouble References',
    },
  },
  opts = {},
}
