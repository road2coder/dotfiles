local M = {}

function M.get_git_shell_path()
  local gitc = os.getenv("gitc")
  if gitc ~= nil then
    local res = string.gsub(gitc, "\\usr\\bin\\?$", "\\bin\\bash.exe")
    return res
  end
  return nil
end

function M.win_executable(cmd)
  local handle = io.popen("where " .. cmd)
  if handle ~= nil then
    local s = handle:read("*a")
    handle:close()
    return s ~= ""
  end
  return false
end

return M
