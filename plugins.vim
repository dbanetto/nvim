" bootstrap plug.vim
let s:bootstrapping = 0
if empty(glob($NVIM_HOME.'/autoload/plug.vim'))
  silent !curl -fLo $NVIM_HOME/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let s:bootstrapping = 1
endif

function! DoRemotePlugins(arg)
  if has('nvim')
    UpdateRemotePlugins
  endif
endfunction

call plug#begin($NVIM_HOME.'/bundles/')

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
Plug 'moll/vim-bbye'
Plug 'Shougo/echodoc.vim'

" dev
if has('nvim')
  " denite
  Plug 'Shougo/denite.nvim', {'do' : function('DoRemotePlugins')}

  " deoplete
  Plug 'Shougo/deoplete.nvim',     {'do' : function('DoRemotePlugins')}
  Plug 'zchee/deoplete-go',        {'for': 'go'}
  Plug 'Shougo/neco-vim',          {'for': 'vim'}
  Plug 'zchee/deoplete-jedi',      {'for': 'python'}
endif

Plug 'w0rp/ale'
Plug 'Chiel92/vim-autoformat'
Plug 'sgur/vim-editorconfig'

" language servers
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" syntax
Plug 'ap/vim-css-color', {'for': ['css','scss']}
Plug 'sheerun/vim-polyglot'
Plug 'fatih/vim-go', { 'for': ['go']}

" colorscheme
Plug 'zyphrus/vim-hybrid'

if filereadable($NVIM_HOME."/env.plug.vim")
  source $NVIM_HOME/env.plug.vim
endif

call plug#end()

if s:bootstrapping == 1
  echo 'bootstrapping plugins'
  PlugInstall
endif

"" Configuration

" colorscheme
set background=dark
colorscheme hybrid

" lightline
let g:lightline = {
      \ 'colorscheme': 'PaperColor',
      \ 'mode_map': { 'c': 'NORMAL' },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ],
      \   'right': [ [ 'lineinfo' ], [ 'percent', 'host' ], [ 'ale', 'fileformat', 'fileencoding', 'filetype' ] ]
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
      \   'ale': 'LightLineAle',
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

function! LightLineAle()
  if winwidth(0) <= 80 || !exists("*ale#statusline#Count")
    return ''
  endif

  let l:counts = ale#statusline#Count(bufnr(''))

  let l:status = ''
  if ale#engine#IsCheckingBuffer(bufnr(''))
    let l:status = 'Linting'
  elseif l:counts.total > 0
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors
    if l:all_errors > 0
      let l:status = '✖:' . l:all_errors
    endif
    if l:all_non_errors > 0
      let l:status = ' ⚠:' . l:all_non_errors
    endif
  endif

  return l:status
endfunction

let s:hostname_and_user = ( $SSH_TTY != '' ? $USER . '@' . system('hostname -s | tr -d "\n"') : ''  )
function! LightLineHost()
  return winwidth(0) > 80 ? s:hostname_and_user : ''
endfunction

"" denites
if has('nvim')
  " custom sources
  if executable('rg')
    call denite#custom#var('file_rec', 'command',
          \ ['rg', '--files', '--glob', '!.git'])

    call denite#custom#var('grep', 'command', ['rg'])
    call denite#custom#var('grep', 'default_opts',
          \ ['--vimgrep', '--no-heading'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])
  endif

  call denite#custom#alias('source', 'file_rec/git', 'file_rec')
  call denite#custom#var('file_rec/git', 'command',
        \ ['git', 'ls-files', '-co', '--exclude-standard'])

  " matchers
  call denite#custom#var('file_rec', 'matchers',
        \ ['matcher_ignore_globs', 'matcher_fuzzy'])
  call denite#custom#option('default', 'prompt', '>')

	" Movement
	call denite#custom#map(
	      \ 'insert',
	      \ '<C-j>',
	      \ '<denite:move_to_next_line>',
	      \ 'noremap'
	      \)
	call denite#custom#map(
	      \ 'insert',
	      \ '<C-k>',
	      \ '<denite:move_to_previous_line>',
	      \ 'noremap'
	      \)

  " mappings
  nmap <leader>ub :Denite buffer<CR>
  nmap <leader>ul :Denite line<CR>
  nmap <leader>ug :Denite grep<CR>
  " check if in git dir by using fugitive's b:git_dir variable
  nmap <leader>uf :Denite `exists('b:git_dir') ? 'file_rec/git' : 'file_rec'`<CR>
endif

" buftabline
let g:buftabline_show = 1
let g:buftabline_indicators = 1

" deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#max_menu_width = 40

" ale
let g:ale_linters = {'rust': ['rls']}
let g:ale_rust_rls_toolchain = 'stable'

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

" LanguageClient
let g:LanguageClient_serverCommands = {
      \ 'rust': ['rls'],
      \ }
" lazily start language server on entry
au FileType rust LanguageClientStart<CR>

au FileType rust nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
au FileType rust nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
au FileType rust nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

function! SetRustPath()
  if $RUST_SRC_PATH == ''
    let $RUST_SRC_PATH = substitute(system('rustc --print sysroot'), '.$', '/lib/rustlib/src/rust/src', '')
  endif
endfunction
au FileType rust call SetRustPath()

" echodoc
let g:echodoc#enable_at_startup = 1

" vim: set sw=2 ts=2 ft=vim expandtab:
