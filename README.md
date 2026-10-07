# Dotfiles

Personal macOS configuration managed with GNU Stow. Rosé Pine is used throughout, with light and dark variants following system appearance.

## Install

```sh
brew install stow
brew install fzf ripgrep fd hunk lazygit tree-sitter-cli lua-language-server typescript-language-server zls
git clone --recurse-submodules git@github.com:jeremysco/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow tmux
stow nvim
stow ghostty
stow starship
stow zsh
stow zed
stow herdr
stow hunk
```

Neovim uses its built-in `vim.pack` and the current `nvim-treesitter` main branch, so install Neovim 0.12 or newer and `tree-sitter-cli` 0.26.1 or newer.
