" :help 'opintion' for explaining
set encoding=utf-8
set termencoding=utf-8
set fileencodings=utf-8,gbk,gb18030,gb2312
set fileformat=unix

set history=512
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

" foldmethod
set foldmethod=indent   
" set foldnestmax=10
set nofoldenable
" set foldlevel=2
set cursorline

" Vertical bar in insert mode
let &t_SI = "\<Esc>]50;CursorShape=1\x7" " 
" Block in normal mode
let &t_EI = "\<Esc>]50;CursorShape=0\x7" " 
colorscheme desert
" 256 color
set t_Co=256
" turn off bell
set noeb

" set nobackup
" set nowritebackup
" set noswapfile
set autowriteall
set clipboard+=unnamed
set autoread

" jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" autoreload vimrc after it change
" may not work if it's a soft-link.
" autocmd! bufwritepost .vimrc source %

syntax on
filetype on
filetype plugin on
filetype indent on

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

" persional shortcuts ==========
" sudo saves the file 
" nnoremap <leader>W :!sudo tee % > /dev/null
inoremap <expr> <tab> InsertTabWrapper()

inoremap <C-e> <C-o>$
inoremap <C-a> <C-o>^

" inoremap jj <esc><esc>
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
