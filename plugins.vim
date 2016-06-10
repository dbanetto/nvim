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
Plug 'Shougo/vimproc.vim', {'do': 'make'}
Plug 'Shougo/unite.vim'
Plug 'Shougo/unite-session'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-unimpaired'
Plug 'Shougo/vimfiler.vim'
Plug 'airblade/vim-gitgutter'
Plug 'mbbill/undotree'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'zyphrus/unite-tasklist'

" dev
Plug 'Shougo/deoplete.nvim', {'do': function('DoRemotePlugins') }
Plug 'neomake/neomake'
Plug 'lilydjwg/tagbar'
Plug 'Chiel92/vim-autoformat'

" sys dev
Plug 'phildawes/racer', {'do': 'cargo build --release' } | Plug 'racer-rust/vim-racer', {'for': 'rust'}

" web dev
Plug 'tpope/vim-rails', {'for': ['ruby', 'eruby']}
Plug 'tpope/vim-bundler', {'for': ['ruby', 'eruby']}
Plug 'basyura/unite-rails', {'for': ['ruby', 'eruby']}
Plug 'jelera/vim-javascript-syntax', {'for': 'javascript'}
Plug 'moll/vim-node', {'for': 'javascript'}
Plug 'zchee/deoplete-jedi', {'for': 'javascript'}
Plug 'tweekmonster/django-plus.vim', {'for': 'python'}

" writing
Plug 'vim-pandoc/vim-pandoc'

" syntax
Plug 'tpope/vim-git'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'tmux-plugins/vim-tmux'
Plug 'rust-lang/rust.vim'
Plug 'vim-ruby/vim-ruby', {'for': ['ruby', 'eruby']}
Plug 'vim-jp/vim-cpp', {'for': 'cpp'}
Plug 'JulesWang/css.vim', {'for': 'css'}
Plug 'othree/html5.vim', {'for': 'html'}
Plug 'cespare/vim-toml', {'for': 'toml'}
Plug 'pangloss/vim-javascript', {'for': 'javascript'}
Plug 'leshill/vim-json', {'for': ['json', 'javascript']}
Plug 'avakhov/vim-yaml', {'for': 'yaml'}
Plug 'mxw/vim-jsx'
Plug 'mustache/vim-mustache-handlebars'
Plug 'digitaltoad/vim-pug'

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
  \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
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
  \ },
  \ 'separator': { 'left': '', 'right': '' },
  \ 'subseparator': { 'left': '|', 'right': '|' }
  \ }

function! LightLineModified()
  return &ft =~ 'help\|vimfiler' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightLineReadonly()
  return &ft !~? 'help\|vimfiler' && &readonly ? 'X' : ''
endfunction

function! LightLineFilename()
  return ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFugitive()
  if &ft !~? 'vimfiler' && exists("*fugitive#head")
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

" buftabline
let g:buftabline_show = 1

" unite
let g:unite_prompt='> '
let g:unite_split_rule = 'botright'
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#custom#source(
      \ 'file_rec,file_rec/async,file_rec/git,file_rec/neovim', 'matchers',
      \ ['matcher_fuzzy', 'matcher_hide_hidden_files','converter_relative_word',
      \  'matcher_hide_current_file', 'matcher_project_ignore_files'])
call unite#filters#sorter_default#use(['sorter_selecta'])
nmap <silent> <C-p> :Unite -start-insert -buffer-name=files file_rec/async<CR>
nmap <silent> <A-p> :Unite -start-insert -buffer-name=files file_rec/git<CR>
nmap <silent><leader>cb :Unite -buffer-name=buffers buffer<CR>
nmap <silent><leader>ct :Unite -buffer-name=tabs tab<CR>
nmap <silent><leader>cl :Unite -buffer-name=tasklist tasklist<CR>
nmap <silent><leader>c; :Unite -start-insert -buffer-name=commands command<CR>
" unite-rails
nmap <silent><leader>cr :Unite -start-insert -buffer-name=rails rails/
nmap <silent><leader>crm :Unite -start-insert -buffer-name=rails rails/model<CR>
nmap <silent><leader>crc :Unite -start-insert -buffer-name=rails rails/controller<CR>
nmap <silent><leader>crv :Unite -start-insert -buffer-name=rails rails/view<CR>

" vimfiler
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_marked_file_icon = '✓'
let g:vimfiler_ignore_pattern = ['^\.', '.*\.pyc$', '^__.*__$', '^node_modules$']
nmap <silent> <C-o> :VimFiler -buffer-name=VimFiler -status -project -split -toggle -winwidth=30<CR>
" project draw-like functionality
nmap <silent> - :VimFilerBufferDir -find -force-quit -buffer-name=drawer<CR>

call vimfiler#custom#profile('default', 'context', {
      \  'safe': 0,
      \  'explorer': 1,
      \  'auto_expand': 1,
      \  'no_quit': 1
      \ })

" deoplete
let g:deoplete#enable_at_startup = 1

" neomake
autocmd! BufWritePost * Neomake

" autoformat
nmap <leader>ff :Autoformat<CR>

" ultisnips
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<c-j>'
let g:UltiSnipsJumpBackwardTrigger = '<c-k>'
let g:UltiSnipsEditSplit='vertical'

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

" ruby
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1

" racer
let g:racer_cmd = $NVIM_HOME.'/bundles/racer/target/release/racer'

" vim-gitgutter
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '*'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_modified_removed = '~'
let g:gitgutter_realtime = 0
nmap [h :GitGutterPrevHunk<CR>zz
nmap ]h :GitGutterNextHunk<CR>zz
nmap <leader>gh :GitGutterLineHighlightsToggle<CR>

" undotree
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_WindowLayout = 3
nmap <silent>U :UndotreeToggle<CR>

" jedi
let g:jedi#completions_enabled = 0
let g:jedi#goto_command = "<leader>pd"
let g:jedi#goto_assignments_command = "<leader>pg"
let g:jedi#goto_definitions_command = "<leader>pd"
let g:jedi#completions_command = ""
let g:jedi#documentation_command = "<leader>pk"
let g:jedi#usages_command = "<leader>pn"
let g:jedi#rename_command = "<leader>pr"
let g:jedi#auto_vim_configuration = 0

" vim-surround
let g:surround_no_insert_mappings = 0

" tagbar
let g:tagbar_width = 30
let g:tagbar_autofocus = 1
let g:tagbar_indent = 1
let g:tagbar_iconchars = ['+', '-']
nmap <C-T> :TagbarToggle<CR>

" pandoc
let g:pandoc#modules#disabled =["folding"]
let g:pandoc#syntax#conceal#use = 0

" omnicompleteion
autocmd FileType css           setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType haskell       setlocal omnifunc=necoghc#omnifunc
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript    setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python        setlocal omnifunc=pythoncomplete#Complete
autocmd FileType ruby          setlocal omnifunc=rubycomplete#Complete
autocmd FileType xml           setlocal omnifunc=xmlcomplete#CompleteTags

" vim ts=2 sw=2 expandtab
