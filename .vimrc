" vim: foldlevel=0 foldmethod=marker shiftwidth=2

" Environment: {{{

augroup vimrc
  autocmd!
augroup END

" quicker startup
if exists('+guioptions')
  set guioptions=M
endif
let g:loaded_vimballPlugin = 1

if has('vim_starting')
  if has('nvim')
    set shada=!,'1000,s100,h
  else
    set nocompatible
    set encoding=utf-8
    set viminfo='1000,s100,h
  endif
endif

" as of patch 276 this is not needed according to vim-sensible
" todo: try not changing shell.
if &shell =~# 'fish$'
  set shell=bash
endif

if exists('+packpath')
  set packpath+=$HOME/.vim
endif

for p in filter(globpath('~/.vim/mine/', '*', '', 1), 'isdirectory(v:val)')
  execute 'set runtimepath+='.p
endfor

" Windows Compatible: {{{
let s:is_win = has('win32') || has('win64')
let s:is_gui = has('gui_running')
if s:is_win
  " On Windows, also use '.vim' instead of 'vimfiles'
  set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
  " On windows, if gvim.exe is executed from cygwin bash shell, the shell
  " needs to be changed to the shell most plugins expect on windows.
  " This does not change &shell inside cygwin or msys vim.
  if &shell =~# 'bash$'
    set shell=$COMSPEC
  endif

  if has('vim_starting')
    let g:shell_defaults = { 'shell':&shell, 'shellcmdflag':&shellcmdflag,
          \ 'shellquote':&shellquote, 'shellxquote':&shellxquote,
          \ 'shellpipe':&shellpipe, 'shellredir':&shellredir,
          \ 'shellslash':&shellslash, 'shelltemp':&shelltemp }
  endif
  function! s:toggle_powershell()
    if &shell ==# 'powershell'
      let s = g:shell_defaults
      let &shell=s.shell
      let &shellquote=s.shellquote
      let &shellpipe=s.shellpipe
      let &shellredir=s.shellredir
      let &shellcmdflag=s.shellcmdflag
      let &shellxquote=s.shellxquote
      let &shellslash=s.shellslash
      let &shelltemp=s.shelltemp
    else
      set shell=powershell shellquote=\" shellpipe=\| shellredir=>
      set shellcmdflag=\ -NonInteractive\ -WindowStyle\ Hidden\ -NoProfile\ -ExecutionPolicy\ RemoteSigned\ -Command
      let &shellxquote=' '
      set shellslash noshelltemp
    endif
  endfunction
  nnoremap co! :call <SID>toggle_powershell()<CR>

  let g:statusline_use_emoji = 1
endif

"}}}

"}}}

" Plugins: {{{
call plug#begin('~/.vim/bundle')

" Base
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-repeat'
Plug 'kana/vim-textobj-user'
Plug 'Shougo/vimproc'

" Colour schemes and pretty things
Plug 'leafgarland/gruvbox/'
Plug 'leafgarland/direwolf'
Plug 'justinmk/molokai'
Plug 'romainl/Apprentice'
Plug 'rakr/vim-one'
Plug 'guns/xterm-color-table.vim', {'on': 'XtermColorTable'}
Plug 'Rykka/colorv.vim', {'on': 'ColorV'}

" Motions and actions
Plug 'kana/vim-textobj-indent'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-abolish'
Plug 'tommcdo/vim-exchange'
Plug 'matchit.zip'
Plug 'wellle/targets.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'justinmk/vim-sneak'
Plug 'idbrii/vim-endoscope'
Plug 'tommcdo/vim-lion'

" Tools
Plug 'tpope/vim-fugitive' | Plug 'idanarye/vim-merginal'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-projectionist'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'justinmk/vim-dirvish'
Plug 'chrisbra/unicode.vim'
Plug 'romainl/vim-cool'
Plug 'junegunn/vim-peekaboo'
Plug 'ludovicchabant/vim-gutentags'

" Filetypes
Plug 'ChrisYip/Better-CSS-Syntax-for-Vim', {'for': 'css'}
Plug 'elzr/vim-json', {'for': 'json'}
Plug 'tpope/vim-jdaddy', {'for': 'json'}
Plug 'vim-pandoc/vim-pandoc-syntax', {'for': 'pandoc'}
Plug 'vim-pandoc/vim-pandoc', {'for': 'pandoc'}
Plug 'PProvost/vim-ps1', {'for': 'ps1'}
Plug 'fsharp/vim-fsharp', {'for': 'fsharp', 'do': 'make'}
Plug 'tpope/vim-fireplace', {'for': 'clojure'}
Plug 'guns/vim-clojure-static', {'for': 'clojure'}
Plug 'guns/vim-sexp', {'for': ['clojure', 'scheme']} |
      \ Plug 'tpope/vim-sexp-mappings-for-regular-people', {'for': ['clojure', 'scheme']}
Plug 'guns/vim-clojure-highlight', {'for': 'clojure'}
Plug 'vim-erlang/vim-erlang-runtime', {'for': 'erlang'}
Plug 'vim-erlang/vim-erlang-compiler', {'for': 'erlang'}
Plug 'vim-erlang/vim-erlang-omnicomplete', {'for': 'erlang'}
Plug 'vim-erlang/vim-erlang-tags', {'for': 'erlang'}
Plug 'edkolev/erlang-motions.vim', {'for': 'erlang'}
Plug 'elixir-lang/vim-elixir', {'for': 'elixir'}
Plug 'pangloss/vim-javascript', {'for': 'javascript'}
Plug 'mxw/vim-jsx', {'for': 'javascript'}
Plug 'leafgarland/typescript-vim', {'for': 'typescript'}
Plug 'Blackrush/vim-gocode', {'for': 'go'}
Plug 'findango/vim-mdx', {'for': 'mdx'}
Plug 'elmcast/elm-vim', {'for': 'elm'}
Plug 'rust-lang/rust.vim', {'for': 'rust'}
Plug 'raichoo/purescript-vim', {'for': 'purescript'}
Plug 'wlangstroth/vim-racket', {'for': 'racket'}
Plug 'beyondmarc/glsl.vim'
Plug 'cespare/vim-toml', {'for': 'toml'}
Plug 'dleonard0/pony-vim-syntax', {'for': 'pony'}
Plug 'OrangeT/vim-csharp', {'for': 'cs'}
Plug 'idris-hackers/idris-vim'

