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

local function flash_word()
  ---@diagnostic disable
  require("flash").jump({
    search = { mode = "search", max_length = 0, forward = true },
    label = { after = { 0, 0 } },
    pattern = "\\<",
  })
  ---@diagnostic enable
end

return {
  {
    "folke/flash.nvim",
    keys = {
      { "s", mode = { "n", "x", "o" }, false },
      { "S", mode = { "n", "x", "o" }, false },
      { ",s", mode = { "n", "x", "o" }, "<CMD>lua require('flash').jump()<CR>", desc = "Flash" },
      { ",,", mode = { "n", "o", "x" }, "<CMD>lua require('flash').treesitter()<CR>", desc = "Flash Treesitter" },
      { ",w", mode = { "n", "o", "x" }, flash_word, desc = "Flash Treesitter" },
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
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 500,
      },
    },
  },
}
