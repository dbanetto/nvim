" bootstrap plug.vim
if empty(glob('$NVIM_HOME/autoload/plug.vim'))
  silent !curl -fLo $NVIM_HOME/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

function! DoRemotePlugins(arg)
  if has('nvim')
    UpdateRemotePlugins
  endif
endfunction

call plug#begin(expand('$NVIM_HOME/bundles/'))

"" Plugins
" general
Plug 'itchyny/lightline.vim'
Plug 'ap/vim-buftabline'
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-unimpaired'
Plug 'tommcdo/vim-lion'
Plug 'manasthakur/vim-vinegar'
Plug 'airblade/vim-gitgutter'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'moll/vim-bbye'
Plug 'ludovicchabant/vim-gutentags'
Plug 'Shougo/echodoc.vim'

" dev
if has('nvim')
  " dnite
  Plug 'Shougo/denite.nvim', {'do' : function('DoRemotePlugins')}

  " deoplete
  Plug 'Shougo/deoplete.nvim',     {'do' : function('DoRemotePlugins')}
  Plug 'zchee/deoplete-go',        {'for': 'go'}
  Plug 'Shougo/neco-vim',          {'for': 'vim'}
endif

Plug 'eagletmt/neco-ghc', {'for': 'haskell'}
Plug 'neomake/neomake'
Plug 'Chiel92/vim-autoformat'

" language servers
Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }

" web dev
Plug 'tpope/vim-rails',      {'for': ['ruby', 'eruby']}

" writing
Plug 'vim-pandoc/vim-pandoc'
Plug 'rhysd/vim-grammarous'

" syntax
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'ap/vim-css-color', {'for': ['css','scss']}
Plug 'sheerun/vim-polyglot'
Plug 'fatih/vim-go', { 'for': ['go']}

" colorscheme
Plug 'zyphrus/vim-hybrid'

call plug#end()

"" Configuration

" colorscheme
set background=dark
colorscheme hybrid

" lightline
let g:lightline = {
      \ 'colorscheme': 'PaperColor',
      \ 'mode_map': { 'c': 'NORMAL' },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename', 'gutentags' ] ],
      \   'right': [ [ 'lineinfo' ], [ 'percent', 'host' ], [ 'neomake', 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'modified': 'LightLineModified',
      \   'readonly': 'LightLineReadonly',
      \   'fugitive': 'LightLineFugitive',
      \   'filename': 'LightLineFilename',
      \   'fileformat': 'LightLineFileformat',
      \   'filetype': 'LightLineFiletype',
      \   'fileencoding': 'LightLineFileencoding',
      \   'mode': 'LightLineMode',
      \   'neomake': 'LightLineNeomake',
      \   'gutentags': 'gutentags#statusline',
      \   'host': 'LightLineHost'
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '|', 'right': '|' }
      \ }

function! LightLineModified()
  return &ft =~ 'help\|netrw' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightLineReadonly()
  return &ft !~? 'help\|netrw' && &readonly ? '🔒' : ''
endfunction

function! LightLineFilename()
  return ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
        \ ( exists('b:term_title') ? b:term_title :  ('' != expand('%:t') ? expand('%:t') : '[No Name]') ) .
        \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFugitive()
  if &ft !~? 'netrw' && exists("*fugitive#head")
    let branch = fugitive#head()
    return branch !=# '' ? ' '.branch : ''
  endif
  return ''
endfunction

function! LightLineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightLineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightLineFileencoding()
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightLineMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! LightLineNeomake()
  if winwidth(0) <= 80
    return ''
  endif
  let errs  = neomake#statusline#LoclistCounts()
  let signs = [has_key(errs,'E') ? '✖:' . get(errs,'E') : '',
        \  has_key(errs,'W') ? '⚠:' . get(errs,'W') : '']
  return join(filter(signs , 'v:val != ""'), ' ')
endfunction

let s:hostname_and_user = $USER . '@' . system('hostname -s | tr -d "\n"')
function! LightLineHost()
  return winwidth(0) > 80 ? ( $SSH_TTY != '' ? s:hostname_and_user : ''  ) : ''
endfunction

"" denites
if has('nvim')
  " custom sources
  if executable('ag')
    call denite#custom#var('file_rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
  endif

  call denite#custom#alias('source', 'file_rec/git', 'file_rec')
  call denite#custom#var('file_rec/git', 'command',
        \ ['git', 'ls-files', '-co', '--exclude-standard'])

  " matchers
  call denite#custom#var('file_rec', 'matchers',
        \ ['matcher_ignore_globs', 'matcher_fuzzy'])
  call denite#custom#option('default', 'prompt', '>')

  " mappings
  nmap <leader>ub :Denite buffer<CR>
  nmap <leader>uf :Denite `finddir('.git', ';') != '' ? 'file_rec/git' : 'file_rec'`<CR>
