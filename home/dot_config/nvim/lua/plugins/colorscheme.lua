return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- load before other plugins
    opts = {
      flavour = "mocha", -- matches Catppuccin Mocha used in WezTerm / Windows Terminal
      integrations = {
        treesitter = true,
        telescope = true,
        native_lsp = { enabled = true },
        cmp = true,
        gitsigns = true,
        which_key = true,
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
