" ===========================
" General
" ===========================
set nocompatible
syntax on
filetype plugin indent on

if has('termguicolors')
    set termguicolors
endif
set background=dark
let ayucolor="dark"
colorscheme ayu

set number
set relativenumber
set mouse=a
set clipboard=unnamedplus

set tabstop=4
set shiftwidth=4
set expandtab
set smartindent

set splitright
set splitbelow

set hidden
set nowrap

let mapleader=" "

" ===========================
" Window navigation
" ===========================
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" ===========================
" Open CP Layout
" ===========================
function! CPLayout()
    " Left window: current file
    only

    " Right split
    vsplit input.txt

    " Bottom-right split
    wincmd l
    split output.txt

    " Return to code
    wincmd h
endfunction

nnoremap <leader>cp :call CPLayout()<CR>

" ===========================
" Compile & Run
" ===========================
function! RunCPP()
    write

    silent !mkdir -p .build

    silent execute '!clang++ -std=c++20 -O2 % -o .build/main'

    if v:shell_error
        echo "Compilation failed"
        return
    endif

    silent execute '!.build/main < input.txt > output.txt'

    " Reload output if it's open
    silent! bufdo if expand("%") ==# "output.txt" | edit | endif

    echo "Done"
endfunction

nnoremap <F5> :call RunCPP()<CR>
