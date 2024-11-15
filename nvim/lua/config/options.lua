-- 与 neovim 选项的设置的相关的命令有 set、setlocal、setglobal 和 let。使用 set 开头
-- 的用于设置一些 neovim 内置相关的项，如 ignorecase 和大小写相关。而 let 则用于设置
-- 一些变量，这些变量可以是 neovim 本身使用到的，如 mapleader，也可以是用户自己要用的
-- 一些变量。 let 默认设置的是全局变量，也可以指定范围，如 let b:key=value 则只在当前
-- buffer 生效
-- 而在 lua 中，与 set 相关的有
--    vim.go  相当于 setglobal
--    vim.bo  相当于 setlocal
--    vim.o   相当于 set（同时设置 global 和 local）
--    vim.opt vim.opt_local vim.opt_global:  和 vim.o vim.bo vim.go 作用相同，但用法不同，可以参考 :h vim.opt
-- 而和 let 相关的有 vim.g vim.w vim.b 等，它们设置的变量的生效范围不同。

local utils = require("utils")
vim.g.autoformat = false

if not vim.g.vscode then
  -- 非 vscode 配置
  if utils.is_win() and vim.fn.executable("nu") then
    vim.o.shell = "nu" -- 使用 nushell 作为 windows 的默认 shell
  end
else
  -- vscode 下的配置
  local vscode = require("vscode-neovim")
  vim.notify = vscode.notify
end
