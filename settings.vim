set wildmenu
set path+=**

" list chars
set listchars=tab:▸\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
set showbreak=↪

" persistent undo
set undodir=$NVIM_HOME/.undofile
set undofile
set undolevels=1000
set undoreload=10000
if ! isdirectory(&undodir)
  call mkdir(&undodir, 'p')
endif

" indent
set autoindent
set copyindent

" default tab settings
set smarttab
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

" warp
set display=lastline
set formatoptions=tcroql
set linebreak
set nojoinspaces
set wrap
set textwidth=0
let &sbr = nr2char(8618).' ' " Show ↪ at the beginning of wrapped lines

" folding
set foldmethod=indent
set foldlevelstart=1

set completeopt=menuone,noselect

" <x> at EOL + remove trailing whitespace
nmap <silent> <leader>; mbV:s/\s*$/;/<CR>:let @/=""<CR>`b
nmap <silent> <leader>, mbV:s/\s*$/,/<CR>:let @/=""<CR>`b
nmap <silent> <leader>. mbV:s/\s*$/./<CR>:let @/=""<CR>`b

"" commands
command! W w!
command! Q q!

"" autocmd
" normal mode when focus is lost
au FocusLost * call feedkeys("\<C-\>\<C-n>")

" Filetype detection
au FileType netrw setl bufhidden=delete

" FileType settings
" au FileType markdown,pandoc setl wrap tw=79 spell
" au FileType python setl ts=4 sw=4 sts=4 et
" au FileType ruby,eruby setl ts=2 sw=2 sts=2 et
" au FileType javascript,typescript,json,coffeescript,pug,jsx setl ts=2 sw=2 sts=2
" au FileType html,css setl ts=2 sw=2 sts=2
" au FileType vim setl ts=2 sw=2 sts=2
" au FileType tex,plaintex setl wrap tw=79 fo=tcqor spell
" au FileType cpp,c setl cindent
" au FileType make setl ts=4 sts=4 sw=4 noet list
au FileType gitcommit,gita-commit setl wrap tw=72 spell

" quit for readonly files
nnoremap <expr> q (&readonly ? ':close<CR>' : 'q')

"" Functions

" tmux config
if $TMUX != ''
  " https://gist.github.com/tarruda/5158535
  fun! TmuxMove(direction)
    " Check if we are currently focusing on a edge window.
    " To achieve that,  move to/from the requested window and
    " see if the window number changed
    let oldw = winnr()
    silent! exe 'wincmd ' . a:direction
    let neww = winnr()
    if oldw == neww
      " work around mac screwing up $PATH
      if has('mac')
        let tmux_path = '/usr/local/bin/'
      else
        let tmux_path = ''
      endif

      " The focused window is at an edge, so ask tmux to switch panes
      if a:direction == 'j'
        call system(tmux_path."tmux select-pane -D")
      elseif a:direction == 'k'
        call system(tmux_path."tmux select-pane -U")
      elseif a:direction == 'h'
        call system(tmux_path."tmux select-pane -L")
      elseif a:direction == 'l'
        call system(tmux_path."tmux select-pane -R")
      endif
    end
  endfun

  " vim+tmux pane navigation
  nnoremap <silent> <c-w>j :silent call TmuxMove('j')<cr>
  nnoremap <silent> <c-w>k :silent call TmuxMove('k')<cr>
  nnoremap <silent> <c-w>h :silent call TmuxMove('h')<cr>
  nnoremap <silent> <c-w>l :silent call TmuxMove('l')<cr>
endif

" From https://github.com/Chiel92/vim-autoformat/blob/41f2fe23611025b891d2a92e721df61846e3df4b/plugin/autoformat.vim#L354-L363
function! s:RemoveTrailingSpaces()
    let user_gdefault = &gdefault
    try
        set nogdefault
        silent! %s/\s\+$
    finally
        let &gdefault = user_gdefault
    endtry
endfunction

command! RemoveTrailingSpaces call s:RemoveTrailingSpaces()
nmap <leader>fw :RemoveTrailingSpaces<CR>

" vim: set sw=2 ts=2 expandtab ft=vim:
