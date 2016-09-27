" required for list characters
set encoding=utf8
set nocompatible
set backspace=2
set laststatus=2

" setup rtp to neovim's home
set rtp=$HOME/.config/nvim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.config/nvim/after

" load neovim config
source $HOME/.config/nvim/init.vim
