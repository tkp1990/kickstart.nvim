local notify = require 'notify'
notify.setup {
  timeout = 3000,
  max_width = 80,
  max_height = 20,
  stages = 'fade', -- Animation style (fade, slide, static)
  render = 'default',
  background_colour = '#000000',
  icons = {
    ERROR = '',
    WARN = '',
    INFO = '',
    DEBUG = '',
    TRACE = '✎',
  },
}

-- Set as default notify function
vim.notify = notify

vim.keymap.set('n', '<leader>nd', function()
  notify.dismiss { silent = true, pending = true }
end, { desc = 'Dismiss all notifications' })

-- Telescope integration
require('telescope').load_extension 'notify'
vim.keymap.set('n', '<leader>nn', function()
  require('telescope').extensions.notify.notify()
end, { desc = 'Notify History' })

require('noice').setup {
  cmdline = {
    format = {
      search_down = {
        view = 'cmdline',
      },
      search_up = {
        view = 'cmdline',
      },
    },
  },
  messages = {
    enabled = true,
    view = 'notify',
    view_error = 'notify',
    view_warn = 'notify',
    view_history = 'messages',
    view_search = 'virtualtext',
  },
  views = {
    cmdline_popup = {
      position = {
        row = '50%',
        col = '50%',
      },
      size = {
        width = '55%',
        min_width = 40,
        height = 'auto',
      },
    },
    popupmenu = {
      relative = 'editor',
      position = {
        row = '60%',
        col = '50%',
      },
      size = {
        width = '55%',
        height = 10,
      },
      border = {
        style = 'rounded',
        padding = { 0, 1 },
      },
      win_options = {
        winhighlight = {
          Normal = 'Normal',
          FloatBorder = 'DiagnosticInfo',
          CursorLine = 'NoicePopupmenuSelected',
          Search = 'NoicePopupmenuMatch',
        },
      },
    },
  },
  lsp = {
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true,
    },
    hover = {
      enabled = true,
    },
    signature = {
      enabled = true,
    },
  },
  presets = {
    bottom_search = false,
    command_palette = false,
    long_message_to_split = false,
    inc_rename = false,
    lsp_doc_border = false,
  },
}

local function noice_cmd(cmd)
  return function() require('noice').cmd(cmd) end
end
vim.keymap.set('n', '<leader>nl', noice_cmd 'last', { desc = 'Noice Last Message' })
vim.keymap.set('n', '<leader>na', noice_cmd 'all', { desc = 'Noice All' })
vim.keymap.set('n', '<leader>nh', noice_cmd 'history', { desc = 'Noice History' })
vim.keymap.set('n', '<leader>nT', noice_cmd 'telescope', { desc = 'Noice Telescope' })

vim.keymap.set({ 'i', 'n', 's' }, '<c-f>', function()
  if not require('noice.lsp').scroll(4) then
    return '<c-f>'
  end
end, { silent = true, expr = true, desc = 'Scroll forward' })
vim.keymap.set({ 'i', 'n', 's' }, '<c-b>', function()
  if not require('noice.lsp').scroll(-4) then
    return '<c-b>'
  end
end, { silent = true, expr = true, desc = 'Scroll backward' })
