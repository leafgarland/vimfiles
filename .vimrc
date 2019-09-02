" vim: foldlevel=0 foldmethod=marker shiftwidth=2

" Environment: {{{

augroup vimrc
  autocmd!
augroup END

if has('vim_starting')
  " quicker startup
  if exists('+guioptions')
    set guioptions=M
  endif
  let g:loaded_vimballPlugin = 1
  let g:netrw_menu = 0
  let g:loaded_netrwPlugin = 1

  " nvim vs vim
  if has('nvim')
    set shada=!,'1000,s100,h
    let &shadafile = expand(stdpath('data').'/shada/main.shada')
    set backupdir-=.
  else
    set nocompatible
    set encoding=utf-8
    set laststatus=2
    set viminfo='1000,s100,h
    set backupdir-=.
    set directory-=.
  endif
endif

"}}}

" Plugins: {{{
command! PackUpdate call PackInit() | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  call PackInit() | call minpac#clean()
command! PackStatus call PackInit() | call minpac#status()

function! PackInit()
  command! -nargs=+ Pack call minpac#add(<args>)
  packadd minpac
  call minpac#init()

  Pack 'k-takata/minpac', {'type': 'opt'}

  " Base
  if !has('nvim')
    Pack 'tpope/vim-sensible'
  endif
  Pack 'tpope/vim-repeat'
  Pack 'kana/vim-textobj-user'

  " Colour schemes and pretty things
  Pack 'leafgarland/gruvbox', {'type': 'opt'}
  Pack 'leafgarland/iceberg.vim', {'type': 'opt'}
  Pack 'leafgarland/flatwhite-vim', {'type': 'opt'}
  Pack 'andreypopp/vim-colors-plain', {'type': 'opt'}

  " Motions and actions
  Pack 'kana/vim-textobj-indent'
  Pack 'Julian/vim-textobj-variable-segment'
  Pack 'tpope/vim-commentary'
  Pack 'tpope/vim-unimpaired'
  Pack 'tommcdo/vim-exchange'
  Pack 'wellle/targets.vim'
  Pack 'AndrewRadev/splitjoin.vim'
  Pack 'tommcdo/vim-lion'
  Pack 'machakann/vim-sandwich'

  " Tools
  if has('nvim')
    Pack 'neovim/nvim.net'
  endif
  Pack 'samoshkin/vim-mergetool'
  Pack 'tpope/vim-fugitive'
  Pack 'tpope/vim-rhubarb'
  Pack 'tpope/vim-ragtag'
  Pack 'tpope/vim-scriptease'
  Pack 'justinmk/vim-dirvish'
  Pack 'chrisbra/unicode.vim'
  Pack 'romainl/vim-cool'
  Pack 'sgur/vim-editorconfig'
  Pack 'neoclide/coc.nvim', {'do': '!yarn install'}
  Pack 'OmniSharp/omnisharp-vim'
  Pack 'eraserhd/parinfer-rust', {'do': '!cargo build --release'}

  " Filetypes
  Pack 'hail2u/vim-css3-syntax'
  Pack 'othree/html5.vim'
  Pack 'elzr/vim-json'
  Pack 'tpope/vim-jdaddy'
  Pack 'vim-pandoc/vim-pandoc-syntax'
  Pack 'vim-pandoc/vim-pandoc'
  Pack 'PProvost/vim-ps1'
  Pack 'leafgarland/vim-fsharp'
  Pack 'guns/vim-clojure-static'
  Pack 'guns/vim-sexp'
  Pack 'tpope/vim-sexp-mappings-for-regular-people'
  Pack 'vim-erlang/vim-erlang-runtime'
  Pack 'vim-erlang/vim-erlang-compiler'
  Pack 'vim-erlang/vim-erlang-omnicomplete'
  Pack 'vim-erlang/vim-erlang-tags'
  Pack 'edkolev/erlang-motions.vim'
  Pack 'elixir-lang/vim-elixir'
  Pack 'pangloss/vim-javascript'
  Pack 'mxw/vim-jsx'
    " Pack 'ianks/vim-tsx'
    " Pack 'leafgarland/typescript-vim'
  Pack 'HerringtonDarkholme/yats.vim'
  Pack 'elmcast/elm-vim'
  Pack 'rust-lang/rust.vim'
  Pack 'raichoo/purescript-vim'
  Pack 'wlangstroth/vim-racket'
  Pack 'beyondmarc/glsl.vim'
  Pack 'cespare/vim-toml'
  Pack 'dleonard0/pony-vim-syntax'
  Pack 'OrangeT/vim-csharp'
  Pack 'idris-hackers/idris-vim'
  Pack 'hashivim/vim-terraform'
  Pack 'aklt/plantuml-syntax'
  Pack 'ziglang/zig.vim'
  Pack 'janet-lang/janet.vim'
  Pack 'dag/vim-fish'

  if has('nvim') && executable('fzy')
    Pack 'cloudhead/neovim-fuzzy'
  endif
endfunction

packloadall

function! s:has_plug(name)
  return &runtimepath =~ a:name
endfunction
"}}}

" General: {{{

set nomodeline
set mouse=a

set belloff=all
set shortmess+=Im
set viewoptions=folds,options,cursor,unix,slash
set history=10000
set hidden

set virtualedit=block
set nojoinspaces
set formatoptions+=n1

set backup
set undolevels=5000
set undofile

set nostartofline

set complete+=kspell

if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading\ -HS\ --line-number
  set grepformat=%f:%l:%c:%m
elseif executable('ag')
  set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow\ -C0
  set grepformat=%f:%l:%c:%m
elseif executable('pt')
  set grepprg=pt\ /nogroup\ /nocolor\ /smart-case\ /follow
  set grepformat=%f:%l:%m
endif
command! -nargs=* Grep grep <args>

if has('nvim')
  autocmd vimrc BufRead * wshada
else
  autocmd vimrc CursorHold,FocusGained,FocusLost * wviminfo
endif

"}}}

" Vim UI: {{{
if has('vim_starting')
  set background=dark
  set hlsearch
endif
set cmdheight=2
set lazyredraw

set sidescroll=1
set sidescrolloff=5
set scrolloff=5

set diffopt+=vertical,algorithm:histogram,indent-heuristic

set wildmode=longest:full,full
set wildignorecase
set wildoptions=tagfile,pum
set wildcharm=<C-z>
set number
set winminheight=0
set ignorecase
set infercase
set smartcase
set foldlevelstart=10

set listchars=tab:→\ ,trail:─,extends:❭,precedes:❬,nbsp:+
set fillchars=vert:┃,fold:-

set splitright
set switchbuf=useopen

