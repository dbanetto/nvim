if $NVIM_HOME == ""
  let $NVIM_HOME=$HOME."/.config/nvim"
endif

if filereadable($NVIM_HOME."/env.vim")
  source $NVIM_HOME."/env.vim"
endif

source $NVIM_HOME/settings.vim
source $NVIM_HOME/plugins.vim

" vim: set sw=2 ts=2 expandtab ft=vim:
