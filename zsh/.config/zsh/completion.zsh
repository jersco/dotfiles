setopt AUTO_CD
setopt EXTENDED_GLOB

mkdir -p "$HOME/.cache/zsh"
autoload -Uz compinit
compinit -d "$HOME/.cache/zsh/zcompdump"

zstyle ":completion:*" menu select
zstyle ":completion:*" matcher-list "m:{a-zA-Z}={A-Za-z}"
zstyle ":fzf-tab:*" fzf-command fzf
zstyle ":fzf-tab:*" switch-group "," "."