" fit the current window height to the selected text
func! s:win_motion_resize(type) abort
  let sel_save = &selection
  let &selection = "inclusive"

  if a:type ==# 'line' || line("']") > line("'[")
    exe (line("']") - line("'[") + 1) 'wincmd _'
    norm! `[zt
  endif
  if a:type !=# 'line'
    "TODO: this assumes sign column is visible.
    exe ( col("']") -  col("'[") + 3) 'wincmd |'
  endif

  let &selection = sel_save
endfunction
xnoremap <silent> <leader>wf  :<C-u>set winfixwidth winfixheight opfunc=<sid>win_motion_resize<CR>gvg@

function! SearchPreviousLine(pattern)
  call search('\%<'.line('.').'l'.a:pattern, 'b')
endfunction

function! SearchNextLine(pattern)
  call search('\%>'.line('.').'l'.a:pattern)
endfunction

function! TermBufferSettings()
  setfiletype term
  setlocal nonumber
  setlocal nocursorline
  setlocal signcolumn=no

  nnoremap <silent> <buffer> <C-p> :call SearchPreviousLine('')<CR>
  xnoremap <silent> <buffer> <C-p> :call SearchPreviousLine('')<CR>
  nnoremap <silent> <buffer> <C-n> :call SearchNextLine('')<CR>
  xnoremap <silent> <buffer> <C-n> :call SearchNextLine('')<CR>

  autocmd vimrc WinEnter,BufWinEnter <buffer> startinsert
  autocmd TermClose <buffer> if &buftype=='terminal' | bdelete! | endif
  startinsert
endfunction

if has('nvim')
  autocmd vimrc TermOpen * call TermBufferSettings()
  set inccommand=split
  set fillchars+=msgsep:━
  highlight link MsgSeparator Title
endif
"}}}

" GUI Settings: {{{
if exists('+termguicolors') && has('vim_starting')
  set termguicolors
endif

if exists('+guicursor')
  set guicursor+=c:ver25-Cursor/lCursor,a:blinkon0
endif

if exists('+guioptions') && has('vim_starting')
  set guioptions+=c
  set linespace=0
  if exists('+renderoptions')
    set renderoptions=type:directx,taamode:1,renmode:5,geom:1
  endif

  set lines=72
  set columns=142
  set guifont=Iosevka:h12,Source_Code_Pro:h11,Monaco:h16,Consolas:h11,Courier\ New:h14
endif
"}}}

" Formatting: {{{
if has('vim_starting')
  set nowrap
  set linebreak
  set breakindent
  set breakindentopt=shift:4,sbr
  set showbreak=↪
  set autoindent
  set expandtab
  set shiftwidth=4
  set softtabstop=-1
endif
"}}}

" Key Mappings: {{{
let mapleader = "\<space>"

nnoremap <leader><leader> :
xnoremap <leader><leader> :
nnoremap <C-space> :
xnoremap <C-space> :
" <C-space> and <C-@> are equivalent in terminal
" because Ctrl clears bits 6+7 :echo and(char2nr(' '), 31) == and(char2nr('@'), 31)
nnoremap <C-@> :
xnoremap <C-@> :
" Windows console doesn't do C-Space or C-@, so this is an alternative
nnoremap <M-;> :
xnoremap <M-;> :

xnoremap . :normal .<CR>

nnoremap <leader>t :tjump<space>
nnoremap g<C-P> :pwd<CR>

" buffer text object
onoremap <silent> ae :<C-u>keepjumps normal! ggVG<CR>
xnoremap <silent> ae :<C-u>keepjumps normal! ggVG<CR>

" inner line text object
onoremap <silent> il :<c-u>keepjumps lockmarks normal! g_v^<cr>
xnoremap <silent> il :<C-u>keepjumps lockmarks normal! g_v^<CR>

" disable exmode maps
nnoremap Q :bdelete!<CR>
nmap gQ <Nop>

if has('nvim')
  let g:tshell = 'term://' . (executable('fish') ? 'fish' : executable('pwsh') ? 'pwsh' : '')
  tnoremap <C-a> <C-\><C-n>
  " <C-Space> is <C-@>
  tnoremap <C-Space> <C-\><C-n>:
  " <C-Space> doesn't work in Windows console
  tnoremap <M-;> <C-\><C-n>:
  tnoremap <C-w> <C-\><C-n><C-w>

  if empty($TMUX)
    tnoremap <C-a>: <C-\><C-n>:
    tnoremap <C-a>n <C-\><C-n>:bnext<CR>
    nnoremap <C-a>n :bnext<CR>
    tnoremap <C-a>p <C-\><C-n>:bprevious<CR>
    nnoremap <C-a>p :bprevious<CR>
    tnoremap <C-a>c <C-\><C-n>:execute 'edit ' . g:tshell<CR>
    nnoremap <C-a>c :execute 'edit ' . g:tshell<CR>
    tnoremap <C-a>s <C-\><C-n>:execute 'split ' . g:tshell<CR>
    nnoremap <C-a>s :execute 'split ' . g:tshell<CR>
    tnoremap <C-a>v <C-\><C-n>:execute 'vsplit ' . g:tshell<CR>
    nnoremap <C-a>v :execute 'vsplit ' . g:tshell<CR>
    tnoremap <C-a><C-l> <C-l>
    tnoremap <C-a><C-a> <C-a>
    tnoremap <A-h> <C-\><C-n><C-w>h
    tnoremap <A-l> <C-\><C-n><C-w>l
    tnoremap <A-j> <C-\><C-n><C-w>j
    tnoremap <A-k> <C-\><C-n><C-w>k
  endif
endif

" run last make cmd
nnoremap <leader>xm q:?\([Mm]ake\\|Dispatch\)<CR><CR>

" Show syntax groups under cursor
map <silent> zs :for id in synstack(line("."), col("."))<bar>
      \ echo synIDattr(id, "name").' '<bar> execute 'echohl' synIDattr(synIDtrans(id), "name") <bar> echon synIDattr(synIDtrans(id), "name") <bar> echohl None <bar>
      \ endfor<CR>

nnoremap <leader>fs :update<CR>
nnoremap <leader>fq :update<bar>BClose<CR>
nnoremap <leader>fn :VScratch<CR>
nnoremap <leader>fN :Scratch<CR>
nnoremap <silent> <leader>fL :Scratch<bar>file logs<C-r>=bufnr('%')<CR><bar>setf log4net<CR>
nnoremap <leader>fo :edit **/*
nnoremap <leader>fO :edit <C-R>=expand('%:p:h:.:~')<CR>/
nnoremap <leader>fed :edit $MYVIMRC<CR>
nnoremap <leader>fer :source $MYVIMRC<CR>
nnoremap <leader>fF :UnScratch<CR>
nnoremap <leader>fS :ScratchThis<CR>

nnoremap <leader>bo :b#<CR>
nnoremap <leader>bn :bn<CR>
nnoremap <leader>bp :bp<CR>
nnoremap <leader>bb :set nomore<bar>Buffers<bar>set more<CR>:buffer<space>
nnoremap <leader>bB :set nomore<bar>Buffers!<bar>set more<CR>:buffer<space>
nnoremap <leader><tab> :b#<CR>
nnoremap <leader>bd :BClose<CR>
nnoremap <leader>bD :BClose!<CR>

nnoremap <leader>hq :helpclose<CR>

nnoremap <A-j> <C-W>j
nnoremap <A-k> <C-W>k
nnoremap <A-l> <C-W>l
nnoremap <A-h> <C-W>h

nnoremap <leader>ww <C-w>p
nnoremap <leader>w1 1<C-w><C-w>
nnoremap <leader>w2 2<C-w><C-w>
nnoremap <leader>w3 3<C-w><C-w>
nnoremap <leader>w4 4<C-w><C-w>
nnoremap <leader>w5 5<C-w><C-w>
nnoremap <leader>w6 6<C-w><C-w>
nnoremap <leader>w7 7<C-w><C-w>
nnoremap <leader>w8 8<C-w><C-w>
nnoremap <leader>w9 9<C-w><C-w>

nnoremap <silent> <C-w>z :wincmd z<Bar>cclose<Bar>lclose<CR>
nnoremap yoC :let &conceallevel=&conceallevel == 0 ? 1 : 0<CR>

nnoremap <leader>wsh :leftabove vsp<CR>
nnoremap <leader>wsl :rightbelow vsp<CR>
nnoremap <leader>wsk :leftabove sp<CR>
nnoremap <leader>wsj :rightbelow sp<CR>

function!  s:ToggleDiff()
  if &diff
    diffoff!
  else
    windo diffthis
  endif
endfunction
nnoremap <c-w>D :call <SID>ToggleDiff()<CR>

nnoremap j gj
nnoremap k gk

nnoremap <leader>j i<CR><Esc>

nnoremap <leader>eF :<C-U>let &foldlevel=v:count > 0 ? v:count : foldlevel('.') - 1<CR>

nnoremap <silent> <leader>/ :nohlsearch<bar>redraw<CR>

xnoremap < <gv
xnoremap > >gv

noremap zl 20zl
noremap zh 20zh

nnoremap <C-y> "*y
xnoremap <C-y> "*y
nnoremap <C-p> :set paste<CR>"*]p:set nopaste<CR>
nnoremap <C-P> :set paste<CR>"*]P:set nopaste<CR>
xnoremap <C-p> :<C-U>set paste<CR>"*]p:set nopaste<CR>
xnoremap <C-P> :<C-U>set paste<CR>"*]P:set nopaste<CR>

xnoremap p "0p

xnoremap y y`]
xnoremap p p`]
nnoremap p p`]

xnoremap D y'>p

nnoremap vv ^vg_

nnoremap <silent> s :set opfunc=PasteReplace<CR>g@
vnoremap <silent> s :<C-U>call PasteReplace(visualmode(), 1)<CR>

function! PasteReplace(type, ...)
  if a:0
    normal! gv"0p
  elseif a:type == 'line'
    normal! '[V']"0p
  else
    normal! `[v`]"0p
  endif
endfunction

" ⇅
nnoremap <S-A-j> :m+<CR>
nnoremap <S-A-k> :m-2<CR>
xnoremap <S-A-j> :m'>+<<CR>gv
xnoremap <S-A-k> :m-2<CR>gv

" ⇄
nnoremap <S-A-h> <<
nnoremap <S-A-l> >>
xnoremap <S-A-h> <gv
xnoremap <S-A-l> >gv

