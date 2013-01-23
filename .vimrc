"Forget compatibility with Vi. Who cares.
set nocompatible

"Enable filetypes
filetype on
filetype plugin on
filetype indent on
syntax on

"Write the old file out when switching between files.
set autowrite

"Display current cursor position in lower right corner.
set ruler

"Want a different map leader than \
"set mapleader = ",";

"Ever notice a slight lag after typing the leader key + command? This lowers
"the timeout.
set timeoutlen=500

"Switch between buffers without saving
set hidden

"Set the color scheme. Change this to your preference.
"Here's 100 to choose from: http://www.vim.org/scripts/script.php?script_id=625
"colorscheme twilight

"Set font type and size. Depends on the resolution. Larger screens, prefer h20
set guifont=Menlo:h20

"Tab stuff
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

"Show command in bottom right portion of the screen
set showcmd

"Show lines numbers
set number

"Prefer relative line numbering?
"set relativenumber"

"Indent stuff
set smartindent
set autoindent

"Always show the status line
set laststatus=2

"Prefer a slightly higher line height
set linespace=3

"Better line wrapping
set wrap
set textwidth=119
set formatoptions=qrn1

"Set incremental searching"
set incsearch

"Highlight searching
set hlsearch

" case insensitive search
set ignorecase
set smartcase

set directory=/tmp
set backupdir=/tmp

colorscheme darkblue