if s:is_win && s:is_gui
  Plug 'kkoenig/wimproved.vim'
endif

if !empty($TMUX)
  Plug 'tpope/vim-tbone'
  Plug 'wellle/tmux-complete.vim' 
  Plug 'tmux-plugins/vim-tmux-focus-events'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'tmux-plugins/vim-tmux'
endif

if executable('fish')
  Plug 'dag/vim-fish', {'for': 'fish'}
endif

if has('nvim')
  Plug 'benekastah/neomake'
  Plug 'cloudhead/neovim-fuzzy'
  Plug 'radenling/vim-dispatch-neovim'
  Plug 'Shougo/deoplete.nvim'
  Plug 'racer-rust/vim-racer'
else
  Plug 'Valloric/YouCompleteMe'
  Plug 'scrooloose/syntastic', {'for': 'fsharp'}
endif

if has('mac') && !has('gui_running') && !has('nvim')
  Plug 'jszakmeister/vim-togglecursor'
endif

call plug#end()

function! s:has_plug(name)
  return index(g:plugs_order, a:name) >= 0
endfunction
"}}}

" General: {{{

" fix little startup bug with setglobal
command! -nargs=+ SetGlobal if has('vim_starting')<bar>set <args><bar>else<bar>setglobal <args><bar>endif

set mouse=a

set shortmess+=Im
set viewoptions=folds,options,cursor,unix,slash
set history=10000
set hidden

set virtualedit=block
set foldopen+=jump
set smartcase
set nojoinspaces
set formatoptions+=n1

set backup
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//
set undolevels=5000
set undofile

let g:netrw_menu = 0

if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading\ -HS
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
  autocmd vimrc CursorHold,FocusGained,FocusLost * rshada|wshada
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
set noshowcmd
set lazyredraw

set sidescroll=1
set sidescrolloff=5
set scrolloff=5

set wildmode=longest:full,full
set wildignorecase
set wildoptions=tagfile
set wildcharm=<C-z>
set number
set winminheight=0
set ignorecase
set foldlevelstart=10

set listchars=tab:→\ ,trail:─,extends:❭,precedes:❬,nbsp:+
set fillchars=vert:┃,fold:-

set splitright
set switchbuf=useopen

set tags=./tags,~/.vimtags

" Show CursorLine in active window only
let g:myvimrc_manage_cursorline=0
if g:myvimrc_manage_cursorline
  set cursorline
  autocmd vimrc WinEnter,InsertLeave * setlocal cursorline
  autocmd vimrc WinLeave,InsertEnter * setlocal nocursorline
endif

" Opens quick fix window when there are items, close it when empty
autocmd vimrc QuickFixCmdPost [^l]* nested CWindow
autocmd vimrc QuickFixCmdPost    l* nested LWindow

if has('nvim')
  autocmd vimrc BufEnter term://* setfiletype term|startinsert
endif
"}}}

" GUI Settings: {{{
if exists('+termguicolors') && !has('gui_running') && !has('win32')
  set termguicolors
  if has('nvim')
    let g:terminal_color_0  = '#282828'
    let g:terminal_color_1  = '#cc241d'
    let g:terminal_color_2  = '#98971a'
    let g:terminal_color_3  = '#d79921'
    let g:terminal_color_4  = '#458588'
    let g:terminal_color_5  = '#b16286'
    let g:terminal_color_6  = '#689d6a'
    let g:terminal_color_7  = '#a89984'
    let g:terminal_color_8  = '#928374'
    let g:terminal_color_9  = '#fb4934'
    let g:terminal_color_10 = '#b8bb26'
    let g:terminal_color_11 = '#fabd2f'
    let g:terminal_color_12 = '#83a598'
    let g:terminal_color_13 = '#d3869b'
    let g:terminal_color_14 = '#83c07c'
    let g:terminal_color_15 = '#ebdbb2'
  endif
endif

if exists('+guioptions')
  set guicursor+=c:ver25-Cursor/lCursor,a:blinkon0
  set guioptions+=c
  set linespace=0
  if exists('+renderoptions')
    set renderoptions=type:directx,taamode:1,renmode:5,geom:1
  endif

  if has('vim_starting')
    set lines=50
    set columns=120
    set guifont=Source_Code_Pro:h9,Monaco:h16,Consolas:h11,Courier\ New:h14
  endif
endif
"}}}

" Formatting: {{{
SetGlobal nowrap
SetGlobal linebreak
SetGlobal breakindent
SetGlobal autoindent
SetGlobal expandtab
SetGlobal tabstop=4
SetGlobal shiftwidth=4
SetGlobal softtabstop=4
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

xnoremap . :normal .<CR>

nnoremap <leader>t :tjump<space>
nnoremap g<C-P> :pwd<CR>

" buffer text object
onoremap ae :<C-u>normal vae<CR>
xnoremap ae GoggV

" in next/last word text objects
onoremap inw :<C-u>normal vinw<CR>
xnoremap inw wowiw
onoremap ilw :<C-u>normal vilw<CR>
xnoremap ilw geogeiw
onoremap anw :<C-u>normal vanw<CR>
xnoremap anw wowaw
onoremap alw :<C-u>normal valw<CR>
xnoremap alw geogeaw
onoremap inW :<C-u>normal vinW<CR>
xnoremap inW WoWiW
onoremap ilW :<C-u>normal vilW<CR>
xnoremap ilW gEogEiW
onoremap anW :<C-u>normal vanW<CR>
xnoremap anW WoWaW
onoremap alW :<C-u>normal valW<CR>
xnoremap alW gEogEaW