nnoremap H ^
nnoremap L $
xnoremap H ^
xnoremap L g_

nnoremap gI `.

xnoremap / <Esc>/\%V

nnoremap <leader>sg :g/
nnoremap <leader>sv :v/
xnoremap <leader>sg :g/
xnoremap <leader>sv :v/

nnoremap <leader>sp :g//#<CR>
nnoremap <leader>sP :v//#<CR>
xnoremap <leader>sp :g//#<CR>
xnoremap <leader>sP :v//#<CR>

nnoremap <leader>sd :g//d<CR>
nnoremap <leader>sD :v//d<CR>
xnoremap <leader>sd :g//d<CR>
xnoremap <leader>sD :v//d<CR>

nnoremap <leader>sc :%s///gn<left><left><left><left>
xnoremap <leader>sc :s///gn<left><left><left><left>

nnoremap <silent> <leader>s/ :s,\\,/,g<CR>
nnoremap <silent> <leader>s\ :s,/,\\,g<CR>
xnoremap <silent> <leader>s/ :s,\%V\\,/,g<CR>
xnoremap <silent> <leader>s\ :s,\%V/,\\,g<CR>

nnoremap <leader>sl :keeppatterns lvimgrep /<C-R><C-R>//j %<CR>

nnoremap <leader>sr :%snomagic/
xnoremap <leader>sr :snomagic/

nnoremap <leader>8 :keeppatterns lvimgrep /<C-R><C-R><C-W>/j %<CR>
xnoremap <leader>8 y:<C-U>keeppatterns lvimgrep /<C-R><C-R>"/j %<CR>

nnoremap <C-j> :call SameColumnDown(line('.'), virtcol('.'))<CR>
function! SameColumnDown(line, col)
  call search('\%>'.a:line.'l\(\%'.a:col.'v\zs\S\|\%<'.a:col.'v\S\%'.a:col.'v\zs\)')
endfunction

nnoremap <C-k> :call SameColumnUp(line('.'), virtcol('.'))<CR>
function! SameColumnUp(line, col)
  call search('\%<'.a:line.'l\(\%'.a:col.'v\zs\S\|\%<'.a:col.'v\S\%'.a:col.'v\zs\)', 'b')
endfunction

inoremap (<CR> (<CR>)<Esc>O
inoremap {<CR> {<CR>}<Esc>O
inoremap {; {<CR>};<Esc>O
inoremap {, {<CR>},<Esc>O
inoremap [<CR> [<CR>]<Esc>O
inoremap [; [<CR>];<Esc>O
inoremap [, [<CR>],<Esc>O

inoremap <C-F> <C-X><C-F>
inoremap <C-C> <C-X><C-O>
inoremap <C-S> <C-X><C-S>

cnoremap cd. cd %:p:h
cnoremap cd.. cd %:p:h:h
cnoremap %% <C-R>=expand('%:h').'/'<cr>
cnoremap %%% <C-R>=expand('%:h:h').'/'<cr>
cnoremap <C-r><C-l> <C-r>=getline('.')<CR>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

cnoremap        <C-B> <Left>
cnoremap <expr> <C-F> getcmdpos()>strlen(getcmdline())?&cedit:"\<Lt>Right>"
cnoremap        <M-b> <S-Left>
cnoremap        <M-d> <C-O>dw
cnoremap        <M-d> <S-Right><C-W>
cnoremap        <M-BS> <C-W>
cnoremap        <M-f> <S-Right>
"}}}

" Filetypes: {{{

function! s:ft_load(ftype)
  if exists('*s:ft_'.a:ftype)
    call s:ft_{a:ftype}()
  endif
endfunction
autocmd vimrc FileType * call <SID>ft_load(expand('<amatch>'))

function! SpellIgnoreSomeWords()
  syntax match spellIgnoreAcronyms '\<\u\(\u\|\d\)\+s\?\>' contains=@NoSpell contained containedin=@Spell
  syntax match spellIgnoreUrl '\w\+:\/\/[^[:space:]]\+' contains=@NoSpell contained containedin=@Spell
endfunction

" json: {{{
function! s:ft_json()
  if executable('jq')
    setlocal equalprg=jq\ .
  else
    setlocal equalprg=python\ -m\ json.tool
  endif
  setlocal shiftwidth=2
  setlocal concealcursor=n

  if s:has_plug('coc.nvim')
    call MyDefaultCocMappings()
  endif
endfunction
" }}}

" xml: {{{
let g:xml_syntax_folding=1
autocmd vimrc BufNewFile,BufRead *.config setfiletype xml
autocmd vimrc BufNewFile,BufRead *.*proj setfiletype xml
autocmd vimrc BufNewFile,BufRead *.xaml setfiletype xml

function! s:ft_xml()
  setlocal foldmethod=syntax
  setlocal equalprg=xmllint\ --format\ --recover\ -
  setlocal shiftwidth=2
  " the xml highlighting can be broken on large files, so we
  " increase the max num of lines that the highlighting examines
  syntax sync maxlines=10000
endfunction
" }}}

" fsharp: {{{
function! s:ft_fsharp()
  command! -buffer -range FSIExecRange call SendTerm('dotnet fsi', substitute(join(getline(<line1>, <line2>), "\r") . ";;\r", "\r\s*\\", ' ', 'g'))
  nnoremap <buffer> <leader>xe :FSIExecRange<CR>
  xnoremap <buffer> <leader>xe :FSIExecRange<CR>

  if executable('fantomas')
    setlocal equalprg=fantomas\ --stdin\ --stdout
  endif
  setlocal shiftwidth=4
endfunction
" }}}

" vim {{{
function! s:ft_vim()
  setlocal keywordprg=:help 
  setlocal omnifunc=syntaxcomplete#Complete 
  setlocal shiftwidth=2
  setlocal foldmethod=marker
  setlocal foldlevel=0

  command! -range ExecRange execute substitute(join(getline(<line1>, <line2>), "\n"), '\n\s*\\', ' ', 'g')
  nnoremap <buffer> <leader>xe :ExecRange<CR>
  xnoremap <buffer> <leader>xe :ExecRange<CR>
endfunction
" }}}

" help {{{
function! s:ft_help()
  nnoremap <buffer> q :wincmd c<CR>
endfunction
" }}}

" quickfix {{{
function! s:ft_qf()
  " syntax clear
  " syn match	qfDirName "^[^|]+[\\/]\ze[^|\\/]+" nextgroup=qfJustFileName conceal cchar=•
  " syntax match	qfDirName "^[^|]*[\\/][^\\/|]+" nextgroup=qfSeparator conceal cchar=•
  " syntax match	qfDirName "^[^|]\+[\\/][^|\\/]\+" nextgroup=qfSeparator
  " syntax match	qfSeparator "/|/" contained
  " syn match	qfJustFileName "[^|\\/]+" nextgroup=qfSeparator

  syntax match qfNoLineCol "||" conceal cchar=|

  syntax match qfFugitive "^fugitive:\/\/.\+\/\/" conceal cchar=| nextgroup=qfFugitiveHash
  syntax match qfFugitiveHash "[a-f0-9]\+" contained
  highlight! link qfFugitiveHash Directory

  setlocal conceallevel=2
  setlocal concealcursor+=n
endfunction
" }}}

" rust: {{{
function! s:ft_rust()
  setlocal keywordprg=:DevDocs\ rust
  if executable('rusty-tags')
    command! RustyTags silent! exec "!rusty-tags vi --quiet --start-dir=" . expand('%:p:h') . '&' <bar> redraw!
    setlocal tags=./rusty-tags.vi;/,$RUST_SRC_PATH/rusty-tags.vi
    " autocmd BufWrite *.rs RustyTags
  endif
  if s:has_plug('LanguageClient-neovim')
    nnoremap <silent> <buffer> K :call LanguageClient_textDocument_hover()<CR>
    nnoremap <silent> <buffer> gd :call LanguageClient_textDocument_definition()<CR>
    nnoremap <silent> <buffer> gr :call LanguageClient_textDocument_references()<CR>
    nnoremap <silent> <buffer> <F2> :call LanguageClient_textDocument_rename()<CR>
  endif

  if s:has_plug('coc.nvim')
    call MyDefaultCocMappings()
  endif
endfunction
" }}}

" typescript: {{{
function! s:ft_typescript()
    call MyDefaultCocMappings()
  if s:has_plug('coc.nvim')
    call MyDefaultCocMappings()
  endif
endfunction
" }}}

" pandoc/markdown: {{{
function! s:ft_pandoc()
  setlocal foldcolumn=0 
  setlocal concealcursor+=n
  setlocal textwidth=79
  setlocal shiftwidth=2
  call SpellIgnoreSomeWords()
endfunction
" }}}

" text: {{{
function! s:ft_text()
  call SpellIgnoreSomeWords()
endfunction
" }}}

" lua: {{{
autocmd vimrc BufNewFile,BufRead *.love setfiletype lua
function! s:ft_lua()
  command! -buffer -range LuaExecRange execute 'lua' 'assert(loadstring("'.escape(join(getline(<line1>,<line2>), "\\n"), '"').'"))()'
  nnoremap <buffer> <leader>xe :LuaExecRange<CR>
  xnoremap <buffer> <leader>xe :LuaExecRange<CR>
  setlocal keywordprg=:help
endfunction
"}}}

" lisp: {{{
function! s:ft_lisp()
  command! -buffer -range LispExecRange call SendTerm('lua fennel', substitute(join(getline(<line1>, <line2>), "\r") . "\r", "\r\s*\\", ' ', 'g'))
  nnoremap <buffer> <leader>xe :LispExecRange<CR>
  xnoremap <buffer> <leader>xe :LispExecRange<CR>
endfunction
"}}}

" janet: {{{
function! s:ft_janet()
  command! -buffer -range LispExecRange call SendTerm('janet', substitute(join(getline(<line1>, <line2>), "\r") . "\r", "\r\s*\\", ' ', 'g'))
  nnoremap <buffer> <leader>xe :LispExecRange<CR>
  xnoremap <buffer> <leader>xe :LispExecRange<CR>
endfunction
"}}}

"}}}

" Commands & Functions: {{{

" Window Swap: {{{
nnoremap <C-w>x :<C-U>call <sid>SwapWindowBuffer(v:count)<CR>
nnoremap <C-w><C-x> :<C-U>call <sid>SwapWindowBuffer(v:count)<CR>

function! s:SwapWindowBuffer(winnum)
  let currentWin = winnr()
  let otherWin = a:winnum == 0 ? winnr('#') : a:winnum
  if otherWin == 0
    return
  endif

  let currentBuffer = winbufnr(0)
  let otherBuffer = winbufnr(otherWin)

  execute otherWin 'wincmd w'
  execute 'buffer' currentBuffer
  execute currentWin 'wincmd w'
  execute 'buffer' otherBuffer
endfunction
" }}}

" shada clean {{{
function! ShadaClean()
  let tshada = expand(&shadafile)
  let mpack = readfile(tshada, 'b')
  call writefile(mpack, tshada.'.tmp', 'b')
  let shada_objects = msgpackparse(mpack)

  let new_shada = []
  for item in shada_objects
    if type(item) != 4 || !has_key(item, 'f') 
      let new_shada += [item]
      continue
    endif

    let f2 = deepcopy(item)
    let f2['f'] = tr(item.f, '\', '/')
    let new_shada += [f2]
  endfor

  call writefile(msgpackdump(new_shada), tshada, 'b')
endfunction

autocmd vimrc VimLeave * call ShadaClean()

" }}}

" XXD {{{
function! HexBin()
  %y
  vnew
  0put
  %!xxd -b
  setf xxd
  wincmd p
  %!xxd -c 6
  setf xxd
  37wincmd |
endfunction
"}}}

" Terminal Toggle: {{{

function! ResetToggleTerminal(...)
  let s:term_win = 0
  let s:term_buf = 0
endfunction

function! ToggleTerminal(height, width)
  if win_getid() == s:term_win
    call nvim_win_close(s:term_win, 1)
    let s:term_win = 0
  else
    call s:openTermFloating(a:height, a:width)
    let s:term_win = win_getid()
  endif
endfunction

function! s:openTermFloating(height, width) abort
  let row=(&lines-a:height)/2
  let col=(&columns-a:width)/2
  let opts = {
        \ 'relative': 'editor',
        \ 'width': a:width,
        \ 'height': a:height,
        \ 'col': col,
        \ 'row': row,
        \ 'anchor': 'NW',
        \ 'style': 'minimal'
        \ }

  if s:term_buf != 0
    " switch to existing term buffer
    call nvim_open_win(s:term_buf, 1, opts)
    startinsert
  else
    " create new term buffer
    let s:term_buf = nvim_create_buf(v:false, v:true)
    call nvim_open_win(s:term_buf, 1, opts)
    call termopen(executable('fish') ? 'fish' : 'pwsh', {'on_exit': function('ResetToggleTerminal')})
    setlocal winblend=10
  endif

endfunction

if has('vim_starting')
  call ResetToggleTerminal()
endif

nnoremap <silent> <A-t> :call ToggleTerminal(&lines-10,&columns)<CR>
tnoremap <silent> <A-t> <C-\><C-n>:call ToggleTerminal(&lines-10,&columns)<CR>

" }}}

" Replace Browse cmd {{{
" Browse command is used by fugitive instead of netrw, so we can get rid of
" those Press <cr> to continue messages.
let g:browser_path='C:\Program Files (x86)\Google\Chrome\Application\chrome.exe'
function! Browse(url)
  if filereadable(g:browser_path)
    let cmd = g:browser_path
  elseif has('mac')
    let cmd = 'open'
  else
    let cmd = 'start'
  endif
  call system([cmd, a:url])
endfunction
command! -nargs=1 Browse :call Browse(<q-args>)
nnoremap gx :Browse <C-R><C-f><CR>
xnoremap gx :Browse
"}}}

" CWindow {{{
" Hack buffer names relative to cwd, see
" https://groups.google.com/forum/#!topic/vim_use/Vq0z2DJH2So
" Useful to get relative paths in quickfix after grep
function! s:CWindow()
  let size = getqflist({'size':1}).size
  if size == 0 | return | endif
  0split | lcd . | quit
  execute 'cwindow' (min([10, max([3, size])]))
endfunction
function! s:LWindow()
  let size = getloclist(0, {'size':1}).size
  if size == 0 | return | endif
  0split | lcd . | quit
  execute 'lwindow' (min([10, max([3, size])]))
endfunction
command! CWindow call s:CWindow()
command! LWindow call s:LWindow()

" Opens quick fix window when there are items, close it when empty
autocmd vimrc QuickFixCmdPost [^l]* nested CWindow
autocmd vimrc QuickFixCmdPost    l* nested LWindow

"}}}

" Custom fold display {{{

let s:foldfill = matchlist(&fillchars, 'fold:\zs.\ze')[0]

function! s:CurrentWinWidth()
  let numwidth = (&number || &relativenumber) ? max([&numberwidth, strwidth(string(line('$'))) + 1]) : 0
  return winwidth(0) - &foldcolumn - numwidth
endfunction

function! CustomFoldText() abort
  let fs = nextnonblank(v:foldstart)
  if fs > v:foldend
    let fs = v:foldstart
  endif

  let line = getline(fs)
  let line = substitute(line, '\t', repeat(' ', &tabstop), 'g')
  if &foldmethod == 'marker'
    let line = substitute(line, split(&foldmarker, ',')[0], '', 'g')
  endif

  let w = s:CurrentWinWidth()
  let foldSize = 1 + v:foldend - v:foldstart
  let foldDetails = ' ' . foldSize . ' lines ' . repeat('-', v:foldlevel) . '+'
  let extraSize = strwidth(foldDetails)
  if strwidth(line) > w - extraSize
    let line = line[:(w - extraSize - 4)]
  endif
  let expansionString = repeat(s:foldfill, w - strwidth(line) - extraSize)
  return line . expansionString . foldDetails
endfunction
set foldtext=CustomFoldText()
" }}}

" Edit QuickFix items {{{
if has('lambda')

function! s:doMap(items, start, end, func)
  let result = []
  if a:start > 0
    let result += a:items[:a:start-1]
  endif
  let result += a:func(a:items[a:start:a:end])
  if a:end < len(a:items)
    let result += a:items[a:end+1:]
  endif
  return result
endfunction

function! MapQFItems(ln1, ln2, func)
  if &buftype != 'quickfix'
    echoerr "Only works on quickfix buffers"
    return
  endif
  let start = a:ln1 - 1
  let end = a:ln2 - 1
  let title = w:quickfix_title
  try
    let items = getloclist(0)
    if !empty(items)
      call setloclist(0, s:doMap(items, start, end, a:func))
    else
      let items = getqflist()
      call setqflist(s:doMap(items, start, end, a:func))
    endif
  catch
    echoerr "Failed to map QF items:" v:exception
  endtry
  let w:quickfix_title = title
endfunction

function! SortQFByText(ln1, ln2) abort
  if a:ln1 == a:ln2
    let start = 1
    let end = 9999
  else
    let start = a:ln1
    let end = a:ln2
  endif
  return MapQFItems(start, end,
        \ {items -> sort(items, {i1, i2 -> i1.text == i2.text ? 0 : i1.text > i2.text ? 1 : -1})})
endfunction

function! RemoveQFItem(ln1, ln2) abort
  call MapQFItems(a:ln1, a:ln2, {items -> []})
endfunction

command! -range RemoveQFItem call RemoveQFItem(<line1>, <line2>)
command! -range SortQFByText call SortQFByText(<line1>, <line2>)

autocmd vimrc BufEnter * call <SID>SetupQuickFixMap()
function! s:SetupQuickFixMap()
  if &buftype != 'quickfix'
    return
  endif
  nnoremap <buffer> D :RemoveQFItem<CR>
  xnoremap <buffer> D :RemoveQFItem<CR>
  nnoremap <buffer> S :SortQFByText<CR>
  xnoremap <buffer> S :SortQFByText<CR>
endfunction

endif
"}}}

" WinZoom cmd {{{
function! WinZoom() abort
  if 1 == winnr('$')
    return
  endif
  let restore_cmd = winrestcmd()
  wincmd |
  wincmd _
  if restore_cmd ==# winrestcmd()
    exe t:zoom_restore
  else
    let t:zoom_restore = restore_cmd
  endif
  return '<Nop>'
endfunc

function! s:zoom_or_goto_column(cnt) abort
  if a:cnt
    exe 'norm! '.v:count.'|'
  else
    call WinZoom()
  endif
endfunction

nnoremap <Bar> :<C-U>call <SID>zoom_or_goto_column(v:count)<CR>
" }}}

" DevDocs cmd {{{
function! DevDocs(query)
  let q = 'https://devdocs.io/#q=' . substitute(a:query, ' ', '%20', 'g')
  call Browse(q)
endfunction
command! -nargs=* DevDocs :call DevDocs(<q-args>)
" }}}

" create scratch buffer {{{
function! MkScratch(newCmd, name) abort
  if !empty(a:newCmd)
    execute a:newCmd
  endif
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  if !empty(a:name)
    execute 'file' a:name
  endif
endfunction

function! UnScratch() abort
  set buftype<
  set bufhidden<
  set swapfile<

endfunction

command! -nargs=? Scratch :call MkScratch('enew', <q-args>)
command! -nargs=? NScratch :call MkScratch('new', <q-args>)
command! -nargs=? VScratch :call MkScratch('vnew', <q-args>)
command! -nargs=? ScratchThis :call MkScratch('', <q-args>)
command! -nargs=0 UnScratch :call UnScratch()
" }}}

" Delete current buffer without closing window {{{

function! BClose(force) abort
  if !a:force && &modified
    echohl ErrorMsg | echo 'buffer has unsaved changes (use BClose! to discard changes)' | echohl None
    return
  endif

  let bnr = bufnr('%')
  for id in win_findbuf(bnr)
    if !win_gotoid(id)
      continue
    endif

    bprevious

    if bnr == bufnr('%')
      Scratch
    endif
  endfor
  
  if bufexists(bnr) && getbufvar(bnr, '&buflisted') && bnr != bufnr('%')
    if a:force
      execute 'bdelete!' bnr
    else
      execute 'bdelete' bnr
    endif
  endif
endfunction
command! -bang -nargs=0 BClose :call BClose(<bang>0)
" }}}

" Diff against last saved {{{
function! DiffOrig()
  let bft = &ft
  diffthis
  vert new
  setlocal buftype=nofile
  execute 'setlocal filetype='.bft
  nnoremap <buffer> q :bdelete<bar>diffoff<CR>
  read ++edit # | normal gg0d_
  diffthis
endfunction

command! DiffOrig call DiffOrig()
nnoremap <leader>ud :DiffOrig<CR>
"}}}

" xxd against last saved {{{
function! XxdOrig()
  vert new
  setlocal buftype=nofile
  setlocal filetype=xxd
  nnoremap <buffer> q :bdelete<CR>
  read ++edit # | normal gg0d_
  %!xxd
endfunction

command! XxdOrig call XxdOrig()
nnoremap <leader>ux :XxdOrig<CR>
"}}}

" Buffers: {{{

highlight link BufferNumber Number
highlight link BufferFlags Special
highlight link BufferCurrentName Title
highlight link BufferAlternateName Include
highlight link BufferName Normal

command! -bar -bang Buffers call Buffers(<bang>0)
function! Buffers(show_all) abort
  let ls = a:show_all ? 'ls!' : 'ls'
  let buffers = split(execute(ls), "\n")
  echo "\n"
  for b in buffers
    let ms = matchlist(b, '\s*\(\d\+\)\(.....\)\s\+"\(.\+\)"\s\+line \(\d\+\)')
    let [bnum, bflags, bname, bline] = ms[1:4]
    echohl BufferNumber | echon printf('%3d',bnum) " "
    echohl BufferFlags | echon bflags " "
    if bflags[1] == '%'
      echohl BufferCurrentName
    elseif bflags[1] == '#'
      echohl BufferAlternateName
    else
      echohl BufferName
    endif
    let maxPathLen = &columns - 50
    if len(bname) > maxPathLen
      echon PathShorten(bname, maxPathLen)
    else
      echon bname
    endif
    let bufIdx = s:bufferIndex(bname)
    if argc() > 1 && bufIdx >= 0
      echohl BufferArgList | echon " (" bufIdx+1 ")\n"
    else
      echon "\n"
    endif
  endfor
  echohl None
endfunction

" }}}

" Highlights: {{{
function! Highlight(...) abort
  let lines = split(execute('highlight'), "\n")
  let groups = []
  for line in lines
    if match(line, '^\s\+')> -1
      let groups[-1] .= substitute(line, '^\s\+', ' ', '')
      continue
    else
      call add(groups, line)
    endif
  endfor

  if a:0 == 1
    let groups = filter(groups, 'match(v:val, a:1) > -1')
  endif

  let matchGroups = []
  for grp in groups
    let grpName = ''
    let grpAttrs = ''
    let grpLink = ''
    let ms = matchlist(grp, '\(\S\+\)\s\+xxx\s\+\(\(\S\+=\S\+\s*\)\+\)')
    if !empty(ms)
      let [grpName, grpAttrs] = ms[1:2]
    endif
    let ms = matchlist(grp, '\(\S\+\)\s\+xxx\s\+.*links to \(\S\+\)')
    if !empty(ms)
      let [grpName, grpLink] = ms[1:2]
    endif
    let ms = matchlist(grp, '\(\S\+\)\s\+xxx\s\+cleared')
    if !empty(ms)
      let grpName = ms[1]
    endif
    call add(matchGroups, [grpName, grpAttrs, grpLink])
  endfor

  let maxWidth = 0
  for group in matchGroups
    let l = strlen(group[0])
    if l > maxWidth
      let maxWidth = l
    endif
  endfor

  for group in matchGroups
    let [grpName, grpAttrs, grpLink] = group
    let fmt = '%-'.maxWidth.'s'
    let grpName = printf(fmt, grpName)
    if !empty(grpAttrs)
      echon grpName " "
      execute 'echohl' grpName | echon "xxx" | echohl None
      let s = 0
      let pattern = '\(\S\+\)=\(\S\+\)'
      let ms = matchlist(grpAttrs, pattern, s)
      while !empty(ms)
        let s+= strlen(ms[0])
        echohl Identifier | echon " " ms[1] | echohl None
        echon "=" ms[2]
        let ms = matchlist(grpAttrs, pattern, s)
      endwhile
      if !empty(grpLink)
        echon " links to " grpLink "\n"
      else
        echon "\n"
      endif
    elseif !empty(grpLink)
      echon grpName " "
      execute 'echohl' grpName | echon "xxx" | echohl None
      echon " links to " grpLink "\n"
    else
      echo grpName "xxx cleared\n"
    endif
  endfor
endfunction

command! -complete=highlight -nargs=? Highlight :call Highlight(<f-args>)
" }}}

" Recent files etc: {{{
function! s:UniqPath(list)
  let i = 0
  let seen = []
  while i < len(a:list)
    let key = a:list[i]
    if index(seen, key) == -1
      call add(seen, key)
    endif
    let i += 1
  endwhile
  return seen
endfunction

function! s:MRUDComplete(ArgLead, CmdLine, CursorPos)
  let argLead = glob2regpat(a:ArgLead . '*')
  return s:UniqPath(filter(map(copy(v:oldfiles), "fnamemodify(v:val, ':h')"), 'v:val =~ argLead && isdirectory(expand(v:val))'))
endfunction

function! s:MRUFComplete(ArgLead, CmdLine, CursorPos)
  let argLead = glob2regpat(a:ArgLead . '*')
  return filter(copy(v:oldfiles), 'v:val =~ argLead && !empty(glob(v:val))')
endfunction

function! s:RgFilesComplete(ArgLead, CmdLine, CursorPos)
  let pattern = a:ArgLead
  if empty(pattern)
    return []
  elseif pattern[-1:] == '$'
    let pattern = pattern[:-2]
  elseif pattern[-1:] != '*'
    let pattern .= '*'
  endif
  return systemlist('rg -S --files --iglob ' . pattern)
endfunction

function! s:FdFilesComplete(ArgLead, CmdLine, CursorPos)
  let pattern = a:ArgLead
  if empty(pattern)
    return []
  endif
  return systemlist('fd ' . pattern)
endfunction

function! s:Run(command, arg, mods)
  execute a:mods a:command a:arg
endfunction

command! -nargs=1 -complete=customlist,<sid>MRUDComplete OldDirs call <sid>Run('tcd', <q-args>, <q-mods>)
command! -nargs=1 -complete=customlist,<sid>MRUFComplete OldFiles call <sid>Run('edit', <q-args>, <q-mods>)
command! -nargs=1 -complete=customlist,<sid>RgFilesComplete RgFiles call <sid>Run('edit', <q-args>, <q-mods>)
command! -nargs=1 -complete=customlist,<sid>FdFilesComplete FdFiles call <sid>Run('edit', <q-args>, <q-mods>)
nnoremap <leader>pr :OldDirs *
nnoremap <leader>fr :OldFiles *
nnoremap <leader>fR :OldFiles <C-r>=expand('%:p:.:~:h')<CR>/*<C-z>
" nnoremap <leader>ff :RgFiles **/
nnoremap <leader>ff :FdFiles 

" }}}

" Allow the use of * and # on a visual range. (from vimcasts) {{{
function! s:VSetSearch(cmdtype)
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
"}}}

" Zoom font size {{{
if exists('+guifont') && !empty(&gfn)
  let s:zoom_level=split(split(&gfn, ',')[0], ':')[1][1:]
  function! s:ChangeZoom(zoomInc)
    let s:zoom_level = min([max([4, (s:zoom_level + a:zoomInc)]), 28])
    let &gfn=substitute(&gfn, ':h\d\+', ':h' . s:zoom_level, '')
    if s:maximised
      let &lines=999
      if s:maximised == 1
        let &columns=999
      endif
    endif
  endfunction

  nnoremap coz :<C-U>call <sid>ChangeZoom(-1 * (v:count == 0 ? 1 : v:count))<CR>
  nnoremap coZ :<C-U>call <sid>ChangeZoom(1 * (v:count == 0 ? 1 : v:count))<CR>

  let s:maximised=0
  let s:restoreLines=0
  let s:restoreCols=0
  function! s:ToggleMaximise(vertical)
    if s:maximised
      let s:maximised=0
      let &lines=s:restoreLines
      let &columns=s:restoreCols
    else
      let s:maximised=1 + a:vertical
      let s:restoreLines=&lines
      let s:restoreCols=&columns
      let &lines=999
      if !a:vertical
        let &columns=999
      endif
    endif
  endfunction

  nnoremap com :<C-U>call <sid>ToggleMaximise(0)<CR>
  nnoremap coM :<C-U>call <sid>ToggleMaximise(1)<CR>
endif
" }}}

" copy to html {{{
function! s:CpHtml(line1, line2)
  :call tohtml#Convert2HTML(a:line1, a:line2)
  :%!html2clipboard
  :close!
endfunction
command! -range CpHtml :call <sid>CpHtml(<line1>,<line2>)
"}}}

" reload with dos endings {{{
" vim will select ff=unix for any file with a \n in, no matter how many
" \r\n line endings there might be. Use this cmd to reload the file forcing
" ff=dos
command! ReloadDos :e ++ff=dos<CR>
"}}}

" Visual Markers {{{
nnoremap <expr> <leader>m ToggleVisualMarker()
nnoremap <expr> m UpdateVisualMarker()

highlight MarkerOrangeSign guifg=#e2a478 guibg=#2a3158
highlight MarkerBlueSign guifg=#84a0c6 guibg=#2a3158
highlight MarkerGreenSign guifg=#b3be82 guibg=#2a3158
highlight MarkerRedSign guifg=#e27878 guibg=#2a3158
highlight MarkerPurpleSign guifg=#a093c7 guibg=#2a3158
highlight MarkerYellowSign guifg=#f9c199 guibg=#2a3158
highlight MarkerAquaSign guifg=#89b8c2 guibg=#2a3158
let g:myvimrc_visual_marks_groups = [
      \ 'MarkerBlueSign',  'MarkerGreenSign',
      \ 'MarkerRedSign', 'MarkerPurpleSign',
      \ 'MarkerYellowSign', 'MarkerAquaSign',
      \ 'MarkerOrangeSign']

function! s:remove_visual_mark(match, reg)
  call matchdelete(a:match)
  call remove(b:myvimrc_visual_marks, a:reg)
  execute 'delmarks' a:reg
endfunction

function! UpdateVisualMarker()
  if !exists('b:myvimrc_visual_marks') || empty(b:myvimrc_visual_marks)
    return 'm'
  endif

  let c = getchar()
  let rc = nr2char(c)
  if has_key(b:myvimrc_visual_marks, rc)
    let grp = g:myvimrc_visual_marks_groups[c % len(g:myvimrc_visual_marks_groups)]
    let m = b:myvimrc_visual_marks[rc]
    call matchdelete(m)
    call matchadd(grp, "^.*\\%'".rc.'.*$', 10, m)
  endif

  return 'm'.rc
endfunction

function! ToggleVisualMarker()
  if !exists('b:myvimrc_visual_marks')
    let b:myvimrc_visual_marks = {}
  endif

  let c = getchar()
  let rc = nr2char(c)

  if rc !~ '[a-zA-Z]'
    if rc == ' '
      for [k,m] in items(b:myvimrc_visual_marks)
        call s:remove_visual_mark(m, k)
      endfor
      unlet b:myvimrc_visual_marks
    endif
    return
  endif

  if has_key(b:myvimrc_visual_marks, rc)
    let m = b:myvimrc_visual_marks[rc]
    let toggle = line('.') == line("'".rc)
    call s:remove_visual_mark(m, rc)
    if toggle
      return
    endif
  endif

  let grp = g:myvimrc_visual_marks_groups[c % len(g:myvimrc_visual_marks_groups)]

  let m = matchadd(grp, "^.*\\%'".rc.'.*$')
  let b:myvimrc_visual_marks[rc] = m
  return 'm' . rc
endfunction
"}}}

" Warn when persistent undo moves into previous sessions {{{
" based on https://github.com/thoughtstream/Damian-Conway-s-Vim-Setup/blob/master/plugin/undowarnings.vim

nnoremap <expr> u  VerifyUndo()

autocmd vimrc BufReadPost  *  :call s:remember_undo_start(0)
autocmd vimrc BufWritePost *  :call s:remember_undo_start(1)
function! s:remember_undo_start(reset)
  let undo_now = undotree().seq_cur
  if undo_now > 0 && (!exists('b:undo_start') || a:reset)
    let b:undo_start = undo_now
  endif
endfunction

function! VerifyUndo ()
  if !exists('b:undo_start')
    return 'u'
  endif

  let undo_now = undotree().seq_cur
  if undo_now > 0 && undo_now == b:undo_start
    let response = confirm("Undo into previous session?", "&Yes\n&No")
    redraw
    return response == 1 ? 'u' : ''
  else
    return 'u'
  endif
endfunction
" }}}

" Show CursorLine in active window only {{{
if get(g:, 'myvimrc_manage_cursorline', 0)
  set cursorline
  autocmd vimrc WinEnter * setlocal cursorline
  autocmd vimrc WinLeave * setlocal nocursorline
endif
" }}}

" SendTerm: {{{
function! SendTerm(c, t)
  let tid = get(b:, 'sendtermid', 0)
  if !tid
    botright split new
    let tid = termopen(a:c)
    wincmd p
    let b:sendtermid = tid
  endif
  call chansend(b:sendtermid, a:t)
endfunction
" }}}

"}}}

" PrettyLittleStatus: {{{

function! s:is_nofile()
    return &buftype =~ 'nofile\|help\|qf' || exists('b:terminal_job_id')
endfunction

function! s:is_small_win()
    return winwidth(0) < 60
endfunction

function! PathShorten(path, max)
  let pathbits = split(a:path, '\\\|/') 
  let numShort = 0
  let shortPath = a:path
  while len(shortPath) > a:max && numShort < len(pathbits) - 1
    let pathbit = pathbits[numShort]
    let pathbit = pathbit !~ '[A-Z]:' ? pathbit[0] : pathbit
    let pathbits[numShort] = pathbit
    let shortPath = join(pathbits, (&shellslash ? '/' : '\'))
    let numShort += 1
  endwhile
  return shortPath
endfunction

function! s:GetDirvishName()
  let name = expand('%:~:.')
  if empty(name)
    return '['.expand('%:h:t').']'
  else
    return name
  endif
endfunction

function! s:GetTermTitle()
  let title = get(b:, 'term_title', '')
  if empty(title)
    return ['', substitute(expand('%:t'), '^\d\+:', '', '')]
  endif

  let ms = matchlist(title, '\(\S\+\)\s\+\(\f\+\)$')
  if empty(ms)
    return ['', substitute(expand('%:t'), '^\d\+:', '', '')]
  endif

  return [ms[1].' ', ms[2]]
endfunction

function! StatusLineDiffMerge()
  if get(g:, 'mergetool_in_merge_mode', 0)
    return '↸'
  endif

  if &diff
    return '↹'
  endif

  return ''
endfunction

function! StatusLineWinNum()
  if winnr('$')==1
    return ''
  endif
  let n = winnr()
  if n <= 10
    return nr2char(0x2776 + n - 1)
  endif
endfunction

function! StatusLineFilename()
  let fname = &buftype == 'nofile' ? expand('%') : expand('%:t')
  return &filetype == 'dirvish' ? s:GetDirvishName() :
       \ &filetype == 'fuzzy' ? b:fuzzy_status :
       \ &filetype == 'help' ? expand('%:t:r') :
       \ &filetype == 'peekaboo' ? '' :
       \ &filetype == 'qf' ? get(w:, 'quickfix_title', '') :
       \ &filetype == 'term' ? s:GetTermTitle()[1] :
       \ empty(fname) ? ('['.bufnr('').']') : fname 
endfunction

function! StatusLinePath()
  if &filetype == 'term'
    return s:GetTermTitle()[0]
  endif
  if s:is_nofile()
    return ''
  endif
  if empty(expand('%'))
    return ''
  endif
  let path = expand('%:~:.:h')
  if path == '.'
    return ''
  endif
  let maxPathLen = winwidth(0) - 80
  if strlen(path) > maxPathLen
    let path = PathShorten(path, maxPathLen)
  endif
  return path.(exists('+shellslash') && !&shellslash ? '\' : '/')
endfunction

function! StatusLineLSP()
  if !exists('*coc#status')
    return ''
  endif
  let lspStatus = trim(coc#status())
  if empty(lspStatus)
    return ''
  endif

  return lspStatus
endfunction

function! s:bufferIndex(bufName)
  let i = 0
  while i < argc()
    if a:bufName == argv(i)
      return i
    endif
    let i = i + 1
  endwhile
  return -1
endfunction

function! StatusLineArglist()
  if argc() <= 1 || s:is_nofile() || s:is_small_win()
    return ''
  endif
  let bufIdx = s:bufferIndex(expand('%'))
  if bufIdx == argidx()
    " buffer is in args list and is the current index
    return argidx()+1 . ' of ' . argc()
  else
    return ''
  endif
endfunction

function! StatusLineFileFormat()
  if s:is_nofile() || s:is_small_win()
    return ''
  endif
  return &binary ? 'binary' : &fileformat == substitute(&fileformats, ",.*$", "", "") ? '' : &fileformat
endfunction

function! StatusLineFileEncoding()
  if s:is_nofile() || s:is_small_win()
    return ''
  endif
  return &binary ? 'binary' : &fileencoding == 'utf-8' ? (&bomb ? 'BOM' : '') : &fileencoding
endfunction

function! StatusLineModified()
  let modified_char = get(g:, 'use_nerd_font', 0) ? "\UE09E" : '+'
  let readonly_char = get(g:, 'use_nerd_font', 0) ? "\UE0A2" : "\UE0A2"
  if s:is_nofile()
    return ''
  endif
  let modified = &modified ? modified_char : ''
  let readonly = &readonly ? readonly_char : ''
  return modified . readonly
endfunction

function! StatusLineFugitive()
  if !exists('*fugitive#head') || &ft != 'dirvish' && s:is_nofile() || s:is_small_win()
    return ''
  endif
  try
    return fugitive#head()[0:20]
  catch
  endtry
  return ''
endfunction

function! StatusLineBufType()
  let bt = []
  if &buftype == 'nofile' && &bufhidden == 'hide' && !&swapfile
    call add(bt, 'scratch')
  elseif &previewwindow
    call add(bt, 'preview')
  elseif &diff
    call add(bt, 'diff')
  endif 
  return join(bt)
endfunction

function! StatusLineMode(...)
  if get(a:, 1, 0) == 1
    if &ft == 'term' && mode() == 't'
      return &ft
    else
      return ''
    endif
  endif
  if &ft == 'term' && mode() == 't'
    return ''
  endif
  if get(g:, 'use_nerd_font', 0)
    let m = &ft == 'dirvish' ? "\U24B9" :
        \ &ft == 'qf' ? (empty(getloclist(0)) ? "\U24C6" : "\U24C1") :
        \ &ft == 'grepr' ? "\U24BC" :
        \ &ft
  else
    let m = &ft == 'dirvish' ? "dir" :
        \ &ft == 'qf' ? (empty(getloclist(0)) ? 'qf' : 'loc') :
        \ &ft
  endif
  return !empty(m) ? m : 'none'
endfunction

function! Status(active)
  if a:active
    let sl = '%0*'
    let sl.= '%( %{StatusLineMode()} %)'
    let sl.= '%3*'
    let sl.= '%( %{StatusLineMode(1)} %)'
    let sl.= '%0*'
    let sl.= '%( %{StatusLinePath()}%1*%{StatusLineFilename()} %)'
    let sl.= '%<'
    let sl.= '%2*'
    let sl.= '%( %{StatusLineModified()} %)'
    let sl.= '%0*'
    let sl.= '%( %{StatusLineBufType()} %)'
    let sl.= '%( %{StatusLineArglist()} %)'
    let sl.= '%='
    let sl.= '%3*'
    let sl.= '%( %{StatusLineLSP()} %)'
    let sl.= '%0* '
    let sl.= '%( %{StatusLineFileEncoding()} %)'
    let sl.= '%( %{StatusLineFileFormat()} %)'
    let sl.= '%( %{&spell ? &spelllang : ""} %)'
    let sl.= '%( %{StatusLineDiffMerge()} %)'
    let sl.= '%2*'
    let sl.= '%( %{StatusLineFugitive()} %)'
    let sl.= '%0*'
    let sl.= '%( %4l:%-3c %3p%% %)'
    let sl.= '%2*'
    let sl.= '%(%{StatusLineWinNum()} %)'
    return sl
  else
    let sl = '%0*'
    let sl.= '%( %{StatusLineMode()} %)'
    let sl.= '%( %{StatusLinePath()}%{StatusLineFilename()} %)'
    let sl.= '%<'
    let sl.= '%( %{StatusLineModified()} %)'
    let sl.= '%( %{StatusLineBufType()} %)'
    let sl.= '%='
    let sl.= '%( %{StatusLineDiffMerge()} %)'
    let sl.= '%2*'
    let sl.= '%( %{StatusLineWinNum()} %)'
    return sl
  endif
endfunction

function! TabLine()
  let tabCount = tabpagenr('$')
  let tabnr = tabpagenr()
  let winnr = tabpagewinnr(tabnr)
  let cwd = PathShorten(getcwd(exists(':tcd') ? -1 : winnr, tabnr), &columns - 6)
  let isLocalCwd = haslocaldir(exists(':tcd') ? -1 : winnr, tabnr)
  let gitDir = cwd.'/.git'
  let gitHead = fugitive#Head(0, gitDir)

  let s = '%#TabLine#'
  let s.= ' ['.tabnr.'] '
  let s.= '%='
  let s.= '%2*'
  let s.= '%( '.gitHead.' %)'
  if isLocalCwd
    let s.= '%#TabLineSel#'
  else
    let s.= '%#TabLine#'
  endif
  let s.= ' '.cwd.' '
  return s
endfunction

function! s:RefreshStatus()
  for nr in filter(range(1, winnr('$')), 'v:val != winnr()')
    call setwinvar(nr, '&statusline', '%!Status(0)')
  endfor
  call setwinvar(winnr(), '&statusline', '%!Status(1)')
endfunction

let g:prettylittlestatus_disable=0

function! PrettyLittleStatus()
  augroup PrettyLittleStatus
    autocmd!
  augroup END

  if get(g:,'prettylittlestatus_disable', 0)
    set statusline&
    return
  endif

  set tabline=%!TabLine()

  autocmd PrettyLittleStatus SessionLoadPost,VimEnter,WinEnter,BufWinEnter,FileType,BufUnload * call <SID>RefreshStatus()

  if !has('vim_starting')
    call s:RefreshStatus()
  endif
endfunction

call PrettyLittleStatus()
" }}}

" Plugins config: {{{

" COC: {{{
if s:has_plug('coc.nvim')
  function! MyDefaultCocMappings()
    nmap <buffer> [c <Plug>(coc-diagnostic-prev)
    nmap <buffer> ]c <Plug>(coc-diagnostic-next))
    nmap <buffer> <C-k> <Plug>(coc-diagnostic-info))

    nmap <buffer> gd <Plug>(coc-definition)
    nmap <buffer> gy <Plug>(coc-type-definition)
    nmap <buffer> gi <Plug>(coc-implementation)
    nmap <buffer> gr <Plug>(coc-references)
    nmap <buffer> <C-.> <Plug>(coc-codeaction)
    nmap <buffer> <leader>w <Plug>(coc-range-select)
    xmap <buffer> <leader>w <Plug>(coc-range-select)
    xmap <buffer> <leader>W <Plug>(coc-range-select-backward)
    nmap <buffer> <leader>cl :CocList<CR>

    " Use K for show documentation in preview window
    nmap <buffer> K :call <SID>show_documentation()<CR>
  endfunction

  function! s:show_documentation()
    if &filetype == 'vim'
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction
endif
" }}}

" Fugitive: {{{
if s:has_plug('vim-fugitive')
  nnoremap <leader>vc :Gstatus<CR>
  nnoremap <leader>vl :Glog -- %<CR>
  xnoremap <leader>vl :Glog -- %<CR>
  nnoremap <leader>vm :Glog master.. -- %<CR>
  nnoremap <leader>va :Gblame<CR>
  xnoremap <leader>va :Gblame<CR>
  nnoremap <leader>vb :Gbrowse -<CR>
  xnoremap <leader>vb :Gbrowse -<CR>

  command! -nargs=* Glm :Glog master.. <args> --
  command! -nargs=* Glp :Glog @{push}.. <args> --
endif
" }}}

" Minpac: {{{
function! PackList(...)
  if !exists('*minpack#getpluglist')
    call PackInit()
  endif
  return join(sort(keys(minpac#getpluglist())), "\n")
endfunction

command! -nargs=1 -complete=custom,PackList PackDir call PackInit() | execute 'edit' minpac#getpluginfo(<q-args>).dir
command! -nargs=1 -complete=custom,PackList PackBrowse call PackInit() | execute 'Browse' minpac#getpluginfo(<q-args>).url
" }}}

" Targets: {{{
" add curly braces
" let g:targets_argOpening = '[({[]'
" let g:targets_argClosing = '[]})]'
" args separated by , and ;
" let g:targets_argSeparator = '[,;]'
" let g:targets_pairs = '()b {}B []q <>v'
" let g:targets_quotes = '"d '' `'
" }}}

