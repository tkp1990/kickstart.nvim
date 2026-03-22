return {
  'akinsho/toggleterm.nvim',
  version = "*",
  config = function()
    require("toggleterm").setup({
      -- Size can be a number or function
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      
      -- Open the terminal in a floating window
      -- Set to 'horizontal', 'vertical', or 'tab' for different layouts
      direction = 'float',
      
      -- Hide the numbers column in toggleterm buffers
      hide_numbers = true,
      
      -- Shade the terminal behind the floating window
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2, -- the degree by which to darken terminal colour (default: 1)
      
      -- Start in insert mode
      start_in_insert = true,
      
      -- behavior on terminal exit
      close_on_exit = true,
      
      -- shell to use
      shell = vim.o.shell,

      -- float window settings
      float_opts = {
        border = 'curved', -- 'single', 'double', 'shadow', 'curved'
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        }
      },
    })

    -- Key mappings
    local opts = {noremap = true, silent = true}
    
    -- Set keymap to toggle terminal visibility (Ctrl+\)
    vim.keymap.set({'n', 't'}, '<C-\\>', '<Cmd>ToggleTerm<CR>', opts)
    
    -- Set keymap to create a new terminal instance (Alt+t)
    vim.keymap.set('n', '<A-t>', '<Cmd>ToggleTerm direction=float<CR>', opts)
    
    -- Toggle different terminal layouts
    vim.keymap.set('n', '<leader>th', '<Cmd>ToggleTerm direction=horizontal<CR>', opts)
    vim.keymap.set('n', '<leader>tv', '<Cmd>ToggleTerm direction=vertical<CR>', opts)
    vim.keymap.set('n', '<leader>tf', '<Cmd>ToggleTerm direction=float<CR>', opts)

    local terminal_group = vim.api.nvim_create_augroup('ToggleTermKeymaps', { clear = true })
    vim.api.nvim_create_autocmd('TermOpen', {
      group = terminal_group,
      pattern = 'term://*',
      callback = function()
        local term_opts = { buffer = 0 }
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], term_opts)
        vim.keymap.set('t', 'jk', [[<C-\><C-n>]], term_opts)
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], term_opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], term_opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], term_opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], term_opts)
      end,
    })

    -- Function to create a terminal with a specific command
    local Terminal = require('toggleterm.terminal').Terminal

    -- Example of creating a lazygit terminal instance
    local lazygit = Terminal:new({
      cmd = "lazygit",
      hidden = true,
      direction = "float",
    })

    local function toggle_lazygit()
      lazygit:toggle()
    end

    -- Set keymap for lazygit
    vim.keymap.set('n', '<leader>lg', toggle_lazygit, opts)
  end
}
