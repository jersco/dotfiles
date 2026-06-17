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
