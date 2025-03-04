"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on                   " Enable syntax highlighting
set number                  " Show line numbers
set relativenumber          " Show relative line numbers
set autoindent              " Auto-indent new lines
set smartindent             " Smart indent new lines
set expandtab               " Use spaces instead of tabs
set tabstop=2               " Number of spaces per tab
set shiftwidth=2            " Number of spaces for indent
set smarttab                " Smart tab handling
set softtabstop=2           " Number of spaces in tab when editing
set mouse=a                 " Enable mouse in all modes
set backspace=indent,eol,start " Make backspace work as expected
set clipboard=unnamed       " Use system clipboard
set hidden                  " Allow switching buffers without saving
set lazyredraw              " Don't redraw screen during macros
set ttyfast                 " Faster terminal rendering
set showmatch               " Highlight matching brackets
set wildmenu                " Show command line completion options
set wildmode=list:longest,full " Complete to longest common string, then show all options
set encoding=utf-8          " Use UTF-8 encoding
set fileencoding=utf-8      " Use UTF-8 file encoding

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Search Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set hlsearch                " Highlight search results
set incsearch               " Start searching as you type
set ignorecase              " Ignore case in search patterns
set smartcase               " Override ignorecase if search pattern has upper case

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => User Interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set cursorline              " Highlight the current line
set ruler                   " Show cursor position
set showcmd                 " Show commands as you type them
set showmode                " Show current mode
set laststatus=2            " Always show status line
set scrolloff=3             " Keep 3 lines above/below cursor
set sidescrolloff=5         " Keep 5 columns to the left/right of cursor
set cmdheight=1             " Height of the command bar
set title                   " Show file title in terminal window

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Key Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = ","         " Set leader key to comma

" Quick escape from insert mode
inoremap jk <ESC>

" Quick save
nnoremap <leader>w :w<CR>

" Quick quit
nnoremap <leader>q :q<CR>

" Clear search highlighting
nnoremap <leader><space> :nohlsearch<CR>

" Navigate splits with CTRL + hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Navigate between buffers
nnoremap <leader>n :bnext<CR>
nnoremap <leader>p :bprevious<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Filetype Specific
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin on          " Enable filetype plugins
filetype indent on          " Enable filetype-specific indentation

" Ansible settings
au BufRead,BufNewFile */playbooks/*.yml set filetype=yaml.ansible
au BufRead,BufNewFile */roles/*/tasks/*.yml set filetype=yaml.ansible
au BufRead,BufNewFile */inventory/* set filetype=yaml.ansible

" Python settings
au FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Autocommands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Return to last edit position when opening files
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Auto remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Performance
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set timeout timeoutlen=1000 ttimeoutlen=10
set updatetime=300          " Faster completion

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
try
  colorscheme desert
catch
endtry

set background=dark