onoremap inl :<C-u>normal vinl<CR>
xnoremap inl jojV
onoremap ill :<C-u>normal vill<CR>
xnoremap ill kokV

" disable exmode maps
nnoremap Q :bdelete!<CR>
nmap gQ <Nop>

if has('nvim')
  tnoremap <Esc><Esc> <C-\><C-n>
  " <C-Space> is <C-@>
  tnoremap <C-@> <C-\><C-n>:
  tnoremap <C-w> <C-\><C-n><C-w>
  if empty($TMUX)
    tnoremap <C-a>n <C-\><C-n>gt
    nnoremap <C-a>n gt
    tnoremap <C-a>p <C-\><C-n>gT
    nnoremap <C-a>p gT
    tnoremap <C-a>c <C-\><C-n>:tabnew term://fish<CR>
    nnoremap <C-a>c :tabnew term://fish<CR>
    tnoremap <C-a>s <C-\><C-n>:split term://fish<CR>
    nnoremap <C-a>s :split term://fish<CR>
    tnoremap <C-a>v <C-\><C-n>:vsplit term://fish<CR>
    nnoremap <C-a>v :vsplit term://fish<CR>
    tnoremap <C-a><C-l> <C-l>
    tnoremap <C-a><C-a> <C-a>
    tnoremap <C-h> <C-\><C-n><C-w>h
    tnoremap <C-l> <C-\><C-n><C-w>l
    tnoremap <C-j> <C-\><C-n><C-w>j
    tnoremap <C-k> <C-\><C-n><C-w>k
  endif
endif

" run last make cmd
nnoremap <leader>xm q:?\([Mm]ake\\|Dispatch\)<CR><CR>

" Show syntax groups under cursor
map <silent> <F11> :for id in synstack(line("."), col("."))<bar>
      \ echo synIDattr(id, "name").' '<bar> execute 'echohl' synIDattr(synIDtrans(id), "name") <bar> echon synIDattr(synIDtrans(id), "name") <bar> echohl None <bar>
      \ endfor<CR>

nnoremap <leader>fs :update<CR>
nnoremap <leader>fq :update<bar>BClose<CR>
nnoremap <leader>fn :VScratch<CR>
nnoremap <leader>fN :Scratch<CR>
nnoremap <leader>fL :Scratch<bar><CR>:let b:ycm_largfile=1<bar>file logs<C-r>=bufnr('%')<CR><bar>setf log4net<CR>
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

nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h

nmap <leader>w <C-w>
nnoremap <leader>ww <C-w>p

nnoremap <silent> <C-w>z :wincmd z<Bar>cclose<Bar>lclose<CR>

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

nnoremap <tab> <c-w>w
nnoremap <s-tab> <c-w>W

nnoremap j gj
nnoremap k gk

nnoremap <leader>j i<CR><Esc>

nnoremap <leader>eF :<C-U>let &foldlevel=v:count<CR>

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

" ⇅
nnoremap <M-j> :m+<CR>
nnoremap <M-k> :m-2<CR>
xnoremap <M-j> :m'>+<<CR>gv
xnoremap <M-k> :m-2<CR>gv

" ⇄
nnoremap <M-h> <<
nnoremap <M-l> >>
xnoremap <M-h> <gv
xnoremap <M-l> >gv

nnoremap H ^
nnoremap L $
xnoremap H ^
xnoremap L g_

