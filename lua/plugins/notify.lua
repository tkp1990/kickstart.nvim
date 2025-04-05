return {
  {
    "rcarriga/nvim-notify",
    lazy = false,
    priority = 1000, -- Load early
    keys = {
      {
        "<leader>nd",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all notifications",
      },
    },
    opts = {
      timeout = 3000,
      max_width = 80,
      max_height = 20,
      stages = "fade", -- Animation style (fade, slide, static)
      render = "default",
      background_colour = "#000000",
      icons = {
        ERROR = "",
        WARN = "",
        INFO = "",
        DEBUG = "",
        TRACE = "✎",
      },
    },
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)

      -- Set as default notify function
      vim.notify = notify

      -- Add telescope integration
      local telescope_loaded, telescope = pcall(require, "telescope")
      if telescope_loaded then
        telescope.load_extension("notify")
        -- Add keybinding to view notification history
        vim.keymap.set("n", "<leader>nh", function()
          require("telescope").extensions.notify.notify()
        end, { desc = "View notification history" })
      end
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    keys = {
      {
        "<leader>nl",
        function()
          require("noice").cmd("last")
        end,
        desc = "Noice Last Message",
      },
      {
        "<leader>na",
        function()
          require("noice").cmd("all")
        end,
        desc = "Noice All",
      },
      {
        "<leader>nh",
        function()
          require("noice").cmd("history")
        end,
        desc = "Noice History",
      },
      {
        "<leader>nT",
        function()
          require("noice").cmd("telescope")
        end,
        desc = "Noice Telescope",
      },
      {
        "<c-f>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<c-f>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll forward",
        mode = {"i", "n", "s"}
      },
      {
        "<c-b>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<c-b>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll backward",
        mode = {"i", "n", "s"}
      },
    },
    config = function()
      require("noice").setup({
        -- cmdline = {
        --   enabled = true,
        --   view = "cmdline_popup",
        --   opts = {
        --     position = {
        --       row = 5,
        --       col = "50%",
        --     },
        --     size = {
        --       width = "50%",
        --       height = "auto",
        --     },
        --   },
        --   format = {
        --     cmdline = { pattern = "^:", icon = "", lang = "vim" },
        --     search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
        --     search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
        --     filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
        --     lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
        --     help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
        --     input = {},
        --   },
        -- },
        cmdline = {
          format = {
            search_down = {
              view = "cmdline",
            },
            search_up = {
              view = "cmdline",
            },
          },
        },
        messages = {
          enabled = true,
          view = "notify",
          view_error = "notify",
          view_warn = "notify",
          view_history = "messages",
          view_search = "virtualtext",
        },
        -- popupmenu = {
        --   enabled = true,
        --   backend = "nui",
        --   kind_icons = {},
        -- },
        views = {
          cmdline_popup = {
            position = {
              row = "50%",
              col = "50%",
            },
            size = {
              width = "55%",
              min_width = 40,
              height = "auto",
            },
            -- border = {
            --   style = "none",
            --   padding = { 2, 3 },
            -- },
            -- filter_options = {},
            -- win_options = {
            --   winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
            -- },
          },
          popupmenu = {
            relative = "editor",
            position = {
              row = "60%",
              col = "50%",
            },
            size = {
              width = "55%",
              height = 10,
              -- max_height = 12,
              -- max_width = 80,
            },
            border = {
              style = "rounded",
              padding = { 0, 1 },
            },
            win_options = {
              -- winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
              winhighlight = {
                Normal = "Normal",
                FloatBorder = "DiagnosticInfo",
                CursorLine = "NoicePopupmenuSelected",
                Search = "NoicePopupmenuMatch"
              },
              -- cursorline = true,
            },
          },
        },
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
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
      })
    end,
  }
}