" FSharp: {{{
if s:has_plug('vim-fsharp')
  let g:fsharpbinding_debug=1
  autocmd vimrc FileType fsharp call s:fsharpbinding_settings()
  function! s:fsharpbinding_settings()
    setlocal include=^#load\ 
    setlocal complete+=i

    nmap <buffer> <leader>i :call fsharpbinding#python#FsiSendLine()<CR>
    vmap <buffer> <leader>i :<C-U>call fsharpbinding#python#FsiSendSel()<CR>
    vmap <buffer> <leader>l ggVG:<C-U>call fsharpbinding#python#FsiSendSel()<CR>
  endfunction
endif
" }}}

" Dirvish: {{{
if s:has_plug('vim-dirvish')
  let g:dirvish_mode="sort ir /^.*[^\\\/]$/"

  nnoremap <silent> <leader>fj :call <SID>dirvish_open()<CR>
  nnoremap <leader>pe :Dirvish<CR>
  command! -nargs=? -complete=dir Explore Dirvish <args>
  command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
  command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>

  let s:dirvish_dir_search = '[\\\/]$'

  function! s:dirvish_open()
    let name = expand('%')
    if empty(name)
      Dirvish
    else
      Dirvish %
    endif
  endfunction

  function! s:dirvish_keepcursor(cmd)
    let l = getline('.')
    execute a:cmd
    keepjumps call search('\V\^'.escape(l,'\').'\$', 'cw')
    unlet l
  endfunction
  command! -nargs=+ KeepCursor call s:dirvish_keepcursor(<q-args>)

  function! s:ft_dirvish()
    syntax match DirvishPathExe /\v[^\\\/]+\.(ps1|cmd|exe|bat)$/
    syntax match DirvishPathHidden /\v\\@<=\.[^\\]+$/
    highlight link DirvishPathExe Function
    highlight link DirvishPathHidden Comment

    nmap <silent> <buffer> R :KeepCursor Dirvish %<CR>
    nmap <silent> <buffer> h <Plug>(dirvish_up)
    nmap <silent> <buffer> l :call dirvish#open('edit', 0)<CR>
    nmap <silent> <buffer> gh :KeepCursor keeppatterns g@\v[\\\/]\.[^\\\/]+[\\\/]?$@d _<CR>
    nnoremap <buffer> gR :grep!  %<left><left>
    nnoremap <buffer> gr :<cfile><C-b>grep!  <left>
    nmap <silent> <buffer> gP :cd % <bar>pwd<CR>
    nmap <silent> <buffer> gp :tcd % <bar>pwd<CR>
    cnoremap <buffer> <C-r><C-n> <C-r>=substitute(getline('.'), '.\+[\/\\]\ze[^\/\\]\+', '', '')<CR>
    nnoremap <buffer> vl :Glog -20 -- <cfile><CR>
  endfunction
endif
" }}}

" Unicode: {{{
if s:has_plug('unicode.vim')
  nnoremap ga :UnicodeName<CR>
endif
" }}}

" LSP {{{
if s:has_plug('LanguageClient-neovim')
  let g:LanguageClient_serverCommands = {
      \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
      \ 'javascript': ['tcp://127.0.0.1:2089'],
      \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
      \ 'typescript': ['tcp://127.0.0.1:2089'],
      \ 'typescript.tsx': ['tcp://127.0.0.1:2089'],
      \ }

  let g:LanguageClient_diagnosticsDisplay = {
        \ 1: {
        \     "name": "Error",
        \     "texthl": "ALEError",
        \     "signText": "‼",
        \     "signTexthl": "ALEErrorSign",
        \ },
        \ 2: {
        \     "name": "Warning",
        \     "texthl": "ALEWarning",
        \     "signText": "!",
        \     "signTexthl": "ALEWarningSign",
        \ },
        \ 3: {
        \     "name": "Information",
        \     "texthl": "ALEInfo",
        \     "signText": "i",
        \     "signTexthl": "ALEInfoSign",
        \ },
        \ 4: {
        \     "name": "Hint",
        \     "texthl": "ALEInfo",
        \     "signText": "~",
        \     "signTexthl": "ALEInfoSign",
        \ },
        \ }
endif

" }}}

" pandoc {{{
let g:pandoc#syntax#codeblocks#embeds#langs = [
      \ "rust",
      \ "bash=sh"]
let g:pandoc#modules#disabled = ['bibliographies']
autocmd vimrc FileType markdown nested set filetype=markdown.pandoc
" }}}

" vim-sexp: {{{
if s:has_plug('vim-sexp')
  let g:sexp_filetypes='clojure,scheme,lisp,timl,janet,fennel'
  let g:sexp_enable_insert_mode_mappings=0
endif
" }}}

"}}}

if has('vim_starting')
  colorscheme iceberg
endif