nnoremap gI `.

xnoremap / <Esc>/\%V

nnoremap <leader>sg :g//#<left><left>
nnoremap <leader>sc :%s///gn<left><left><left><left>
xnoremap <leader>sc :s///gn<left><left><left><left>

nnoremap <silent> <leader>s/ :s,\\,/,g<CR>
nnoremap <silent> <leader>s\ :s,/,\\,g<CR>
xnoremap <silent> <leader>s/ :s,\%V\\,/,g<CR>
xnoremap <silent> <leader>s\ :s,\%V/,\\,g<CR>

nnoremap <leader>sl :keeppatterns lvimgrep /<C-R><C-R>//j %<CR>

nnoremap <leader>8 :keeppatterns lvimgrep /<C-R><C-R><C-W>/j %<CR>
xnoremap <leader>8 y:<C-U>keeppatterns lvimgrep /<C-R><C-R>"/j %<CR>

nnoremap <leader>sv :v//d<CR>
nnoremap <leader>sV :g//d<CR>
xnoremap <leader>sv :v//d<CR>
xnoremap <leader>sV :g//d<CR>

inoremap jk <esc>
cnoremap jk <C-c> 

inoremap (<CR> (<CR>)<Esc>O
inoremap {<CR> {<CR>}<Esc>O
inoremap {; {<CR>};<Esc>O
inoremap {, {<CR>},<Esc>O
inoremap [<CR> [<CR>]<Esc>O
inoremap [; [<CR>];<Esc>O
inoremap [, [<CR>],<Esc>O

cnoremap cd. cd %:p:h
cnoremap cd.. cd %:p:h:h
cnoremap %% <C-R>=expand('%:h').'/'<cr>
cnoremap %%% <C-R>=expand('%:h:h').'/'<cr>
cnoremap <C-r><C-l> <C-r>=getline('.')<CR>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

"}}}

" Filetypes: {{{

" log: {{{
autocmd vimrc BufNewFile,BufRead *.log setfiletype log4net
autocmd vimrc BufNewFile,BufRead *.log.? setfiletype log4net
" }}}

" json: {{{
autocmd vimrc FileType json setlocal equalprg=python\ -m\ json.tool
autocmd vimrc FileType json setlocal shiftwidth=2 | setlocal concealcursor=n
" }}}

" xml: {{{
let g:xml_syntax_folding=1
autocmd vimrc BufNewFile,BufRead *.config setfiletype xml
autocmd vimrc BufNewFile,BufRead *.*proj setfiletype xml
autocmd vimrc BufNewFile,BufRead *.xaml setfiletype xml

autocmd vimrc FileType xml call s:xml_filetype_settings()
function! s:xml_filetype_settings()
  setlocal foldmethod=syntax
  setlocal equalprg=xmllint\ --format\ --recover\ -
  setlocal shiftwidth=2
  " the xml highlighting can be broken on large files, so we
  " increase the max num of lines that the highlighting examines
  syntax sync maxlines=10000
endfunction
" }}}

" fsharp: {{{
if executable('fantomas')
  autocmd vimrc FileType fsharp setlocal equalprg=fantomas\ --stdin\ --stdout
endif
autocmd vimrc FileType fsharp setlocal shiftwidth=2
autocmd vimrc FileType fsharp let b:end_trun_str = ';;'
" }}}

" vim: {{{
autocmd vimrc FileType vim setlocal keywordprg=:help | setlocal omnifunc=syntaxcomplete#Complete | setlocal shiftwidth=2
" }}}

" help: {{{
autocmd vimrc FileType help call s:help_filetype_settings()
function! s:help_filetype_settings()
  nnoremap <buffer> q :wincmd c<CR>
endfunction
" }}}

" rust: {{{
autocmd vimrc FileType rust setlocal keywordprg=:DevDocs\ rust
" }}}

" pandoc/markdown: {{{
autocmd vimrc FileType pandoc setlocal foldcolumn=0 | setlocal concealcursor+=n
" }}}

"}}}

" Plugins config: {{{

" wimproved: {{{
if s:has_plug('wimproved.vim')
  autocmd vimrc GUIEnter * silent! WToggleClean
  nnoremap <silent> coF :WToggleFullscreen<CR>
endif
" }}}

" VimPlug: {{{
function! s:plug_gx()
  let line = getline('.')
  let sha  = matchstr(line, '^  [*|\/\\ ]*\zs[0-9a-f]\{7\}\ze ')
  let name = empty(sha) ? matchstr(line, '^[-x+] \zs[^:]\+\ze:')
                      \ : getline(search('^- .*:$', 'bn'))[2:-2]
  let uri  = get(get(g:plugs, name, {}), 'uri', '')
  if uri !~ 'github.com'
    return
  endif
  let repo = matchstr(uri, '[^:/]*/'.name)
  let url  = empty(sha) ? 'https://github.com/'.repo
                      \ : printf('https://github.com/%s/commit/%s', repo, sha)
  call netrw#BrowseX(url, 0)
endfunction

autocmd vimrc FileType vim-plug nnoremap <buffer> <silent> gx :call <sid>plug_gx()<cr>
" }}}

" Vimproc: {{{
let g:vimproc#download_windows_dll=1
" }}}

" Surround: {{{
let g:surround_no_insert_mappings = 1
" }}}

" TBone: {{{
" trun originally from justinmk/config

if s:has_plug('vim-tbone')
  function! s:tmux_run_operator(type, ...)
    let sel_save = &selection
    let &selection = "inclusive"
    let isvisual = a:0

    let lines = isvisual ? getline("'<", "'>") : getline("'[", "']")
    if a:type !=# 'line' && a:type !=# 'V'
      let startcol  = isvisual ? col("'<") : col("'[")
      let endcol    = isvisual ? col("'>")-2 : col("']")
      let lines[0]  = lines[0][startcol-1 : ]
      let lines[-1] = lines[-1][ : endcol-1]
    endif

    call s:tmux_run(0, 1, join(lines, "\<cr>"))

    let &selection = sel_save
  endf

  nnoremap <silent> yrr V:<c-u>call <sid>tmux_run_operator(visualmode(), 1)<CR>
  xnoremap <silent> R   :<c-u>call <sid>tmux_run_operator(visualmode(), 1)<CR>
  nnoremap <silent> yr :set opfunc=<sid>tmux_run_operator<CR>g@

  function! s:tmux_run(creatnew, run, cmd) abort
    "Create a new pane if demanded or if we are _in_ the target pane.
    if a:creatnew || tbone#pane_id(".") == tbone#pane_id("bottom-right")
      Tmux split-window -d -p 33
    endif
    call tbone#send_keys("bottom-right",
          \ a:cmd.get(b:, 'end_trun_str', '').(a:run ? "\<cr>" : ""))
  endf

  command! -nargs=? -bang Trun call s:tmux_run(<bang>0, 1, <q-args>)
endif

" }}}

" Projectionist: {{{
let g:projectionist_heuristics = {
      \ "build.fsx": {
      \   "src/*.fs": {
      \     "type": "source",
      \     "alternate": "test/{}.fs",
      \   },
      \   "test/*.fs": {
      \     "type": "test",
      \     "alternate": "src/{}.fs",
      \   },
      \   "*.fsx": {"type": "script"}
      \ }}
" }}}

" Targets: {{{
" add curly braces
let g:targets_argOpening = '[({[]'
let g:targets_argClosing = '[]})]'
" args separated by , and ;
let g:targets_argSeparator = '[,;]'
let g:targets_pairs = '()b {}B []q <>v'
let g:targets_quotes = '"d '' `'
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

" rust racer {{{
if s:has_plug('vim-racer')
  if !exists('$RUST_SRC_PATH')
    let $RUST_SRC_PATH = '/Users/leaf/Dev/rust/source/rustc-1.10.0/src'
  endif
endif
" }}}

" Ultisnips {{{
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
" }}}

" deoplete {{{

if s:has_plug('deoplete.nvim')
  let g:deoplete#enable_at_startup=1
  let g:deoplete#disable_auto_complete=1

  inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ deoplete#mappings#manual_complete()

  inoremap <expr><BS>
    \ deoplete#smart_close_popup()."\<C-h>"

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
  endfunction
