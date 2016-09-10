if $NVIM_HOME == ""
  let $NVIM_HOME=$HOME."/.config/nvim"
endif

source $NVIM_HOME/settings.vim
source $NVIM_HOME/plugins.vim

" vim: set sw=2 ts=2 expandtab ft=vim:
