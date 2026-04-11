filetype off

call plug#begin('~/.vim/plugged')
Plug 'ctrlpvim/ctrlp.vim'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'rust-lang/rust.vim'
Plug 'LnL7/vim-nix'
call plug#end()

let g:jsx_ext_required=0

"Enable filetypes
filetype plugin indent on
syntax on

"Write the old file out when switching between files.
set autowrite

"Display current cursor position in lower right corner.
set ruler

"Want a different map leader than \
let mapleader = ","

"Ever notice a slight lag after typing the leader key + command? This lowers
"the timeout.
set timeoutlen=500

"Switch between buffers without saving
set hidden
set encoding=utf-8
set scrolloff=3
set wildmenu
set wildmode=list:longest
set cursorline
set backspace=indent,eol,start
set undofile

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
set relativenumber"

"Indent stuff
set autoindent

"Always show the status line
set laststatus=2

"Better line wrapping
set wrap
"set textwidth=119
"set formatoptions=qrn1
set colorcolumn=120

"Set incremental searching"
set incsearch

"Highlight searching
set hlsearch
set showmatch
nnoremap <leader><space> :noh<cr>

" case insensitive search
set ignorecase
set smartcase

set clipboard=unnamedplus

set updatetime=300
set signcolumn=yes
set noshowmode

nnoremap <leader>w :w<cr>

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap j gj
nnoremap k gk

inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

set undodir=/tmp//
set directory=/tmp//
set backupdir=/tmp//

let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

autocmd Filetype html setlocal ts=2 sw=2 expandtab
autocmd Filetype ruby setlocal ts=2 sw=2 expandtab
autocmd Filetype javascript setlocal ts=2 sw=2 sts=0 expandtab

if has('termguicolors')
    set termguicolors
endif

set background=dark

colorscheme catppuccin_mocha
highlight Visual guibg=#313244 guifg=NONE ctermbg=8 ctermfg=NONE
