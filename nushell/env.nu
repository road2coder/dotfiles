$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

def executable [cmd: string] {
  (which $cmd | length) > 0
}

let host_name = (sys host).name
let is_linux = $host_name =~ "Linux"
let is_wsl = $is_linux and ((sys host).kernel_version =~ "WSL")
let is_win = $host_name =~ "Windows"

# convenient to judge whether a program is launched by nu
$env.IS_NU = "1"

# fnm
if (executable fnm) {
  load-env (fnm env --json | from json)
  let list = $env.PATH | split row (char esep)
  if $is_win {
    $env.PATH = $list | append $env.FNM_MULTISHELL_PATH
  } else {
    $env.PATH = $list | where $it !~ 'fnm' | prepend $'($env.FNM_MULTISHELL_PATH)/bin'
  }
  $env.FNM_NODE_DIST_MIRROR = "https://mirrors.ustc.edu.cn/node/"
}

# rust
if not $is_win {
  let rust_bin_path = $'($env.HOME)/.cargo/bin'
  if ($rust_bin_path | path exists) {
    $env.PATH = $env.PATH | split row ':' | append $rust_bin_path
  }
}

# starship
if (executable starship) {
  mkdir ~/.cache/starship
  starship init nu | save -f ~/.cache/starship/init.nu
}

if $is_win and (executable yazi) {
  let git_list = which git
  if not ($git_list | is-empty) {
    let git_path = $git_list.0.path
    if $git_path =~ "shims" {
     # git installed by scoop
      $env.YAZI_FILE_ONE = $git_path | str replace -r "shims.*$" "apps\\git\\current\\usr\\bin\\file.exe"
    } else {
      # other
    }
  }
}
