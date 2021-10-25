" bootstrap plug.vim {{{
let s:bootstrapping = 0
if empty(glob($NVIM_HOME.'/autoload/plug.vim'))
  !curl -fLo $NVIM_HOME/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let s:bootstrapping = 1
endif

function! DoRemotePlugins(arg)
  if has('nvim')
    UpdateRemotePlugins
  endif
endfunction

call plug#begin($NVIM_HOME.'/bundles/')

" }}}

" Plugins {{{

" general
Plug 'itchyny/lightline.vim'
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-unimpaired'
Plug 'tommcdo/vim-lion'
Plug 'tpope/vim-vinegar'
Plug 'airblade/vim-gitgutter'
Plug 'moll/vim-bbye'

Plug 'ap/vim-buftabline'

" dev
if has('nvim')
  Plug 'tveskag/nvim-blame-line'

  " language servers
  Plug 'neovim/nvim-lspconfig'
  Plug 'simrat39/rust-tools.nvim'

  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/nvim-cmp'

  Plug 'L3MON4D3/LuaSnip'
  Plug 'saadparwaiz1/cmp_luasnip'
endif

Plug 'sgur/vim-editorconfig'
Plug 'sheerun/vim-polyglot'

" colorscheme
Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }

" }}}

" env file loading {{{

if filereadable($NVIM_HOME."/env.plug.vim")
  source $NVIM_HOME/env.plug.vim
endif

call plug#end()

if s:bootstrapping == 1
  echo 'bootstrapping plugins'
  PlugInstall
endif

" }}}

"" Configuration

" colorscheme {{{
set background=dark
colorscheme challenger_deep

" }}}

" lightline {{{
let g:lightline = {
      \ 'colorscheme': 'challenger_deep',
      \ 'mode_map': { 'c': 'NORMAL' },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ],
      \   'right': [ [ 'lineinfo' ], [ 'percent', 'host' ], ['languageclient', 'fileformat', 'fileencoding', 'filetype' ] ]
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
      \   'languageclient': 'LightLineLanguageClient',
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

function! LightLineLanguageClient() abort
  if !exists('b:LanguageClient_isServerRunning') || !LanguageClient#isServerRunning()
    return ""
  endif

  if LanguageClient#serverStatus()
    return "🤔"
  endif

  let l:diagnosticsDict = LanguageClient#statusLineDiagnosticsCounts()
  let l:status = []
  let l:errors = get(l:diagnosticsDict,'E',0)
  if l:errors > 0
    let l:status += ["✖:" . l:errors]
  endif
  let l:warnings = get(l:diagnosticsDict,'W',0)
  if l:warnings > 0
    let l:status += ["⚠:" . l:warnings]
  endif
  let l:informations = get(l:diagnosticsDict,'I',0)
  if l:informations > 0
    let l:status += ["I:" . l:informations]
  endif
  let l:hints = get(l:diagnosticsDict,'H',0)
  if l:hints > 0
    let l:status += ["H:" . l:hints]
  endif
  let l:line = ""
  if len(l:status) > 0
    let l:line = join(l:status, " ")
  endif
  return l:line
endfunction

let s:hostname_and_user = ( $SSH_TTY != '' ? $USER . '@' . system('hostname -s | tr -d "\n"') : ''  )
function! LightLineHost()
  return winwidth(0) > 80 ? s:hostname_and_user : ''
endfunction

" }}}

" neovim {{{
if has('nvim')
  lua require'plugins'
  " nvim-cmp
  set completeopt=menuone,noselect

endif

" }}}

" startify {{{
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

" }}}

" vim-gitgutter {{{
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

" }}}

" vim-surround {{{
let g:surround_no_insert_mappings = 0

" }}}

" vim-bbye {{{
nmap <leader>bd :Bdelete<CR>
nmap <leader>bD :Bdelete!<CR>

" }}}

" nvim-blame-line {{{
nmap <silent> <leader>gb :ToggleBlameLine<CR>
nmap <silent> <leader>gl :SingleBlameLine<CR>

" }}}

" edita.vim {{{
let g:edita_enable = 1
let g:edita#opener = "edit"
" }}}

" buftabline {{{
let g:buftabline_show = 1
let g:buftabline_indicators = 1
" }}}

" vim: set sw=2 ts=2 ft=vim expandtab fdm=marker fmr={{{,}}} fdl=0 fdls=-1:
