ZSH_CONFIG_DIR="$HOME/.config/zsh"

for file in \
  "$ZSH_CONFIG_DIR/env.zsh" \
  "$ZSH_CONFIG_DIR/path.zsh" \
  "$ZSH_CONFIG_DIR/history.zsh" \
  "$ZSH_CONFIG_DIR/completion.zsh" \
  "$ZSH_CONFIG_DIR/plugins.zsh" \
  "$ZSH_CONFIG_DIR/aliases.zsh" \
  "$ZSH_CONFIG_DIR/functions.zsh" \
  "$ZSH_CONFIG_DIR/tools.zsh" \
  "$ZSH_CONFIG_DIR/local.zsh"
do
  [[ -f "$file" ]] && source "$file"
done
