# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
# The default for this is $nu.default-config-dir/scripts
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
]

# Directories to search for plugin binaries when calling register
# The default for this is $nu.default-config-dir/plugins
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

# fnm 环境设置
load-env (fnm env --json | from json)
if ((sys host).name == 'Windows') {
  $env.Path = ($env.Path | split row (char esep) | append $env.FNM_MULTISHELL_PATH) 
} else {
  $env.PATH = ($env.PATH | split row (char esep) | append $env.FNM_MULTISHELL_PATH) 
}

# starship 环境变量设置
mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu
