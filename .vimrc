" Basic Vim configuration for public dotfiles
" Generic settings safe for public sharing

" Basic settings
set nocompatible
set number
set relativenumber
set ruler
set showcmd
set showmatch
set incsearch
set hlsearch
set ignorecase
set smartcase
set autoindent
set smartindent
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2
set backspace=indent,eol,start
set scrolloff=8
set sidescrolloff=8
set laststatus=2
set wildmenu
set wildmode=longest,list,full
set encoding=utf-8

" Color scheme
syntax enable
set background=dark
colorscheme default

" Key mappings
let mapleader = " "
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Clear search highlighting
nnoremap <leader>/ :nohlsearch<CR>

" Better movement for wrapped lines
nnoremap j gj
nnoremap k gk

" Quick edit vimrc
nnoremap <leader>ev :edit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" File type settings
filetype plugin indent on

" Auto commands
if has("autocmd")
  " Jump to last position when reopening a file
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif