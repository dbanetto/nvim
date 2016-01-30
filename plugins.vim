" bootstrap plug.vim
if empty(glob('$NVIM_HOME/autoload/plug.vim'))
  silent !curl -fLo $NVIM_HOME/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin(expand('$NVIM_HOME/bundles/'))

" general
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
Plug 'mhinz/vim-startify'
Plug 'Shougo/vimproc.vim', {'do': 'make'}
Plug 'Shougo/unite.vim'
Plug 'zyphrus/unite-tasklist'
Plug 'Shougo/vimfiler.vim'
Plug 'matze/vim-move'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'terryma/vim-multiple-cursors'
Plug 'mbbill/undotree'
Plug 'Shougo/unite-session'

" dev
Plug 'Shougo/deoplete.nvim'
Plug 'benekastah/neomake'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'Chiel92/vim-autoformat'

" sys dev
Plug 'phildawes/racer', {'do': 'cargo build --release' } | Plug 'racer-rust/vim-racer', {'for': 'rust'}

" web dev
Plug 'tpope/vim-rails', {'for': ['ruby', 'eruby']}
Plug 'tpope/vim-bundler', {'for': ['ruby', 'eruby']}
Plug 'davidhalter/jedi-vim', {'for': ['python', 'django']}
Plug 'vim-scripts/django.vim'

" syntax
Plug 'tpope/vim-git'
Plug 'rust-lang/rust.vim'
Plug 'vim-jp/vim-cpp', {'for': 'cpp'}
Plug 'JulesWang/css.vim', {'for': 'css'}
Plug 'othree/html5.vim', {'for': 'html'}
Plug 'mitsuhiko/vim-python-combined', {'for': 'python'}
Plug 'vim-ruby/vim-ruby', {'for': ['ruby', 'eruby']}
Plug 'cespare/vim-toml', {'for': 'toml'}
Plug 'pangloss/vim-javascript', {'for': 'javascript'}
Plug 'leshill/vim-json', {'for': ['json', 'javascript']}
Plug 'avakhov/vim-yaml', {'for': 'yaml'}

" colorscheme
Plug 'w0ng/vim-hybrid'

call plug#end()

" plugin configuration

" colorscheme
set background=dark
colorscheme hybrid

" airline
let g:airline_extensions = ['branch', 'tabline']
let g:airline#extensions#branch#enabled = 1

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''

let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_section_c = ''
let g:airline_theme='jellybeans'

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
if !exists('g:airline_powerline_fonts')
  let g:airline_symbols.branch = ''
  let g:airline_symbols.linenr = ''
endif

" unite
let g:unite_prompt='> '
let g:unite_split_rule = 'botright'
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#custom#source(
      \ 'file_rec,file_rec/git,file_rec/neovim,file_rec/neovim2', 'matchers',
      \ ['matcher_fuzzy', 'matcher_hide_hidden_files','converter_relative_word',
      \  'matcher_hide_current_file', 'matcher_project_ignore_files'])
call unite#filters#sorter_default#use(['sorter_selecta'])
nmap <silent> <C-p> :Unite -start-insert -buffer-name=files file_rec/neovim2<CR>
nmap <silent> <A-p> :Unite -start-insert -buffer-name=files file_rec/git<CR>
nmap <silent><leader>cb :Unite -buffer-name=buffers buffer<CR>
nmap <silent><leader>ct :Unite -buffer-name=tabs tab<CR>
nmap <silent><leader>cl :Unite -buffer-name=tasklist tasklist<CR>
nmap <silent><leader>c; :Unite -start-insert -buffer-name=commands command<CR>

" vimfiler
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_marked_file_icon = '✓'
let g:vimfiler_ignore_pattern = ['^\.', '.*\.pyc$', '^__.*__$']
nmap <silent> <C-o> :VimFiler -buffer-name=VimFiler -status -project -split -toggle -winwidth=30<CR>

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
let g:startify_change_to_dir = 0
let g:startify_change_to_vcs_root = 1
let g:startify_relative_path = 1
let g:startify_custom_header = map(split(system('pwd'), '\n'), '"   ". v:val') + ['','']
let g:startify_custom_indices = map(range(1,100), 'string(v:val)')
let g:startify_list_order = [
      \ ['   Most recently used in this directory:'],
      \ 'dir',
      \ ['   Most recently used:'],
      \ 'files',
      \ ]

" ruby
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1

" racer
let g:racer_cmd = $NVIM_HOME.'/bundles/racer/target/release/racer'
let $RUST_SRC_PATH='/usr/src/rust/src'

" vim-gitgutter
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '*'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_modified_removed = '~'
let g:gitgutter_realtime = 0
nmap [h :GitGutterPrevHunk<CR>zz
nmap ]h :GitGutterNextHunk<CR>zz

" undotree
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_WindowLayout = 3
nmap <silent>U :UndotreeToggle<CR>

" jedi
let g:jedi#goto_command = "<leader>pd"
let g:jedi#goto_assignments_command = "<leader>pg"
let g:jedi#goto_definitions_command = "<leader>pd"
let g:jedi#completions_command = ""
let g:jedi#documentation_command = "<leader>pk"
let g:jedi#usages_command = "<leader>pn"
let g:jedi#rename_command = "<leader>pr"
let g:jedi#popup_on_dot = 0
let g:jedi#auto_vim_configuration = 0

" omnicompleteion
autocmd FileType css           setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType haskell       setlocal omnifunc=necoghc#omnifunc
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript    setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python        setlocal omnifunc=pythoncomplete#Complete
autocmd FileType ruby          setlocal omnifunc=rubycomplete#Complete
autocmd FileType xml           setlocal omnifunc=xmlcomplete#CompleteTags

" vim: set ts=2 sw=2 expandtab:
