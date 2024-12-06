return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "nushell/tree-sitter-nu", build = ":TSUpdate nu" },
    },
    keys = {
      { "<c-space>", false },
      { "<bs>", false },
    },
    opts = {
      ensure_installed = { "vue", "css", "scss", "nu" },
      incremental_selection = {
        enable = true,
        keymaps = {
          node_incremental = "<A-l>",
          init_selection = "<A-l>",
          scope_incremental = false,
          node_decremental = "<A-h>",
        },
      },
    },
  },
}
