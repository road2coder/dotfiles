let is_linux = (sys host).name | str contains "Linux"
let is_wsl = $is_linux and ((sys host).kernel_version | str contains "WSL")

# convenient to judge whether a program is launched by nu
$env.IS_NU = "1"

def executable [cmd: string] {
  (which $cmd | length) > 0
}

# fnm 环境设置
if (executable fnm) {
  load-env (fnm env --json | from json)
  $env.PATH = ($env.PATH | split row (char esep) | where $it !~ 'fnm' | append $'($env.FNM_MULTISHELL_PATH)(char psep)bin') 
  $env.FNM_NODE_DIST_MIRROR = "https://mirrors.ustc.edu.cn/node/"
}

# cargo 环境变量
if ($'($env.HOME)(char psep).cargo(char psep)bin' | path exists) {
  $env.PATH = ($env.PATH | split row (char esep) | append $'($env.HOME)(char psep).cargo(char psep)bin')
}

# starship 环境变量设置
if (executable starship) {
  mkdir ~/.cache/starship
  starship init nu | save -f ~/.cache/starship/init.nu
}

if $is_wsl {
  cd ~
}
