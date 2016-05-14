" general
set title
set virtualedit=onemore
set spelllang=en
set splitbelow
set splitright
set number
set hidden
set autoread

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

" default tab settings
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

" folding
set foldmethod=indent
set foldlevelstart=1

set completeopt-=preview

"" mappings
let g:mapleader=","

" jump to start/end of line
noremap H ^
noremap L $

" buffers
nmap bd :bdelete<CR>
nmap bn :bnext<CR>
nmap bp :bprevious<CR>
" closes current buffer http://stackoverflow.com/questons/4298910
nmap bc :b#<bar>bd#<CR>
nmap bl :b#<CR>

" tabs
nmap td :tabclose<CR>
nmap tw :tabnew<CR>
nmap tn :tabnext<CR>
nmap tp :tabprevious<CR>

nnoremap K <C-U>zz
nnoremap J <C-D>zz

" nvim terminal
if has('nvim')
  tmap <Esc> <C-\><C-n>

  " pane navigation
  tmap <A-h> <C-\><C-n><C-w>h
  tmap <A-j> <C-\><C-n><C-w>j
  tmap <A-k> <C-\><C-n><C-w>k
  tmap <A-l> <C-\><C-n><C-w>l
endif

" pane navigation
nmap <A-h> <C-w>h
nmap <A-j> <C-w>j
nmap <A-k> <C-w>k
nmap <A-l> <C-w>l

" Keep search pattern at the center of the screen
nmap <silent> n nzz
nmap <silent> N Nzz
nmap <silent> * *zz
nmap <silent> # #zz
nmap <silent> g* g*zz
nmap <silent> g# g#zz

" clear hlsearch
nmap <silent> <leader>/ :let @/=""<CR>

" cd to current file
nmap <leader>cd :cd %:h<CR>:pwd<CR>

" toggle list
nmap <leader>tl :set list!<CR>:set list?<CR>

" toggle spell
nmap <leader>ts :set spell!<CR>:set spell?<CR>

" toggle relative number
nmap <leader>tr :set relativenumber!<CR>:set relativenumber?<CR>

" toggle relative number
nmap <leader>tw :set wrap!<CR>:set wrap?<CR>

"" commands
command! W w!
command! Q q!

" training
command! Wq echo "Use :x"
command! WQ echo "Use :x"

"" autocmd
" normal mode when focus is lost
au FocusLost * call feedkeys("\<C-\>\<C-n>") 

" FileType settings
au FileType markdown,pandoc setl wrap tw=79 spell
au FileType python setl ts=4 sw=4 sts=4 et
au FileType ruby,eruby setl ts=2 sw=2 sts=2 et
au FileType javascript,json,coffeescript,pug,jsx setl ts=2 sw=2 sts=2
au FileType html,css setl ts=2 sw=2 sts=2
au FileType vim setl ts=2 sw=2 sts=2
au FileType plaintex setl wrap tw=79 fo=tcqor
au FileType cpp,c setl cindent
au FileType make setl ts=4 sts=4 sw=4 noet list
au FileType gitcommit setl wrap tw=72 spell

au FileType help nmap q :q<CR>

" vim:ts=2:sw=2:expandtab:
