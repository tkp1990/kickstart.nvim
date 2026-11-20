require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    local disable_filetypes = {
      c = true,
      cpp = true,
    }

    return {
      timeout_ms = 500,
      lsp_format = disable_filetypes[vim.bo[bufnr].filetype] and 'never' or 'fallback',
    }
  end,
  formatters_by_ft = {
    lua = { 'stylua' },
    rust = { 'rustfmt' },
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>cf', function()
  require('conform').format { async = true, lsp_format = 'fallback' }
end, { desc = '[C]ode [F]ormat' })
