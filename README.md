# Dotfiles

Personal tmux and Neovim configuration managed with GNU Stow.

## Install

```sh
brew install stow
brew install fzf ripgrep fd lua-language-server typescript-language-server zls
git clone --recurse-submodules git@github.com:jeremysco/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow tmux
stow nvim
stow ghostty
stow zsh
```
