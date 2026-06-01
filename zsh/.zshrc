# ==============================================================================
# Environment
# ==============================================================================

export LANG="en_US.UTF-8"
export EDITOR="nvim"

typeset -U path PATH
path=(
  "$HOME/.local/bin"
  "$HOME/.bun/bin"
  "$HOME/Library/pnpm"
  $path
)
export PATH

[ -f "$HOME/.local/bin/env" ] && source "$HOME/.local/bin/env"

export BUN_INSTALL="$HOME/.bun"
export PNPM_HOME="$HOME/Library/pnpm"
export NVM_DIR="$HOME/.nvm"

# ==============================================================================
# History
# ==============================================================================

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS

# ==============================================================================
# Shell Behavior & Completion
# ==============================================================================

setopt AUTO_CD
setopt EXTENDED_GLOB

mkdir -p "$HOME/.cache/zsh"
autoload -Uz compinit
compinit -d "$HOME/.cache/zsh/zcompdump"

zstyle ":completion:*" menu select
zstyle ":completion:*" matcher-list "m:{a-zA-Z}={A-Za-z}"
zstyle ":fzf-tab:*" fzf-command fzf
zstyle ":fzf-tab:*" switch-group "," "."

# ==============================================================================
# Lightweight Plugins
# ==============================================================================

ZSH_PLUGINS_DIR="$HOME/.local/share/zsh-plugins"

plugin-load() {
  local repo="$1"
  local name="${repo:t}"
  local plugin_dir="$ZSH_PLUGINS_DIR/$name"

  if [[ ! -d "$plugin_dir" ]]; then
    mkdir -p "$ZSH_PLUGINS_DIR"
    git clone --depth 1 "https://github.com/$repo.git" "$plugin_dir"
  fi

  if [[ -f "$plugin_dir/$name.plugin.zsh" ]]; then
    source "$plugin_dir/$name.plugin.zsh"
  elif [[ -f "$plugin_dir/$name.zsh" ]]; then
    source "$plugin_dir/$name.zsh"
  fi
}

plugin-load "zsh-users/zsh-autosuggestions"
plugin-load "Aloxaf/fzf-tab"
plugin-load "zsh-users/zsh-syntax-highlighting"

# ==============================================================================
# External Tools
# ==============================================================================

if [[ "$TERM" != "dumb" ]] && command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  nvm "$@"
}

node() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  node "$@"
}

npm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  npm "$@"
}

npx() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  npx "$@"
}
