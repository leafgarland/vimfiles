filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

syntax on                           " syntax highlighing
filetype on                          " try to detect filetypes
filetype plugin indent on    " enable loading indent file for filetype

" MakeGreen
map <Leader>] <Plug>MakeGreen

au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"
set completeopt=menuone,longest,preview

set nocompatible

" Security
set modelines=0

" Tabs/spaces
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" Basic options
set encoding=utf-8
set scrolloff=3
set autoindent
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set relativenumber
set laststatus=2
" set undofile

" Backups
" set backupdir=$VIM/tmp/backup// " backups
set directory=~/.vim/tmp/swap//  " swap files
set undodir=~/.vim/tmp/undo//
" set backup                      " enable backups

" Leader
let mapleader = ","

" Searching
nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch
set gdefault
map <leader><space> :noh<cr>
runtime macros/matchit.vim
nmap <tab> %
vmap <tab> %

" Soft/hard wrapping
set wrap
set textwidth=79
set formatoptions=qrn1
set colorcolumn=100

" xml syntax folding
let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax

" Color scheme (terminal)
syntax on
colorscheme solarized
set background=dark

" NERD Tree
map <F2> :NERDTreeToggle<cr>
let NERDTreeIgnore=['.vim$', '\~$', '.*\.pyc$', 'pip-log\.txt$']

" And make them fucking work, too.
nnoremap j gj
nnoremap k gk

" Easy buffer navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
map <leader>w <C-w>v<C-w>l

" Folding
set foldlevelstart=0
nnoremap <Space> za
vnoremap <Space> za
au BufNewFile,BufRead *.html map <leader>ft Vatzf

function! MyFoldText()
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - 4
    return line . '.' . repeat(" ",fillcharcount) . foldedlinecount . '.' . ' '
endfunction
set foldtext=MyFoldText()

" Fuck you, help key.
" set fuoptions=maxvert,maxhorz
inoremap <F1> <ESC>:set invfullscreen<CR>a
nnoremap <F1> :set invfullscreen<CR>
vnoremap <F1> :set invfullscreen<CR>

" Clean whitespace
map <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" Exuberant ctags!
let Tlist_Ctags_Cmd = "ctags"
let Tlist_WinWidth = 50
map <F4> :TagbarToggle<cr>
map <F5> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --exclude='@.ctagsignore' .<cr>

" Ack
map <leader>a :Ack 

" Yankring
nnoremap <silent> <F3> :YRShow<cr>
nnoremap <silent> <leader>y :YRShow<cr>
let g:yankring_history_dir = "$HOME/.vim/"

" Formatting, TextMate-style
map <leader>q gqip

nmap <leader>m :make<cr>

" Easier linewise reselection
map <leader>v V`]

" Faster Esc
"inoremap <Esc> <nop>
inoremap jj <ESC>

map <leader>g :GundoToggle<CR>

" Edit .vimrc
nmap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>

" Disable useless HTML5 junk
let g:event_handler_attributes_complete = 0
let g:rdfa_attributes_complete = 0
let g:microdata_attributes_complete = 0
let g:atia_attributes_complete = 0

" Shouldn't need shift
nnoremap ; :

" Save when losing focus
au FocusLost * :wa

" Stop it, hash key
inoremap # X<BS>#

if has('gui_running')
    set guifont=Consolas:h12
    colorscheme solarized
    set background=dark
    set lines=60
    set columns=100

    set go-=T
    set go-=l
    set go-=L
    set go-=r
    set go-=R

    highlight SpellBad term=underline gui=undercurl guisp=Orange
endif

