local M = {}

function M.has(item)
  return vim.fn.has(item) == 1
end

function M.is_win()
  return vim.fn.has("win32") == 1
end

function M.switch_ime_en()
  vim.defer_fn(function()
    local os_name = vim.loop.os_uname().sysname
    if os_name == "Darwin" and vim.fn.executable("im-select") then
      vim.fn.system({ "im-select", "com.apple.keylayout.US" })
    elseif os_name == "Windows_NT" or M.has("wsl") and vim.fn.executable("im-select.exe") then
      vim.fn.system({ "im-select.exe", "1033" })
    elseif vim.fn.executable("fcitx5-remote") == 1 then
      vim.fn.system({ "fcitx5-remote", "-s", "keyboard-us" })
    end
  end, 100)
end

-- only windows
function M.switch_ime_cn()
  local has = vim.fn.has
  if vim.fn.executable("im-select.exe") == 1 and has("win32") == 1 or has("wsl") == 1 then
    vim.defer_fn(function()
      vim.fn.system({ "im-select.exe", "2052" })
    end, 100)
  end
end

function M.curry(fn, ...)
  local args = {}
  local n1 = select("#", ...)
  for i = 1, n1 do
    table.insert(args, (select(i, ...)))
  end
  return function(...)
    local n2 = select("#", ...)
    local unpack = unpack or table.unpack
    for i = 1, n2 do
      table.insert(args, (select(i, ...)))
    end
    fn(unpack(args))
  end
end

-- 获取 visual 模式选中的文本（非 normal 为上次选中）
function M.get_selection()
  local mode = vim.fn.mode()
  if mode ~= "v" and mode ~= "V" then
    return ""
  end
  local line_start = vim.fn.line("v")
  local line_end = vim.fn.line(".")
  local col_start = vim.fn.col("v")
  local col_end = vim.fn.col(".")
  local t = nil
  if mode == "V" then
    t = vim.api.nvim_buf_get_lines(0, line_start - 1, line_end, true)
  else
    t = vim.api.nvim_buf_get_text(0, line_start - 1, col_start - 1, line_end - 1, col_end, {})
  end
  return table.concat(t, vim.opt.fileformat:get() == "dos" and "\r\n" or "\n")
end

-- 替换选中的内容
function M.replace_selection(case)
  local str = M.get_selection()
  if not str then
    return nil
  end
  local to_replace = M.convert_case(str, case)
  vim.api.nvim_feedkeys("c" .. to_replace, "n", true)
  local key = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
  vim.api.nvim_feedkeys(key, "n", true)
end

-- 复制选中内容的指定格式
function M.copy_selection(case)
  local str = M.get_selection()
  if not str then
    return nil
  end
  local to_copy = M.convert_case(str, case)
  vim.fn.setreg("+", to_copy)
  vim.fn.setreg("*", to_copy)
  vim.api.nvim_input("<esc>")
  vim.notify("copide: " .. to_copy)
end

-- 转换字符串的形式
function M.convert_case(str, case)
  -- 可转换的模式
  local separators = {
    kebab = "-",
    camel = "",
    pascal = "",
    snake = "_",
  }
  local sep = separators[case]
  if not sep then
    return nil
  end

  -- pascal case 处理
  if string.find(str, "[a-z]") ~= nil then
    str = str:gsub("%u", " %0"):gsub("^%s*(.-)%s*$", "%1")
  end

  local words = {}
  for word in str:gmatch("%a+") do
    table.insert(words, word)
  end

  local result = ""
  for i, word in ipairs(words) do
    -- kebab 或 snake: 将单词全部小写
    if case == "kebab" or case == "snake" then
      word = word:lower()
    -- camel 或 pascal: 将单词首字母大写，其余小写
    elseif case == "camel" or case == "pascal" then
      word = word:sub(1, 1):upper() .. word:sub(2):lower()
    end
    -- camel 且单词是第一个: 将单词首字母小写
    if case == "camel" and i == 1 then
      word = word:sub(1, 1):lower() .. word:sub(2)
    end
    result = result .. word
    if i < #words then
      result = result .. sep
    end
  end

  return result
end

function M.copy_file_name(type)
  -- 绝对路径
  local path = vim.api.nvim_buf_get_name(0)
  if type == 0 then
    -- 文件名
    path = vim.fn.fnamemodify(path, ":t")
  elseif type == 1 then
    -- 文件名不带后缀
    path = vim.fn.fnamemodify(path, ":t:r")
  elseif type == 2 then
    local root = LazyVim.root()
    path = string.sub(path, #root + 2)
  end
  vim.fn.setreg("+", path)
  vim.fn.setreg("*", path)
  vim.notify("copide: " .. path)
end

return M
