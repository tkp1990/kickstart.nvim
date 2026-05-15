return {
  "rebelot/kanagawa.nvim",
  priority = 1000,
  config = function()
    require("kanagawa").setup({
      theme = "wave",
      transparent = false,
    })

    vim.o.background = "dark"
    vim.cmd.colorscheme("kanagawa")
  end,
}