endif
" }}}

" YouCompleteMe {{{
if s:has_plug('YouCompleteMe')

  if !exists('$RUST_SRC_PATH')
    let $RUST_SRC_PATH = '/Users/leaf/Dev/rust/source/rustc-1.10.0/src'
  endif
  let g:ycm_rust_src_path = $RUST_SRC_PATH

  " Sometimes YCM is unhappy with the python it uses, so we can force it to
  " use a specific python
  let s:ycm_python=expand('c:/Dev/Tools/Python35/python.exe')
  if executable(s:ycm_python)
    let g:ycm_server_python_interpreter = s:ycm_python
  endif

  " let g:ycm_server_log_level = 'debug'
  " let g:ycm_semantic_triggers =  {
  "   \   'c' : ['->', '.'],
  "   \   'objc' : ['->', '.'],
  "   \   'ocaml' : ['.', '#'],
  "   \   'cpp,objcpp' : ['->', '.', '::'],
  "   \   'perl' : ['->'],
  "   \   'php' : ['->', '::'],
  "   \   'cs,java,javascript,d,vim,python,perl6,scala,vb,elixir,go' : ['.'],
  "   \   'ruby,rust' : ['.', '::'],
  "   \   'lua' : ['.', ':'],
  "   \   'elm' : ['.'],
  "   \   'erlang' : [':'],
  "   \   'fsharp' : ['.'],
  "   \ }

  let g:ycm_semantic_triggers =  {
    \   'elm' : ['.'],
    \   'fsharp' : ['.'],
    \ }

  let g:ycm_filetype_blacklist = {
        \ 'tagbar' : 1,
        \ 'qf' : 1,
        \ 'notes' : 1,
        \ 'markdown' : 1,
        \ 'unite' : 1,
        \ 'text' : 1,
        \ 'vimwiki' : 1,
        \ 'pandoc' : 1,
        \ 'infolog' : 1,
        \ 'mail' : 1,
        \ 'dirvish' : 1,
        \ 'log4net' : 1
        \}

  nnoremap <leader>gd :YcmCompleter GoTo<CR>
  nnoremap <leader>ht :YcmCompleter GetType<CR>
endif
" }}}

