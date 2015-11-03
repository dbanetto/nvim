if $NVIM_HOME == ""
  let $NVIM_HOME=$HOME."/.config/nvim"
endif

source $NVIM_HOME/plugins.vim
source $NVIM_HOME/settings.vim

" vim: set ts=2 sw=2 expandtab:
