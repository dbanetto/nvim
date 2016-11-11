" bootstrap plug.vim
if empty(glob('$NVIM_HOME/autoload/plug.vim'))
  silent !curl -fLo $NVIM_HOME/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

function! DoRemotePlugins(arg)
  UpdateRemotePlugins
endfunction

call plug#begin(expand('$NVIM_HOME/bundles/'))

"" Plugins
" general
Plug 'itchyny/lightline.vim'
Plug 'ap/vim-buftabline'
Plug 'mhinz/vim-startify'
Plug 'lambdalisue/vim-gita'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-unimpaired'
Plug 'tommcdo/vim-lion'
Plug 'tpope/vim-vinegar'
Plug 'airblade/vim-gitgutter'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'moll/vim-bbye'
Plug 'ludovicchabant/vim-gutentags'

" dev
if has('nvim')
  " dnite
  Plug 'Shougo/denite.nvim/', {'do' : function('DoRemotePlugins')}

  " deoplete
  Plug 'Shougo/deoplete.nvim',     {'do' : function('DoRemotePlugins')}
  Plug 'carlitux/deoplete-ternjs', {'for': 'javascript'}
  Plug 'zchee/deoplete-jedi',      {'for': 'python'}
endif
Plug 'eagletmt/neco-ghc', {'for': 'haskell'}
Plug 'neomake/neomake'
Plug 'Chiel92/vim-autoformat'

" sys dev
Plug 'racer-rust/vim-racer', {'for': 'rust'}
Plug 'zchee/deoplete-go',    {'for': 'go'}

" web dev
Plug 'tpope/vim-rails',      {'for': ['ruby', 'eruby']}

" writing
Plug 'vim-pandoc/vim-pandoc'

" syntax
Plug 'tpope/vim-git'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'tmux-plugins/vim-tmux'
Plug 'rust-lang/rust.vim'
Plug 'vim-ruby/vim-ruby',            {'for': ['ruby', 'eruby']}
Plug 'JulesWang/css.vim',            {'for': 'css'}
Plug 'othree/html5.vim',             {'for': 'html'}
Plug 'cespare/vim-toml',             {'for': 'toml'}
Plug 'leshill/vim-json',             {'for': ['json', 'javascript']}
Plug 'jelera/vim-javascript-syntax', {'for': 'javascript'}
Plug 'avakhov/vim-yaml',             {'for': 'yaml'}
Plug 'fatih/vim-go',                 {'for': 'go'}
Plug 'mxw/vim-jsx'
Plug 'mustache/vim-mustache-handlebars'
Plug 'digitaltoad/vim-pug'
Plug 'neovimhaskell/haskell-vim'

" colorscheme
Plug 'zyphrus/vim-hybrid'

call plug#end()

"" Configuration

" colorscheme
set background=dark
colorscheme hybrid

" lightline
let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ 'mode_map': { 'c': 'NORMAL' },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename', 'gutentags' ] ],
      \   'right': [ [ 'lineinfo' ], [ 'percent' ], [ 'neomake', 'fileformat', 'fileencoding', 'filetype' ] ]
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
      \   'gutentags': 'gutentags#statusline'
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
  nmap <leader>uf :Denite buffer<CR>
  nmap <leader>uf :Denite `finddir('.git', ';') != '' ? 'file_rec/git' : 'file_rec'`<CR>
endif

" buftabline
let g:buftabline_show = 1
let g:buftabline_indicators = 1

" deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#max_menu_width = 80

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
let g:startify_custom_header = map(split(system('pwd'), '\n'), '"   ". v:val') + ['','']
let g:startify_custom_indices = map(range(1,100), 'string(v:val)')
let g:startify_list_order = [
      \ ['   Most recently used in this directory:'],
      \ 'dir',
      \ ['   Most recently used:'],
      \ 'files',
      \ ['   Sessions:'],
      \ 'sessions',
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
au FileType go nmap <leader>gd <Plug>(go-def)
au FileType go nmap <leader>gr <Plug>(go-run)
au FileType go nmap <leader>gn <Plug>(go-rename)
au FileType go nmap <leader>gb <Plug>(go-build)
au FileType go nmap <leader>gt <Plug>(go-test)

" vim-bbye
nmap <leader>bd :Bdelete<CR>
nmap <leader>bD :Bdelete!<CR>

" gita
nmap <leader>gs :Gita status<CR>

" vim: set sw=2 ts=2 ft=vim expandtab:
