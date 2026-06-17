ZSH_CONFIG_DIR="$HOME/.config/zsh"

for file in "$ZSH_CONFIG_DIR"/*.zsh(N); do
  [[ "$file" == "$ZSH_CONFIG_DIR/local.zsh" ]] && continue
  source "$file"
done

[[ -f "$ZSH_CONFIG_DIR/local.zsh" ]] && source "$ZSH_CONFIG_DIR/local.zsh"
