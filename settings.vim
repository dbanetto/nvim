" general
set title
set virtualedit=onemore
set spelllang=en
set splitbelow
set splitright
set number
set hidden

" Disable back & swap
set nobackup
set nowb
set noswapfile

" diff
set diffopt+=iwhite
set diffopt=filler

" wildmode
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*
set wildignore+=*/tmp/librarian/*,*/.vagrant/*,*/.kitchen/*,*/vendor/cookbooks/*
set wildignore+=*/tmp/cache/assets/*/sprockets/*,*/tmp/cache/assets/*/sass/*
set wildignore+=*.swp,*~,._*

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

" tab width
set smarttab
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

" warp
set display=lastline
set formatoptions=tcroql
set lbr
set nojoinspaces
set wrap
set textwidth=0
let &sbr = nr2char(8618).' ' " Show ↪ at the beginning of wrapped lines

" search
set wrapscan
set hlsearch
set ignorecase
set incsearch
set magic
set matchpairs+=<:>
set matchtime=2
set showmatch
set smartcase

" map
let g:mapleader=","

" jump to start/end of line
noremap H ^
noremap L $

" buffers
nmap bd :bdelete<CR>
nmap bn :bnext<CR>
nmap bp :bprevious<CR>

" Keep search pattern at the center of the screen
nmap <silent> n nzz
nmap <silent> N Nzz
nmap <silent> * *zz
nmap <silent> # #zz
nmap <silent> g* g*zz
nmap <silent> g# g#zz

" clear hlsearch
nmap <silent> <leader>/ :let @/=""<CR>

" autocmd

" FileType settings
augroup filetypedetect
  au FileType markdown,pandoc setl wrap tw=79 spell
  au FileType python setl ts=4 sw=4 sts=4 et
  au FileType ruby setl ts=2 sw=2 sts=2 et
  au FileType javascript,json,coffeescript setl ts=2 sw=2 sts=2
  au FileType html,css setl ts=2 sw=2 sts=2
  au FileType vim setl ts=2 sw=2 sts=2
  au FileType plaintex setl wrap tw=79 fo=tcqor
  au FileType cpp,c setl cindent
  au FileType make setl ts=4 sts=4 sw=4 noet list
  au FileType gitcommit setl wrap tw=72 spell
augroup END

" vim: set ts=2 sw=2 expandtab:
