" bootstrap plug.vim
if empty(glob('$NVIM_HOME/autoload/plug.vim'))
  silent !curl -fLo $NVIM_HOME/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin(expand('$NVIM_HOME/bundles/'))

if !exists('g:bundle_groups')
  let g:bundle_groups=['general', 'colorscheme', 'devel', 'syntax']
endif

if count(g:bundle_groups, 'general')
  Plug 'mhinz/vim-startify'
endif

if count(g:bundle_groups, 'devel')
  Plug 'benekastah/neomake'
  Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
  Plug 'Shougo/deoplete.nvim'
endif

if count(g:bundle_groups, 'syntax')
  Plug 'kergoth/aftersyntaxc.vim', {'for': ['c', 'cpp']}
  Plug 'octol/vim-cpp-enhanced-highlight', {'for': 'cpp'}
  Plug 'vim-jp/vim-cpp', {'for': 'cpp'}
  Plug 'kchmck/vim-coffee-script'
  Plug 'JulesWang/css.vim', {'for': 'css'}
  Plug 'tpope/vim-git'
  Plug 'othree/html5.vim', {'for': 'html'}
  Plug 'pangloss/vim-javascript', {'for': 'javascript'}
  Plug 'leshill/vim-json', {'for': ['json', 'javascript']}
  Plug 'groenewege/vim-less', {'for': 'less'}
  Plug 'mutewinter/nginx.vim'
  Plug 'mitsuhiko/vim-python-combined', {'for': 'python'}
  Plug 'vim-ruby/vim-ruby', {'for': ['ruby', 'eruby']}
  Plug 'rust-lang/rust.vim'
  Plug 'cespare/vim-toml', {'for': 'toml'}
  Plug 'kurayama/systemd-vim-syntax'
  Plug 'leafgarland/typescript-vim', {'for': 'typescript'}
  Plug 'vim-scripts/django.vim'
  Plug 'raichoo/haskell-vim', {'for': 'haskell'}
  Plug 'avakhov/vim-yaml', {'for': 'yaml'}
endif

if count(g:bundle_groups, 'colorscheme')
  Plug 'w0ng/vim-hybrid'
endif

call plug#end()
" vim: set ts=2 sw=2 expandtab:
