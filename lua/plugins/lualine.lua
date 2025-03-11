-- return {
--   -- Set lualine as statusline
--   'nvim-lualine/lualine.nvim',
--   -- See `:help lualine.txt`
--   opts = {
--     options = {
--       icons_enabled = false,
--       theme = 'onedark',
--       component_separators = '|',
--       section_separators = '',
--     },
--   },
-- }

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local lualine = require('lualine')

    -- Get current theme
    local function get_theme()
      return "horizon"
    end

    -- Helper function to determine window width
    local function has_width_gt(cols)
      -- Check if the current window width is greater than a given number of columns
      return vim.fn.winwidth(0) / 2 > cols
    end

    -- Custom components
    local filename = {
      'filename',
      path = 1, -- Show relative path
      file_status = true, -- Show file status (readonly, modified)
      shorting_target = 40, -- Shorten path if wider than window
      symbols = {
        modified = ' ●', -- Text to show when file is modified
        readonly = ' 󰈡', -- Text to show when file is readonly
        unnamed = '[No Name]', -- Text to show for unnamed buffers
        newfile = '[New]', -- Text to show for newly created file
      }
    }

    local filesize = {
      function()
        local function format_file_size(file)
          local size = vim.fn.getfsize(file)
          if size <= 0 then return "" end
          local sufixes = {'B', 'KB', 'MB', 'GB'}
          local i = 1
          while size > 1024 and i < #sufixes do
            size = size / 1024
            i = i + 1
          end
          return string.format('%.1f%s', size, sufixes[i])
        end
        return format_file_size(vim.fn.expand('%:p'))
      end,
      cond = function() 
        -- Show file size only if file exists and window is wide enough
        return vim.fn.empty(vim.fn.expand('%:t')) ~= 1 and has_width_gt(80)
      end
    }

    local encoding = {
      'encoding',
      fmt = function(str)
        return string.upper(str)
      end,
      cond = function() return has_width_gt(70) end -- Only show encoding when enough space
    }

    local filetype = {
      'filetype',
      icon_only = function() return not has_width_gt(70) end, -- Icon only in smaller windows
      colored = true,
    }

    -- local fileformat = {
    --   'fileformat',
    --   symbols = {
    --     unix = '󰣇 LF', -- e712
    --     dos = '󰨡 CRLF', -- eaa1
    --     mac = '󰀶 CR', -- f036
    --   },
    --   cond = function() return has_width_gt(60) end -- Only show file format when enough space
    -- }
    --
    -- local diagnostics = {
    --   'diagnostics',
    --   sources = {'nvim_diagnostic'},
    --   sections = {'error', 'warn', 'info', 'hint'},
    --   diagnostics_color = {
    --     error = { fg = '#FF5370' }, -- Horizon light red
    --     warn = { fg = '#F78C6C' },  -- Horizon light orange
    --     info = { fg = '#56C2EA' },  -- Horizon light cyan
    --     hint = { fg = '#2EC4B6' },  -- Horizon light green
    --   },
    --   symbols = {error = ' ', warn = ' ', info = ' ', hint = ' '},
    --   colored = true,
    --   update_in_insert = false,
    --   always_visible = false,
    -- }

    local branch = {
      'branch',
      icon = '󰘬',
      cond = function() return has_width_gt(50) end -- Hide branch name in very small windows
    }

    -- local diff = {
    --   'diff',
    --   colored = true,
    --   symbols = {added = ' ', modified = '󰝤 ', removed = ' '},
    --   diff_color = {
    --     added = { fg = '#2EC4B6' },    -- Horizon light green
    --     modified = { fg = '#56C2EA' }, -- Horizon light cyan
    --     removed = { fg = '#FF5370' },  -- Horizon light red
    --   },
    --   cond = function() return has_width_gt(80) end -- Only show diff when enough space
    -- }

    local location = {
      'location',
      padding = 0,
    }

    local progress = {
      'progress',
      padding = 1,
    }

    -- Show current function/method name
    local navic = {
      function()
        if not package.loaded['nvim-navic'] then
          return ""
        end
        return require('nvim-navic').get_location()
      end,
      cond = function()
        if not package.loaded['nvim-navic'] then
          return false
        end
        -- Only show navic when window is wide enough
        return require('nvim-navic').is_available() and has_width_gt(100)
      end
    }

    -- LSP clients attached to buffer
    local lsp_server = {
      function()
        local buf_clients = vim.lsp.get_active_clients { bufnr = 0 }
        if #buf_clients == 0 then
          return "No LSP"
        end

        local buf_client_names = {}
        for _, client in pairs(buf_clients) do
          table.insert(buf_client_names, client.name)
        end
        return " " .. table.concat(buf_client_names, ", ")
      end,
      cond = function() return has_width_gt(90) end -- Only show LSP info when enough space
    }

    -- Treesitter status
    local treesitter = {
      function()
        if not package.loaded['nvim-treesitter'] then
          return ""
        end
        local highlighter = require('vim.treesitter.highlighter')
        local has_ts = highlighter.active[vim.api.nvim_get_current_buf()]
        if has_ts then
          return "󰒥"
        else
          return ""
        end
      end,
      color = { fg = '#2EC4B6' }, -- Horizon light green
      cond = function() return has_width_gt(60) end -- Only show treesitter status when enough space
    }

    -- Directory structure
    local dir = {
      function()
        local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
        if dir_name:find("^~") then
          dir_name = dir_name:gsub("^~", " ~")
        end
        -- Shorten directory path if window isn't wide enough
        if not has_width_gt(80) then
          local path_parts = vim.split(dir_name, "/")
          if #path_parts > 2 then
            local shortened = "…/" .. table.concat({path_parts[#path_parts-1], path_parts[#path_parts]}, "/")
            return shortened
          end
        end
        return dir_name
      end,
      icon = '󰉋',
      color = { gui = 'bold' }
    }

    -- Mode with text and icon
    local mode = {
      function()
        local mode_map = {
          n = 'NORMAL',
          i = 'INSERT',
          v = 'VISUAL',
          [''] = 'V-BLOCK',
          V = 'V-LINE',
          c = 'COMMAND',
          no = 'O-PENDING',
          s = 'SELECT',
          S = 'S-LINE',
          -- [''] = 'S-BLOCK',
          ic = 'I-COMPL',
          R = 'REPLACE',
          Rv = 'V-REPLACE',
          cv = 'EX',
          ce = 'NORMAL EX',
          r = 'PROMPT',
          rm = 'MORE',
          ['r?'] = 'CONFIRM',
          ['!'] = 'SHELL',
          t = 'TERMINAL'
        }
        
        -- Mode icons
        local mode_icon = {
          n = '󰆾 ',       -- Normal
          i = '󰏫 ',       -- Insert
          v = '󰒉 ',       -- Visual
          [''] = '󱂩 ',   -- Visual Block
          V = '󰹺 ',       -- Visual Line
          c = '󰘳 ',       -- Command
          no = '󰰁 ',      -- Terminal Normal
          s = '󱓥 ',       -- Select
          S = '󰹻 ',       -- Select Line
          -- [''] = '󱁐 ',   -- Select Block
          ic = '󰏬 ',      -- Insert Completion
          R = '󰛔 ',       -- Replace
          Rv = '󰜷 ',      -- Virtual Replace
          cv = '󰮯 ',      -- Command Ex
          ce = '󰚩 ',      -- Command Normal Ex
          r = '󰇾 ',       -- Prompt
          rm = '󰤂 ',      -- More
          ['r?'] = '󰗠 ',  -- Confirm
          ['!'] = '󱣴 ',   -- Shell
          t = '󰆍 '        -- Terminal
        }
        
        local current_mode = vim.fn.mode()
        -- For small window, only show the icon
        if not has_width_gt(40) then
          return mode_icon[current_mode]
        end
        
        return mode_icon[current_mode] .. mode_map[current_mode]
      end,
      color = function()
        -- auto change color according to neovims mode
        local mode_color = {
          n = '#F02E6E',       -- Normal
          i = '#2EC4B6',       -- Insert
          v = '#A37ACC',       -- Visual
          [''] = '#A37ACC',   -- Visual Block
          V = '#A37ACC',       -- Visual Line
          c = '#F78C6C',       -- Command
          no = '#FF5370',      -- Terminal Normal
          s = '#56C2EA',       -- Select
          S = '#56C2EA',       -- Select Line
          -- [''] = '#56C2EA',   -- Select Block
          ic = '#FF9E64',      -- Insert Completion
          R = '#FF5370',       -- Replace
          Rv = '#FF5370',      -- Virtual Replace
          cv = '#F78C6C',      -- Command Ex
          ce = '#F78C6C',      -- Command Normal Ex
          r = '#A37ACC',       -- Prompt
          rm = '#A37ACC',      -- More
          ['r?'] = '#A37ACC',  -- Confirm
          ['!'] = '#F78C6C',   -- Shell
          t = '#56C2EA'        -- Terminal
        }
        return { fg = '#FDF0ED', bg = mode_color[vim.fn.mode()], gui = 'bold' }
      end,
      padding = { left = 1, right = 1 },
    }

    -- Get current time
    local time = {
      function()
        return os.date(" %H:%M ")
      end,
      icon = '󰥔',
      color = { fg = '#FDF0ED', bg = '#A37ACC', gui = 'bold' }, -- Bright text on purple background
      padding = { left = 1, right = 0 },
      cond = function() return has_width_gt(70) end -- Only show time when enough space
    }

    -- Configure lualine setup
    lualine.setup({
      options = {
        icons_enabled = true,
        theme = get_theme(),
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      },
      sections = {
        lualine_a = {mode},
        lualine_b = {branch, dir},
        -- lualine_c = {diff, diagnostics, filename, navic},
        lualine_c = {filename, navic},
        -- lualine_x = {filesize, encoding, fileformat, filetype, treesitter, lsp_server},
        lualine_x = {filesize, encoding, filetype, treesitter, lsp_server},
        lualine_y = {location, progress},
        lualine_z = {time}
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {'nvim-tree', 'toggleterm', 'quickfix', 'fugitive'}
    })

    -- Dynamic theme update based on Catppuccin changes
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        lualine.setup({
          options = {
            theme = get_theme(),
          }
        })
      end,
    })
  end,
}
