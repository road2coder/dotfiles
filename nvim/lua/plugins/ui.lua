return {
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        always_show_bufferline = true,
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, "fileformat")
    end,
  },
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>tf",
        mode = { "n" },
        '<CMD>lua Snacks.terminal(nil, { win = {position = "float"}})<CR>',
        desc = "open float terminal",
      },
      {
        "<c-/>",
        mode = { "n" },
        '<CMD>lua Snacks.terminal(nil, { win = {position = "float"}})<CR>',
        desc = "open float terminal",
      },
      {
        "<c-_>",
        mode = { "n" },
        '<CMD>lua Snacks.terminal(nil, { win = {position = "float"}})<CR>',
        desc = "open float terminal",
      },
      {
        "<leader>tr",
        mode = { "n" },
        '<CMD>lua Snacks.terminal(nil, { win = {position = "right"}})<CR>',
        desc = "open terminal on right",
      },
      {
        "<leader>tl",
        mode = { "n" },
        '<CMD>lua Snacks.terminal(nil, { win = {position = "left"}})<CR>',
        desc = "open terminal on left",
      },
      {
        "<leader>tt",
        mode = { "n" },
        '<CMD>lua Snacks.terminal(nil, { win = {position = "top"}})<CR>',
        desc = "open terminal on top",
      },
      {
        "<leader>tb",
        mode = { "n" },
        '<CMD>lua Snacks.terminal(nil, { win = {position = "bottom"}})<CR>',
        desc = "open terminal on bottom",
      },
    },
  },
}
