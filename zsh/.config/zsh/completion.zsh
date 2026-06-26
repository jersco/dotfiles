setopt AUTO_CD
setopt EXTENDED_GLOB

mkdir -p "$HOME/.cache/zsh"
autoload -Uz compinit
compinit -d "$HOME/.cache/zsh/zcompdump"

if [[ -n "$LS_COLORS" ]]; then
  zstyle ":completion:*" list-colors ${(s.:.)LS_COLORS}
else
  zstyle ":completion:*" list-colors "di=34:ln=36:so=35:pi=33:ex=32:bd=94:cd=94:ma=7"
fi
zstyle ":completion:*" menu select
zstyle ":completion:*" matcher-list "m:{a-zA-Z}={A-Za-z}"
zstyle ":fzf-tab:*" fzf-command fzf
zstyle ":fzf-tab:*" switch-group "," "."
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#9da9a0,italic"
