return {
  {
    "nvim-treesitter/nvim-treesitter",
    keys = {
      { "<c-space>", false },
      { "<bs>", false },
    },
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "vue", "css", "scss" })
      opts.incremental_selection.keymaps = {
        node_incremental = "<A-l>",
        init_selection = "<A-l>",
        scope_incremental = false,
        node_decremental = "<A-h>",
      }
    end,
  },
}