endif

" buftabline
let g:buftabline_show = 1
let g:buftabline_indicators = 1

" deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#max_menu_width = 40

" neomake
autocmd! BufWritePost * Neomake

" autoformat
nmap <leader>ff :Autoformat<CR>
nmap <leader>fw :RemoveTrailingSpaces<CR>

" startify
autocmd User Startified setlocal buftype=
let g:startify_enable_unsafe = 1
let g:startify_change_to_dir = 1
let g:startify_change_to_vcs_root = 1
let g:startify_relative_path = 1
let g:startify_session_dir = $NVIM_HOME.'/sessions'
let g:startify_custom_header = ['']
let g:startify_custom_indices = map(range(1,100), 'string(v:val)')
let g:startify_bookmarks = [
      \ { 'c': $NVIM_HOME }
      \ ]
let g:startify_list_order = [
      \ ['   MRU in ' . getcwd() . ':'],
      \ 'dir',
      \ ['   MRU:'],
      \ 'files',
      \ ['   Sessions:'],
      \ 'sessions',
      \ ['   Bookmarks:'],
      \ 'bookmarks',
      \ ]
let g:startify_skiplist = [
      \ 'COMMIT_EDITMSG',
      \ escape(fnamemodify(resolve($VIMRUNTIME), ':p'), '\') .'doc',
      \ 'bundle/.*/doc',
      \ '\s+',
      \ ]

" vim-ruby
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1

" vim-gitgutter
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '*'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_modified_removed = '~'
let g:gitgutter_realtime = 0
nmap [h :GitGutterPrevHunk<CR>zz
nmap ]h :GitGutterNextHunk<CR>zz
nmap <leader>gh :GitGutterLineHighlightsToggle<CR>
omap ih <Plug>GitGutterTextObjectInnerPending
omap ah <Plug>GitGutterTextObjectOuterPending
xmap ih <Plug>GitGutterTextObjectInnerVisual

" vim-surround
let g:surround_no_insert_mappings = 0

" pandoc
let g:pandoc#modules#disabled =["folding"]
let g:pandoc#syntax#conceal#use = 0

" neco-ghc
let g:necoghc_enable_detailed_browse = 1

" vim-go
let g:go_def_mapping_enabled = 0
let g:go_term_mode='split'
au FileType go nmap gd <Plug>(go-def)
au FileType go nmap <leader>gr <Plug>(go-run)
au FileType go nmap <leader>gn <Plug>(go-rename)
au FileType go nmap <leader>gb <Plug>(go-build)
au FileType go nmap <leader>gt <Plug>(go-test)

" vim-bbye
nmap <leader>bd :Bdelete<CR>
nmap <leader>bD :Bdelete!<CR>

" Vim-Jinja2-Syntax
au BufRead,BufNewFile *.tera set filetype=jinja2.html

" languagetool
au FileType pandoc,markdown,latex nmap <leader>fg :GrammarousCheck<CR>
if executable('languagetool')
  let g:grammarous#languagetool_cmd = 'languagetool'
endif
let g:grammarous#default_comments_only_filetypes = {
      \ '*' : 1, 'help' : 0, 'markdown' : 0, 'latex': 0, 'pandoc': 0
      \ }
let g:grammarous#hooks = {}
function! g:grammarous#hooks.on_check(errs) abort
  nmap <buffer>]g <Plug>(grammarous-move-to-next-error)
  nmap <buffer>[g <Plug>(grammarous-move-to-previous-error)
  nmap <buffer>gf <Plug>(grammarous-fixit)
  nmap <buffer>go <Plug>(grammarous-move-to-info-window)
endfunction

function! g:grammarous#hooks.on_reset(errs) abort
  nunmap <buffer>]g
  nunmap <buffer>[g
  nunmap <buffer>gf
  nunmap <buffer>go
endfunction

" rust
if executable('rustc') && executable('rustup')
  let $RUST_SRC_PATH = substitute(system('rustc --print sysroot'), '.$', '/lib/rustlib/src/rust/src', '')
endif

" LanguageClient
let g:LanguageClient_serverCommands = {
      \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
      \ 'python': [$HOME.'/.local/bin/pyls'],
      \ }
" lazily start language server on entry
au FileType rust,python LanguageClientStart<CR>

au FileType rust,python nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
au FileType rust,python nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
au FileType rust,python nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

" echodoc
let g:echodoc#enable_at_startup = 1

" vim: set sw=2 ts=2 ft=vim expandtab:
