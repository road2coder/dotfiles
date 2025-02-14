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
    -- stylua: ignore start
    keys = {
      {"<leader>tf", mode = { "n" }, '<CMD>lua Snacks.terminal(nil, { win = {position = "float"}})<CR>', desc = "open float terminal" },
      {"<c-/>", mode = { "n" }, '<CMD>lua Snacks.terminal(nil, { win = {position = "float"}})<CR>', desc = "open float terminal" },
      {"<c-_>", mode = { "n" }, '<CMD>lua Snacks.terminal(nil, { win = {position = "float"}})<CR>', desc = "open float terminal" },
      {"<leader>tr", mode = { "n" }, '<CMD>lua Snacks.terminal(nil, { win = {position = "right"}})<CR>', desc = "open terminal on right" },
      {"<leader>tl", mode = { "n" }, '<CMD>lua Snacks.terminal(nil, { win = {position = "left"}})<CR>', desc = "open terminal on left" },
      {"<leader>tt", mode = { "n" }, '<CMD>lua Snacks.terminal(nil, { win = {position = "top"}})<CR>', desc = "open terminal on top" },
      {"<leader>tb", mode = { "n" }, '<CMD>lua Snacks.terminal(nil, { win = {position = "bottom"}})<CR>', desc = "open terminal on bottom" },
      -- find
      { "<leader>fB", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fb", function() Snacks.picker.buffers({ hidden = true, nofile = true }) end, desc = "Buffers (all)" },
      { "<leader>fF", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
      { "<leader>ff", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
      { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Files (git-files)" },
      { "<leader>fR", LazyVim.pick("oldfiles"), desc = "Recent" },
      { "<leader>fr", function() Snacks.picker.recent({ filter = { cwd = true }}) end, desc = "Recent (cwd)" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      -- Grep
      { "<leader>sg", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
      { "<leader>sG", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
      { "<leader>sW", LazyVim.pick("grep_word"), desc = "Visual selection or word (Root Dir)", mode = { "n", "x" } },
      { "<leader>sw", LazyVim.pick("grep_word", { root = false }), desc = "Visual selection or word (cwd)", mode = { "n", "x" } },
    },
    -- stylua: ignore end
  },
}
