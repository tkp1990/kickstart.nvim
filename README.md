# Personal Neovim Config

This branch contains a personalized Neovim setup that started from `kickstart.nvim` and has since been split into a modular plugin layout under `lua/plugins/`.

## What Changed From Kickstart

- Modular plugin specs instead of keeping everything in a single `init.lua`
- Gruvbox theme as the default colorscheme
- Custom statusline with `lualine`
- `neo-tree` for file browsing
- `toggleterm` for floating and split terminal workflows
- `noice.nvim` and `nvim-notify` for message UI and notifications
- `nvim-cmp` with LuaSnip, path, buffer, LSP, and crates completion
- Mason-managed LSP setup with Rust and Lua configured
- DAP setup for general debugging plus Go and Rust-related workflows
- `todo-comments`, `gitsigns`, `Comment.nvim`, `treesitter`, and Markdown linting

## Layout

Key files:

- `init.lua`: bootstrap, Telescope mappings, Treesitter setup, and shared top-level behavior
- `lua/vim-options.lua`: editor options and basic keymaps
- `lua/plugins.lua`: core plugin list
- `lua/plugins/*.lua`: plugin-specific configuration

## Included Plugins

Main plugins currently configured in this branch:

- `rebelot/kanagawa.nvim`
- `nvim-telescope/telescope.nvim`
- `nvim-treesitter/nvim-treesitter`
- `neovim/nvim-lspconfig`
- `williamboman/mason.nvim`
- `hrsh7th/nvim-cmp`
- `L3MON4D3/LuaSnip`
- `nvim-neo-tree/neo-tree.nvim`
- `nvim-lualine/lualine.nvim`
- `akinsho/toggleterm.nvim`
- `mfussenegger/nvim-dap`
- `rcarriga/nvim-notify`
- `folke/noice.nvim`
- `folke/todo-comments.nvim`
- `lewis6991/gitsigns.nvim`
- `mfussenegger/nvim-lint`

## Requirements

At minimum:

- Neovim stable
- `git`
- `ripgrep`
- `make`
- a clipboard provider for your OS
- a Nerd Font if you want the configured icons to render correctly

Optional but useful depending on what you edit:

- `lazygit`
- language servers and debug tools installed through Mason
- `markdownlint` for Markdown linting
- compiler/debugger tooling for Rust, Go, C, or C++

## Install

Clone this repo into your Neovim config path:

```sh
git clone <your-repo-url> "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

Then start Neovim:

```sh
nvim
```

`lazy.nvim` will install the configured plugins on first launch.

## Notes

- The default colorscheme is `kanagawa`.
- The config still keeps some Kickstart structure and comments, but the active behavior now lives primarily in the modular plugin files.

## Useful Commands

- `:Lazy` to inspect plugin state
- `:Mason` to manage LSP servers, linters, and DAP adapters
- `:checkhealth` to inspect environment issues
- `:colorscheme kanagawa`

## Branch Context

This README reflects the personalized state of the `kpt/personal_changes` branch rather than the original upstream Kickstart template.
