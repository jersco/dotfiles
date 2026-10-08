if [[ "$TERM" != "dumb" ]] && command -v starship >/dev/null 2>&1; then
  if [[ "$OSTYPE" == darwin* && -z "${STARSHIP_CONFIG:-}" ]]; then
    _mons_update_starship_theme() {
      if [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]]; then
        unset STARSHIP_CONFIG
      else
        export STARSHIP_CONFIG="$HOME/.config/starship-rose-pine-dawn.toml"
      fi
    }
    _mons_update_starship_theme
    precmd_functions+=(_mons_update_starship_theme)
  fi
  eval "$(starship init zsh)"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
