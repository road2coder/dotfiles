local autocmd = vim.api.nvim_create_autocmd
local utils = require("utils")

local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

local ime_grp = augroup("input_method")
-- 进入 nvim、离开 insert 模式时，自动切换至英文输入法
autocmd({ "InsertLeave", "VimEnter" }, {
  group = ime_grp,
  callback = utils.switch_ime_en,
})

-- windows系统下，进入 insert 模式自动切换到中文输入法
autocmd({ "InsertEnter", "VimLeave" }, {
  group = ime_grp,
  callback = utils.switch_ime_cn,
})

-- 使用 o 时，不自动添加注释
autocmd("BufEnter", {
  group = augroup("no_comment_on_new_line"),
  callback = function()
    vim.opt_local.formatoptions:remove({ "o" })
  end,
})
