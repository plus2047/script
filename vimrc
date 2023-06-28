" :help 'opintion' for explaining

syntax on
filetype on
filetype plugin on
filetype indent on
set noeb
set history=512

" appearance
" ==========

set wildmenu
set wildmode=longest,full
set showcmd

set number
set ruler
set scrolloff=3
set hlsearch
set showmatch
set ignorecase
set smartcase

set nocompatible
set autoindent
set smartindent
set cindent
set backspace=indent,eol,start
set whichwrap+=<,>,[,],b

set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

set statusline=%F%m%r%h%w\ [TYPE=%Y]\ [POS=%l,%v][%p%%]
set laststatus=2

set nofoldenable
" set foldmethod=indent   
" set foldnestmax=10
" set foldlevel=2

" highlight the cursor line
set cursorline
 
" file read/write
" ===============
 
set encoding=utf-8
set termencoding=utf-8
set fileencodings=utf-8,gbk,gb18030,gb2312
set fileformat=unix

set nobackup
set nowritebackup
set noswapfile
set autowriteall
set clipboard+=unnamed
set autoread

" autoreload vimrc after it change, may not work if it's a soft-link.
" autocmd! bufwritepost .vimrc source %

" sudo saves the file 
" nnoremap <leader>W :!sudo tee % > /dev/null

" jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" set tab for auto complete
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
set completeopt=longest,menuone
inoremap <expr> <tab> InsertTabWrapper()

" persional shortcuts ==========

" inoremap jj <esc><esc>
inoremap <C-e> <C-o>$
inoremap <C-a> <C-o>^

nnoremap <cr> :
tnoremap <Esc> <C-\><C-n>

let mapleader = " "
nnoremap <leader><cr> :noh<cr>
nnoremap <leader>p :set paste!<cr>
nnoremap <leader>n :set number!<cr>
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

