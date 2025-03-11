return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,    -- Show hidden files and folders
          hide_gitignored = false,  -- Optionally show gitignored files
        },
      },
    })
    vim.keymap.set("n", "<leader>nt", ":Neotree toggle<CR>", {})
    vim.keymap.set("n", "<leader>nf", ":Neotree focus<CR>", {})
    vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", {})
  end,
}