" Dirvish: {{{
if s:has_plug('vim-dirvish')
  nnoremap <leader>fj :Dirvish %:p:h<CR>
  nnoremap <leader>pe :Dirvish<CR>

  let s:dirvish_dir_search = '[\\\/]$'

  function! s:dirvish_keepcursor(cmd)
    let l = getline('.')
    execute a:cmd
    keepjumps call search('\V\^'.escape(l,'\').'\$', 'cw')
    unlet l
  endfunction
  command! -nargs=+ KeepCursor call s:dirvish_keepcursor(<q-args>)

  function! s:dirvish_settings()
    " sort dirs top
    KeepCursor sort ir /^.*[^\\\/]$/

    nmap <silent> <buffer> R :KeepCursor Dirvish %<CR>
    nmap <silent> <buffer> h <Plug>(dirvish_up)
    nmap <silent> <buffer> l :call dirvish#open('edit', 0)<CR>
    nmap <silent> <buffer> gh :KeepCursor keeppatterns g@\v[\\\/]\.[^\\\/]+[\\\/]?$@d<CR>
    nnoremap <buffer> gR :Grep  %<left><left>
    nnoremap <buffer> gr :<cfile><C-b>Grep  <left>
    nmap <silent> <buffer> gP :cd % <bar>pwd<CR>
    nmap <silent> <buffer> gp :lcd % <bar>pwd<CR>
    cnoremap <buffer> <C-r><C-n> <C-r>=substitute(getline('.'), '.\+[\/\\]\ze[^\/\\]\+', '', '')<CR>
    call fugitive#detect(@%)
  endfunction

  autocmd vimrc FileType dirvish :call s:dirvish_settings()
endif
" }}}

" Syntastic: {{{
if s:has_plug('syntastic')
  let g:syntastic_stl_format = '[Syntax: %E{line:%fe }%W{#W:%w}%B{ }%E{#E:%e}]'
endif
" }}}

"{{{ Slimux
if s:has_plug('slimux')
  autocmd vimrc FileType scheme call s:slimux_scheme_settings()
  autocmd vimrc FileType fsharp call s:slimux_fsharp_settings()
  function! s:slimux_scheme_settings()
    nnoremap <buffer> <silent> <leader>l :SlimuxSchemeEvalBuffer<CR>
    nnoremap <buffer> <silent> <leader>i :SlimuxSchemeEvalDefun<CR>
    xnoremap <buffer> <silent> <leader>i :SlimuxREPLSendSelection<CR>
  endfunction
  function! s:slimux_fsharp_settings()
    nnoremap <buffer> <silent> <leader>l :SlimuxREPLSendBuffer<CR>
    nnoremap <buffer> <silent> <leader>i :SlimuxREPLSendLine<CR>
    xnoremap <buffer> <silent> <leader>i :SlimuxREPLSendSelection<CR>
  endfunction
  " Add ;; to the end of the fsharp sent text
  function! SlimuxPost_fsharp(target_pane)
    call system('tmux send-keys -t ' . a:target_pane . ' \\\; \\\; C-m')
  endfunction
  let g:slimux_scheme_keybindings=1
endif
"}}}

" colorscheme gruvbox: {{{
if s:has_plug('gruvbox')
  if s:is_gui
    let g:gruvbox_invert_selection=0
    let g:gruvbox_contrast_dark='medium'
    let g:gruvbox_contrast_light='hard'
  endif
  let g:gruvbox_italic=0
endif
"}}}

" colorscheme molokai: {{{
if s:has_plug('molokai')
  function! s:MolokaiCustomise()
    let slfg = s:get_colour('StatusLine', 'fg')
    let slbg = s:get_colour('StatusLine', 'bg')
    let sbg = s:get_colour('Special', 'bg')
    let sfg = s:get_colour('Special', 'fg')
    let cfg = s:get_colour('Comment', 'fg')
    let wmbg = s:get_colour('WildMenu', 'bg')

    call s:SetHiColour('StatusLine', slfg, slbg, 'NONE')
    call s:SetHiColour('StatusLineNC', cfg, slbg, 'NONE')
    call s:SetHiColour('User1', sfg, slbg, 'bold')
    call s:SetHiColour('User2', sfg, wmbg, 'bold')
    call s:SetHiColour('VertSplit', slbg, 'bg', 'NONE')
    call s:SetHiColour('Conceal', sfg, 'bg', 'NONE')
  endfunction
  autocmd vimrc ColorScheme molokai :call <SID>MolokaiCustomise()
endif
"}}}

" colorscheme one: {{{
if s:has_plug('vim-one')
  function! s:OneCustomise()
    " let slfg = s:get_colour('StatusLine', 'fg')
    let slbg = s:get_colour('StatusLine', 'bg')
    let sbg = s:get_colour('Special', 'bg')
    let sfg = s:get_colour('Special', 'fg')
    let s2fg = s:get_colour('Constant', 'fg')
    let cfg = s:get_colour('Comment', 'fg')
    let wmbg = s:get_colour('WildMenu', 'bg')
    let vbg = s:get_colour('Visual', 'bg')

    let slfg = &background=='dark' ? '#d3d7de' : '#202126'

    call s:SetHiColour('StatusLine', slfg, slbg, 'NONE')
    call s:SetHiColour('StatusLineNC', cfg, slbg, 'NONE')
    call s:SetHiColour('User1', sfg, slbg, 'bold')
    call s:SetHiColour('User2', s2fg, slbg, 'bold')
    call s:SetHiColour('VertSplit', slbg, 'bg', 'NONE')
    call s:SetHiColour('Conceal', sfg, 'bg', 'NONE')

    call s:SetHiColour('String', s:get_colour('String', 'fg'), slbg, 'NONE')
    call s:SetHiColour('Folded', 'fg', cfg, 'NONE')

    call s:SetHiColour('MatchParen', 'NONE', vbg, 'underline')

    highlight! link TabLine StatusLine
    highlight! link TabLineFill StatusLine 
    highlight! link TabLineSel User1 

    highlight! link Pmenu StatusLine
    highlight! link PmenuSbar StatusLine
    highlight! link PmenuSel WildMenu

    highlight link helpCommand Number
    highlight link helpSectionDelim Comment
    highlight link helpExample Special
    highlight link helpHyperTextJump Underlined

    highlight clear vimCommand
    highlight link vimMapLhs Special
    highlight link vimMapRhs Normal
    highlight link vimMapMod Number
    highlight link vimMapModKey Number
    highlight link vimNotation Constant
    highlight link vimBracket Constant

    highlight link rustCommentLinedDoc NonText

    if has('nvim')
      let g:terminal_color_0  = '#282c34'
      let g:terminal_color_1  = '#be5046'
      let g:terminal_color_2  = '#50a14f'
      let g:terminal_color_3  = '#d19a66'
      let g:terminal_color_4  = '#5889F3'
      let g:terminal_color_5  = '#a626a4'
      let g:terminal_color_6  = '#2EABE5'
      let g:terminal_color_7  = '#828997'
      let g:terminal_color_8  = '#5c6370'
      let g:terminal_color_9  = '#e06c75'
      let g:terminal_color_10 = '#98c379'
      let g:terminal_color_11 = '#e5c07b'
      let g:terminal_color_12 = '#61afef'
      let g:terminal_color_13 = '#c678dd'
      let g:terminal_color_14 = '#56b6c2'
      let g:terminal_color_15 = '#abb2bf'
    endif
  endfunction
  autocmd vimrc ColorScheme one :call <SID>OneCustomise()
endif
"}}}

" colorscheme apprentice: {{{
if s:has_plug('Apprentice')
  function! s:ApprenticeCustomise()
    let slfg = s:get_colour('PMenu', 'fg')
    let slbg = s:get_colour('PMenu', 'bg')
    let sfg = s:get_colour('Constant', 'fg')
    let s2fg = s:get_colour('Operator', 'fg')
    let tfg = s:get_colour('TabLine', 'fg')

    call s:SetHiColour('StatusLine', slfg, slbg, 'NONE')
    call s:SetHiColour('StatusLineNC', tfg, slbg, 'NONE')
    call s:SetHiColour('User1', sfg, slbg, 'bold')
    call s:SetHiColour('User2', s2fg, slbg, 'bold')
    call s:SetHiColour('VertSplit', slbg, 'bg', 'NONE')
  endfunction
  autocmd vimrc ColorScheme apprentice :call <SID>ApprenticeCustomise()
endif
"}}}

" colorscheme nofrils: {{{
if s:has_plug('nofrils')
  let g:nofrils_strbackgrounds = 1

  function! s:NofrilsCustomise()
    highlight! link VertSplit NonText
    highlight! link Folded String
    if &background == 'dark'
      highlight! WildMenu guibg=black guifg=yellow gui=bold
      highlight! StatusLine guifg=black guibg=white gui=bold
    else
      highlight! WildMenu guifg=black guibg=yellow gui=bold
      highlight! StatusLine guifg=white guibg=black gui=bold
    endif
    highlight! xmlAttrib gui=italic
    highlight! Keyword gui=italic
    highlight! Statement gui=italic
  endfunction
  autocmd vimrc ColorScheme nofrils-* :call <SID>NofrilsCustomise()

  function! s:NofrilsBackgroundToggle()
    if get(g:, 'colors_name', '') !~ "nofrils"
      return
    endif
    if &background == 'dark'
      colorscheme nofrils-dark
    else
      colorscheme nofrils-light
    endif
    call s:NofrilsCustomise()
    call PrettyLittleStatus()
  endfunction
  autocmd vimrc OptionSet background :call <SID>NofrilsBackgroundToggle()
endif
" }}}

" Tmux Navigator: {{{
if has('nvim') && s:has_plug('vim-tmux-navigator')
  " <C-H> is seen as <BS> with some terms.
  " In ITerm map <c-h> to escape sequence [104;5u
  tnoremap <C-h> <C-\><C-n>:TmuxNavigateLeft<CR>
  tnoremap <C-j> <C-\><C-n>:TmuxNavigateDown<CR>
  tnoremap <C-l> <C-\><C-n>:TmuxNavigateRight<CR>
  tnoremap <C-k> <C-\><C-n>:TmuxNavigateUp<CR>
endif
" }}}

" Unicode: {{{
if s:has_plug('unicode.vim')
  nnoremap ga :UnicodeName<CR>
endif
" }}}

" Gutentags: {{{
if s:has_plug('vim-gutentags')
  let g:gutentags_project_root = ['pom.xml']
  let g:gutentags_generate_on_missing = 0
  let g:gutentags_cache_dir = '~/.vim/tags_cache'
endif
" }}}

" Grepper {{{
if s:has_plug('vim-grepper')
  let g:grepper           = {}
  let g:grepper.tools     = ['rg', 'git']
  let g:grepper.rg        = {'grepprg': 'rg --vimgrep --no-heading -HS'}
  let g:grepper.jump      = 0

  command! -nargs=* Grep GrepperRg <args>
endif
" }}}

"}}}

" Commands & Functions: {{{

" Hack buffer names relative to cwd, see
" https://groups.google.com/forum/#!topic/vim_use/Vq0z2DJH2So
" Useful to get relative paths in quickfix after grep
command! CWindow 0split | lcd . | quit | cwindow
command! LWindow 0split | lcd . | quit | lwindow

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
  if has('mac')
    call system('open ' . q)
  else
    call system('"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" "' . q . '"')
  endif
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
function! s:WinFindBuf(bnr)
  if exists('*win_findbuf')
    return win_findbuf(a:bnr)
  else
    let winids = []
    for w in nvim_get_windows()
      if nvim_win_get_buffer(w) == a:bnr
	call add(winids, w)
      endif
    endfor
    return winids
  endif
endfunction

function! BClose(force) abort
  if !a:force && &modified
    echohl ErrorMsg | echo 'buffer has unsaved changes (use BClose! to discard changes)' | echohl None
    return
  endif

  let bnr = bufnr('%')
  for id in s:WinFindBuf(bnr)
    if !win_gotoid(id)
      continue
    endif

    if bufexists(0) && bufnr('#') != bnr
      buffer #
    else
      bprevious
    endif

    if bnr == bufnr('%')
      Scratch
    endif
  endfor
  
  if a:force
    execute 'bdelete!' bnr
  else
    execute 'bdelete' bnr
  endif
endfunction
command! -bang -nargs=0 BClose :call BClose(<bang>0)
" }}}

" Send MDX to APL {{{
if executable('activepivotlive.exe')
  command! -nargs=1 -range -complete=customlist,APLInstances APLive :call APLive(<q-args>, <line1>, <line2>)

  function! APLive(instance, line1, line2)
    call system("activepivotlive.exe " . a:instance, getline(a:line1, a:line2))
  endfunction

  function! APLInstances(A,L,P)
      return ['EMEA.B', 'EMEA.A', 'America.B', 'America.A', 'ASIA.A', 'ASIA.B']
  endfunction
endif
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

" Utils: {{{
function! Execute(cmd) abort
  if exists('*execute')
    return execute(a:cmd)
  elseif exists('*capture')
    return capture(a:cmd)
  else
    let [save_verbose, save_verbosefile] = [&verbose, &verbosefile]
    set verbose=0 verbosefile=
    redir => res
    silent! execute a:cmd
    redir END
    let [&verbose, &verbosefile] = [save_verbose, save_verbosefile]
    return res
  endif
endfunction

highlight link BufferNumber Number
highlight link BufferFlags Special
highlight link BufferCurrentName Type
highlight link BufferAlternateName Function
highlight link BufferName Statement

command! -bar -bang Buffers call Buffers(<bang>0)
function! Buffers(show_all) abort
  let ls = a:show_all ? 'ls!' : 'ls'
  let buffers = split(Execute(ls), "\n")
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
    if len(bname) > 60
      echon pathshorten(bname)
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

function! Highlight(...) abort
  let lines = split(Execute('highlight'), "\n")
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
  return systemlist('rg -S --files --glob ' . a:ArgLead . '*')
endfunction

function! s:Run(command, arg, mods)
  execute a:mods a:command a:arg
endfunction

command! -nargs=1 -complete=customlist,<sid>MRUDComplete OldDirs call <sid>Run('cd', <q-args>, <q-mods>)
command! -nargs=1 -complete=customlist,<sid>MRUFComplete OldFiles call <sid>Run('edit', <q-args>, <q-mods>)
command! -nargs=1 -complete=customlist,<sid>RgFilesComplete RgFiles call <sid>Run('edit', <q-args>, <q-mods>)
nnoremap <leader>pr :OldDirs *
nnoremap <leader>fr :OldFiles *
nnoremap <leader>fR :OldFiles <C-r>=expand('%:p:.:~:h')<CR>/*<C-z>
nnoremap <leader>ff :RgFiles 
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
if exists('+guifont')
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

" Evaluate Vim code regions {{{
command! -range ExecRange execute substitute(join(getline(<line1>, <line2>), "\n"), '\n\s*\\', ' ', 'g')

autocmd vimrc FileType vim nnoremap <buffer> <leader>xe :ExecRange<CR>|
                         \ xnoremap <buffer> <leader>xe :ExecRange<CR>
"}}}

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

let g:myvimrc_visual_marks_groups = [
      \ 'GruvboxBlueSign',  'GruvboxGreenSign', 'GruvboxRedSign',
      \ 'GruvboxPurpleSign', 'GruvboxYellowSign']

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
    return confirm("Undo into previous session?", "&Yes\n&No") == 1 ? "\<C-L>u" : "\<C-L>"
  else
    return 'u'
  endif
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

function! StatusLineFilename()
  let fname = &buftype == 'nofile' ? expand('%') : expand('%:t')
  return &filetype == 'dirvish' ? s:GetDirvishName() :
       \ &filetype == 'fuzzy' ? b:fuzzy_status :
       \ &filetype == 'help' ? expand('%:t:r') :
       \ &filetype == 'peekaboo' ? '' :
       \ &filetype == 'qf' ? get(w:, 'quickfix_title', '') :
       \ &filetype == 'term' ? s:GetTermTitle()[1] :
       \ empty(fname) ? ('[no name'.':'.bufnr('').']') : fname 
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
  let maxPathLen = winwidth(0) - 50
  if strlen(path) > maxPathLen
    let path = pathshorten(path)
  endif
  return path.(exists('+shellslash') && !&shellslash ? '\' : '/')
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
  if s:is_nofile()
    return ''
  endif
  let modified = &modified ? "+": ''
  let readonly = &readonly ? "\U1F512" : '' "\ue0a2
  return modified . readonly
endfunction

function! StatusLineFugitive()
  if !exists('*fugitive#head') || &ft != 'dirvish' && s:is_nofile() || s:is_small_win()
    return ''
  endif
  try
    return fugitive#head()
  catch
  endtry
  return ''
endfunction

function! s:GetBufType()
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

function! StatusLineBufType()
  return s:GetBufType()
endfunction

function! StatusLineMode()
  if get(g:, 'statusline_use_emoji', 0)
    let m = &ft == 'dirvish' ? "\U1F4C2" :
        \ &ft == 'qf' ? (empty(getloclist(0)) ? '' : 'l')."\U1F50D" :
        \ &ft == 'grepr' ? "\U1F50D" :
        \ &ft
  else
    let m = &ft == 'dirvish' ? "dir" :
        \ &ft == 'qf' ? (empty(getloclist(0)) ? 'qf' : 'loc') :
        \ &ft
  endif
  return !empty(m) ? m : 'none'
endfunction

function! StatusLineGrep()
  return get(s:, 'grepping', 0) ? 'GREP' : ''
endfunction

function! s:get_colour(higroup, attr)
    let attr = a:attr
    if synIDattr(synIDtrans(hlID(a:higroup)), 'reverse') == 1
      let attr = attr == 'fg' ? 'bg' :
            \    attr == 'bg' ? 'fg' :
            \    attr
    endif
    let colour = synIDattr(synIDtrans(hlID(a:higroup)), attr)
    if empty(colour) && a:higroup != 'Normal'
      return s:get_colour('Normal', a:attr)
    elseif empty(colour) && attr == 'fg'
      let colour = 'fg'
    elseif empty(colour) && attr == 'bg'
      let colour = 'bg'
    elseif colour == -1
      throw "get_colour: -1 ".a:higroup.' '.a:attr
    endif
    return colour
endfunction

function! s:SetHiColour(group, fg, bg, attrs)
  let gui = has('gui_running') || &termguicolors ?
        \ 'gui='.a:attrs.' guifg='.a:fg.' guibg='.a:bg :
        \ 'gui='.a:attrs
  let cterm = a:fg[0] != '#' && a:bg[0] != '#' ?
        \ 'cterm='.a:attrs.' ctermfg='.a:fg.' ctermbg='.a:bg :
        \ 'cterm='.a:attrs
  execute 'highlight' a:group gui cterm
endfunction

function! Status(active)
  if a:active
    let sl = '%0*'
    let sl.= '%( %{StatusLineMode()} %)'
    let sl.= '%( %{StatusLinePath()}%1*%{StatusLineFilename()} %)'
    let sl.= '%<'
    let sl.= '%2*'
    let sl.= '%( %{StatusLineModified()} %)'
    let sl.= '%0*'
    let sl.= '%( %{StatusLineBufType()} %)'
    let sl.= '%( %{StatusLineArglist()} %)'
    let sl.= '%='
    let sl.= '%( %{StatusLineFileEncoding()} %)'
    let sl.= '%( %{StatusLineFileFormat()} %)'
    let sl.= '%( %{&spell ? &spelllang : ""} %)'
    let sl.= '%2*'
    let sl.= '%( %{StatusLineFugitive()} %)'
    let sl.= '%( %{gutentags#statusline()} %)'
    let sl.= '%0*'
    let sl.= '%( %4l:%-3c %3p%% %)'
    return sl
  else
    let sl = '%0*'
    let sl.= '%( %{StatusLineMode()} %)'
    let sl.= '%( %{StatusLinePath()}%{StatusLineFilename()} %)'
    let sl.= '%<'
    let sl.= '%( %{StatusLineModified()} %)'
    let sl.= '%( %{StatusLineBufType()} %)'
    return sl
  endif
endfunction

function! TabLine()
  let tabCount = tabpagenr('$')
  let tabnr = tabpagenr()
  let winnr = tabpagewinnr(tabnr)
  let cwd = getcwd(exists(':tcd') ? -1 : winnr, tabnr)
  let isLocalCwd = haslocaldir(exists(':tcd') ? -1 : winnr, tabnr)

  let s = '%#TabLine#'
  let s.= ' '.tabnr.'/'.tabCount.' '
  if isLocalCwd
    let s.= '%#TabLineSel#'
  endif
  let s.= cwd
  let s.= '%='
  let s.= '%#TabLine#'
  let s.= '%='
  let s.= '%( %{strftime("%H:%M")} %)'
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

autocmd vimrc VimEnter * nested colorscheme one
