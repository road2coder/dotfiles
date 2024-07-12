local map = vim.keymap.set
local utils = require("utils")
local curry = utils.curry

map("n", "gh", vim.lsp.buf.hover, { desc = "Hover" })
map("v", "p", '"_dP', { desc = "paste multiple times" }) -- 一次复制可粘贴多次

-- 转换选中的内容
map("v", "\\1", curry(utils.replace_selection, "kebab"), { desc = "Replace selection(kebab)" })
map("v", "\\2", curry(utils.replace_selection, "camel"), { desc = "Replace selection(camel)" })
map("v", "\\3", curry(utils.replace_selection, "pascal"), { desc = "Replace selection(pascal)" })
map("v", "\\4", curry(utils.replace_selection, "snake"), { desc = "Replace selection(snake)" })

-- 复制选中内容的指定形式到剪切板
map("v", "\\q", curry(utils.copy_selection, "snake"), { desc = "copy(kebab)" })
map("v", "\\w", curry(utils.copy_selection, "camel"), { desc = "copy(camel)" })
map("v", "\\e", curry(utils.copy_selection, "pascal"), { desc = "copy(pascal)" })
map("v", "\\r", curry(utils.copy_selection, "snake"), { desc = "copy(snake)" })

-- insert 模式下使用 ctrl-h/l 左右移动
map("i", "<C-h>", "<Left>", { noremap = true, silent = true })
map("i", "<C-j>", "<Down>", { noremap = true, silent = true })
map("i", "<C-k>", "<Up>", { noremap = true, silent = true })
map("i", "<C-l>", "<Right>", { noremap = true, silent = true })

map("n", "\\1", curry(utils.copy_file_name, 0), { desc = "Copy File Name" })
map("n", "\\2", curry(utils.copy_file_name, 1), { desc = "Copy File Name(without ext)" })
map("n", "\\3", curry(utils.copy_file_name, 2), { desc = "Copy Relative File Path" })
map("n", "\\4", curry(utils.copy_file_name, 3), { desc = "Copy File Path" })

if not vim.g.vscode then
  -- insert 使用 ctrl + shift + v 可粘贴
  map("!", "<c-s-v>", "<c-r>+", { desc = "paste" })
  map("!", "", "<c-r>+", { desc = "paste" })

  map({ "n", "v" }, "\\f", function()
    LazyVim.format({ force = true })
  end, { desc = "Format" })
else
  local action = require("vscode-neovim").action
  map("n", "\\f", curry(action, "editor.action.formatDocument"))
  map("v", "\\f", curry(action, "editor.action.formatSelection"))
  map("n", "\\r", curry(action, "editor.action.rename"))
  map("n", "H", curry(action, "workbench.action.previousEditorInGroup"))
  map("n", "L", curry(action, "workbench.action.nextEditorInGroup"))
end
