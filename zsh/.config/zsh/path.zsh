typeset -U path PATH

path=(
  "$HOME/.local/bin"
  "$HOME/.bun/bin"
  "$HOME/Library/pnpm"
  "$HOME/.emacs.d/bin"
  "$HOME/.opencode/bin"
  $path
)

export PATH

[[ -f "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"
