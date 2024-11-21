local function flash_line(is_end, forward)
  return function()
    local pattern = "^\\s*\\zs\\S\\ze"
    if is_end then
      pattern = "$"
    end
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
      -- stylua: ignore start
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
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
    "nvim-telescope/telescope.nvim",
    keys = {
      { "\\r", vim.lsp.buf.rename, desc = "[R]ename Variable" },
      { "<leader>ff", LazyVim.pick("auto", { root = false }), desc = "Find Files (cwd)" },
      { "<leader>fF", LazyVim.pick("auto"), desc = "Find Files (Root Dir)" },
      { "<leader>fr", LazyVim.pick("oldfiles", { cwd = vim.uv.cwd() }), desc = "Recent (cwd)" },
      { "<leader>fR", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
      { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },
      { "<leader>sD", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
      { "<leader>sg", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
      { "<leader>sG", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
      { "<leader>sw", LazyVim.pick("grep_string", { root = false, word_match = "-w" }), desc = "Word (cwd)" },
      { "<leader>sW", LazyVim.pick("grep_string", { word_match = "-w" }), desc = "Word (Root Dir)" },
      { "<leader>sw", LazyVim.pick("grep_string", { root = false }), mode = "v", desc = "Selection (cwd)" },
      { "<leader>sW", LazyVim.pick("grep_string"), mode = "v", desc = "Selection (Root Dir)" },
    },
    opts = {
      defaults = {
        path_display = { "truncate" },
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = { prompt_position = "top", preview_width = 0.55 },
          vertical = { mirror = false },
          width = 0.87,
          height = 0.84,
          preview_cutoff = 120,
        },
        file_ignore_patterns = {
          ".node_modules/",
          ".git/",
          ".github/",
          ".vscode/",
          ".idea/",
        },
      },
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
