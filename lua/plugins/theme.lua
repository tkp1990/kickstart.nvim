-- One Dark Theme for NeoVIM
-- return {
--   -- Theme inspired by Atom
--   'navarasu/onedark.nvim',
--   priority = 1000,
--   config = function()
--     vim.cmd.colorscheme 'onedark'
--   end,
-- }

-- Catppuccin theme configuration

return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- Make sure the colorscheme loads before others
  config = function()
    local function current_flavor()
      return vim.g.catppuccin_flavour or "frappe"
    end

    local function setup_catppuccin(flavor)
      require("catppuccin").setup({
      -- Available flavors: latte, frappe, macchiato, mocha
        flavour = flavor,
      
      -- Background settings
        background = {
          light = "latte",
          dark = "frappe",
        },
      
      -- Transparency settings
        transparent_background = false, -- Set to true for transparent background
        term_colors = true, -- Use terminal colors
      
      -- Dim inactive windows
        dim_inactive = {
          enabled = false,
          shade = "dark",
          percentage = 0.15,
        },
      
      -- No italics
        no_italic = false,
        no_bold = false,
        no_underline = false,
      
      -- Custom colors
        custom_highlights = {},
      
      -- Integrations with other plugins (enable/disable as needed)
        integrations = {
          cmp = true, -- nvim-cmp
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          notify = true,
          mini = true,
          telescope = {
            enabled = true,
          },
          which_key = true,
          markdown = true,
          mason = true,
          illuminate = {
            enabled = true,
            lsp = true,
          },
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
            inlay_hints = {
              background = true,
            },
          },
          indent_blankline = {
            enabled = true,
            colored_indent_levels = false,
          },
          dashboard = true,
          -- Add other integrations as needed
          lsp_trouble = true,
          symbols_outline = true,
          leap = true,
          dap = {
            enabled = true,
            enable_ui = true,
          },
          -- Uncomment plugins you use:
          -- barbecue = { dim_dirname = true },
          -- bufferline = true,
          -- fidget = true,
          -- flash = true,
          -- headlines = true,
          -- lightspeed = true,
          -- lsp_saga = true,
          -- noice = true,
          -- octo = true,
          -- semantic_tokens = true,
          -- telekasten = true,
          -- ts_rainbow = true,
          -- ts_rainbow2 = true,
          -- ufo = true,
          -- vimwiki = true,
        },
      })
    end

    local function apply_flavor(flavor)
      vim.g.catppuccin_flavour = flavor
      setup_catppuccin(flavor)
      vim.cmd.colorscheme "catppuccin"
    end

    setup_catppuccin(current_flavor())

    -- Set the colorscheme
    vim.cmd.colorscheme "catppuccin"
    
    -- Optional: enable filetype-specific transparency
    -- vim.api.nvim_create_autocmd("FileType", {
    --   pattern = { "help", "alpha", "dashboard", "NvimTree", "Trouble", "lazy", "mason" },
    --   callback = function()
    --     vim.cmd("setlocal winblend=10")
    --   end,
    -- })
    
    -- Optional: Add command to toggle between flavors
    vim.api.nvim_create_user_command("CatppuccinSwitch", function(opts)
      local flavor = opts.args ~= "" and opts.args or nil
      local next_flavor = flavor or (current_flavor() == "latte" and "frappe" or "latte")
      apply_flavor(next_flavor)
    end, { nargs = "?", complete = function()
      return { "latte", "frappe", "macchiato", "mocha" }
    end })
    
    -- Optional: keymaps to switch between flavors
    -- vim.keymap.set("n", "<leader>thl", "<cmd>CatppuccinSwitch latte<cr>", { desc = "Light theme" })
    -- vim.keymap.set("n", "<leader>thd", "<cmd>CatppuccinSwitch mocha<cr>", { desc = "Dark theme" })
    -- vim.keymap.set("n", "<leader>tht", "<cmd>CatppuccinSwitch<cr>", { desc = "Toggle theme" })
  end,
}
