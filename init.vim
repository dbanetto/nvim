if $NVIM_HOME == ""
  if has("win32") || has("win64")
    let $NVIM_HOME=substitute($HOME, "\\", "/", "g")."/appdata/local/nvim"
  else
    let $NVIM_HOME=$HOME."/.config/nvim"
  endif
endif

if filereadable($NVIM_HOME."/env.vim")
  source $NVIM_HOME/env.vim
endif

source $NVIM_HOME/settings.vim
source $NVIM_HOME/plugins.vim

if filereadable($NVIM_HOME."/env.after.vim")
  source $NVIM_HOME/env.after.vim
endif

" vim: set sw=2 ts=2 expandtab ft=vim:
