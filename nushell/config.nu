
$env.config = {
  show_banner: false
  buffer_editor: nvim
  shell_integration: {
    osc133: false #("WEZTERM_PANE" not-in $env)
  }
}

# starship 提示符
use ~/.cache/starship/init.nu


# 环境判断
let is_linux = (sys host).name | str contains "Linux"
let is_wsl = $is_linux and ((sys host).kernel_version | str contains "WSL")


# 开关代理
def get_proxy_addr [] {
  if $is_wsl {ip route show | grep -i default | awk '{ print $3}'} else {"127.0.0.1"}
}
def --env proxyon [addr?:string, port = "1080"] {
  let addr = if $addr == null {get_proxy_addr} else {$addr}
  let h_proxy = $"http://($addr):($port)/"
  let s_proxy = $"socks5://($addr):($port)/"
  $env.http_proxy = $h_proxy
  $env.https_proxy = $h_proxy
  $env.https_proxy = $h_proxy
  $env.all_proxy = $s_proxy
  git config --global http.proxy $h_proxy
  git config --global https.proxy $h_proxy
  npm config set proxy $h_proxy
  echo $"代理已开: ($addr) ($port)"
}
def --env proxyoff [] {
  hide-env http_proxy
  hide-env https_proxy
  hide-env all_proxy
  git config --global --unset http.proxy
  git config --global --unset https.proxy
  npm config delete proxy
  echo $"代理已关"
}


# 命令别名
alias ga = git add
alias gaa = git add --all
alias ga. = git add .
# git commit
alias gc = git commit
alias gcm = git commit --message
# git status
alias gs = git status
alias gss = git status --short
# git stash
alias gsh = git stash
alias gshu = git stash --include-untracked
alias gshi = git stash --keep-index
# git checkout
alias gct = git checkout

# neovim
# alias vi = nvim
alias lg = lazygit

