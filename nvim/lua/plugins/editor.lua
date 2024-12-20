local function flash_line(is_end, forward)
  return function()
    local pattern = "^\\s*\\zs\\S\\ze"
    if is_end then
      pattern = "$"
    end
    ---@diagnostic disable
    require("flash").jump({
      pattern = pattern,
      search = {
        mode = "search",
        max_length = 0,
        forward = forward or false,
        wrap = false,
      },
      label = { after = { 0, 0 } },
    })
    ---@diagnostic enable
  end
end

return {
  {
    "folke/flash.nvim",
    keys = {
      { "s", mode = { "n", "x", "o" }, false },
      { "S", mode = { "n", "x", "o" }, false },
      { ",s", mode = { "n", "x", "o" }, "<CMD>lua require('flash').jump()<CR>", desc = "Flash" },
      { ",,", mode = { "n", "o", "x" }, "<CMD>lua require('flash').treesitter()<CR>", desc = "Flash Treesitter" },
      { ",k", mode = { "n", "o", "x" }, flash_line(), desc = "Flash Froward Lines Start" },
      { ",j", mode = { "n", "o", "x" }, flash_line(false, true), desc = "Flash Backward Lines Start" },
      { ",K", mode = { "n", "o", "x" }, flash_line(true), desc = "Flash Froward Lines Start" },
      { ",J", mode = { "n", "o", "x" }, flash_line(true, true), desc = "Flash Backward Lines Start" },
      -- stylua: ignore start
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
      -- stylua: ignore end
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      {
        "<leader>E",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
        end,
        desc = "Explorer NeoTree (Root Dir)",
      },
      { "<leader>fe", false },
      { "<leader>fE", false },
      {
        "<leader>o",
        function()
          if vim.bo.filetype == "neo-tree" then
            vim.cmd.wincmd("p")
          else
            vim.cmd.Neotree("focus")
          end
        end,
        desc = "Foces Explorer",
      },
    },
    opts = {
      commands = {
        parent_or_close = function(state)
          local node = state.tree:get_node()
          if (node.type == "directory" or node:has_children()) and node:is_expanded() then
            state.commands.toggle_node(state)
          else
            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
          end
        end,
        child_or_open = function(state)
          local node = state.tree:get_node()
          if node.type == "directory" or node:has_children() then
            if not node:is_expanded() then -- 没展开时展开
              state.commands.toggle_node(state)
            else -- 聚焦到第一个子节点
              require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
            end
          else -- 打开文件
            state.commands.open(state)
          end
        end,
      },
      window = {
        mappings = {
          h = "parent_or_close",
          l = "child_or_open",
          o = "open",
        },
      },
      filesystem = {
        bind_to_cwd = true,
        use_libuv_file_watcher = vim.fn.has("win32") ~= 1,
      },
    },
  },
  {
    "ibhagwan/fzf-lua",
    keys = {
      { "<leader>/", LazyVim.pick("live_grep", { root = false }), desc = "Grep (Root Dir)" },
      { "<leader>ff", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
      { "<leader>fF", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
      { "<leader>fr", LazyVim.pick("oldfiles", { cwd = vim.uv.cwd() }), desc = "Recent (cwd)" },
      { "<leader>fR", "<cmd>FzfLua oldfiles<cr>", desc = "Recent" },
      { "<leader>sg", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
      { "<leader>sG", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
      { "<leader>sw", LazyVim.pick("grep_cword", { root = false }), desc = "Word (cwd)" },
      { "<leader>sW", LazyVim.pick("grep_cword"), desc = "Word (Root Dir)" },
      { "<leader>sw", LazyVim.pick("grep_visual", { root = false }), mode = "v", desc = "Selection (cwd)" },
      { "<leader>sW", LazyVim.pick("grep_visual"), mode = "v", desc = "Selection (Root Dir)" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 500,
      },
    },
  },
}
