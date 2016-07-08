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

if !has('nvim') && has('vim_starting')
    set nocompatible
    set encoding=utf-8
endif

if &shell =~# 'fish$'
  set shell=bash
endif

" Windows Compatible: {{{
let s:is_win = has('win32') || has('win64')
let s:is_gui = has('gui_running')
if s:is_win
  " On Windows, also use '.vim' instead of 'vimfiles'
  set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
  set packpath=$HOME/.vim

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
Plug 'morhetz/gruvbox/'
Plug 'NLKNguyen/papercolor-theme'
Plug 'justinmk/molokai'
Plug 'romainl/Apprentice'
Plug 'robertmeta/nofrils'
Plug 'w0ng/vim-hybrid'
Plug 'guns/xterm-color-table.vim'

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

" Tools
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-projectionist'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'Valloric/YouCompleteMe'
Plug 'justinmk/vim-dirvish'
Plug 'chrisbra/unicode.vim'
Plug 'romainl/vim-cool'

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

if executable('tmux')
  Plug 'tpope/vim-tbone'
  Plug 'wellle/tmux-complete.vim' 
  Plug 'tmux-plugins/vim-tmux-focus-events'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'tmux-plugins/vim-tmux'
  Plug 'epeli/slimux'
endif

if executable('fish')
  Plug 'dag/vim-fish', {'for': 'fish'}
endif

if has('nvim')
  Plug 'benekastah/neomake'
else
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
set mouse=a

set shortmess+=Im
set viewoptions=folds,options,cursor,unix,slash
set virtualedit=onemore,block
set history=10000
set hidden

set foldopen+=jump
set breakindent
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

if executable('ag')
  set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow\ -C0
  set grepformat=%f:%l:%c:%m
elseif executable('pt')
  set grepprg=pt\ /nogroup\ /nocolor\ /smart-case\ /follow
  set grepformat=%f:%l:%m
endif

"}}}

" Vim UI: {{{
set cmdheight=2
set showmode
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
set hlsearch
set winminheight=0
set ignorecase

set foldenable
set foldmethod=indent
set foldlevelstart=9
set foldnestmax=10

set linebreak

set nolist
set listchars=tab:├─,trail:─,extends:❭,precedes:❬,nbsp:+

set splitright
set switchbuf=useopen

set tags=./tags,~/.vimtags

" Show CursorLine in active window only
let g:myvimrc_manage_cursorline=0
if g:myvimrc_manage_cursorline
  set cursorline
  autocmd vimrc WinEnter * set cursorline
  autocmd vimrc WinLeave * set nocursorline
endif

" Opens quick fix window when there are items, close it when empty
autocmd vimrc QuickFixCmdPost [^l]* nested cwindow
autocmd vimrc QuickFixCmdPost    l* nested lwindow
"}}}

" GUI Settings: {{{
if exists('+termguicolors') && !has('gui_running') && !has('win32')
  set termguicolors
endif

if exists('+guioptions')
  set guioptions+=c
  set linespace=0
  if exists('+renderoptions')
    set renderoptions=type:directx,taamode:1,renmode:5,geom:1
  endif

  if has('vim_starting')
    set lines=50
    set columns=120
    set guifont=Source_Code_Pro:h10,Monaco:h16,Consolas:h11,Courier\ New:h14
  endif
endif
"}}}

" Formatting: {{{
set nowrap
set autoindent
set expandtab
set tabstop=8
set shiftwidth=4
set softtabstop=0
"}}}

" Key Mappings: {{{
let mapleader = "\<space>"

nnoremap <leader><leader> :
xnoremap <leader><leader> :

xnoremap / <Esc>/\%V
nnoremap <leader>sg :g//#<left><left>
xnoremap . :normal .<CR>

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
nnoremap Q :bdelete<CR>
nmap gQ <Nop>

if has('nvim')
  tnoremap <Esc><Esc> <C-\><C-n>
endif

" Transpose on words either side of cursor.
" Transpose words, preserving punctuation
nnoremap <silent> gst :s,\v(\w+)(\W*%#\W*)(\w+),\3\2\1,<bar>nohl<CR>:normal! ``<CR>
" Transpose WORDs, preserving whitespace
nnoremap <silent> gsT :s,\v(\S+)(\s*\S*%#\S*\s*)(\S+),\3\2\1,<bar>nohl<CR>:normal! ``<CR>

" Show syntax groups under cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
map <silent> <F11> :for id in synstack(line("."), col("."))<bar>
      \ echo synIDattr(id, "name").' '<bar> execute 'echohl '.synIDattr(synIDtrans(id), "name") <bar> echon synIDattr(synIDtrans(id), "name") <bar> echohl None <bar>
      \ endfor<CR>

nnoremap <leader>fs :update<CR>
nnoremap <leader>fn :vnew<CR>
nnoremap <leader>fN :enew<CR>
nnoremap <leader>fL :enew<bar><CR>:let b:ycm_largfile=1<bar>file logs<C-r>=bufnr('%')<CR><bar>setf log4net<CR>
nnoremap <leader>fo :edit **/*
nnoremap <leader>fed :edit $MYVIMRC<CR>
nnoremap <leader>fer :source $MYVIMRC<CR>

nnoremap <leader>bo :b#<CR>
nnoremap <leader>bn :bn<CR>
nnoremap <leader>bp :bp<CR>
nnoremap <leader>bb :set nomore<bar>call EchoBuffers()<bar>set more<CR>:buffer<space>
nnoremap <leader><tab> :b#<CR>
nnoremap <leader>bd :bdelete<CR>
nnoremap <leader>bD :bdelete!<CR>

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

nnoremap <leader>8 :lvimgrep <cword> % \| lopen<CR>
xnoremap <leader>8 y:<C-U>lvimgrep /<C-R>"/ % \| lopen<CR>gv

nnoremap <leader>v :v//d<CR>
nnoremap <leader>V :g//d<CR>
xnoremap <leader>v :v//d<CR>
xnoremap <leader>V :g//d<CR>

inoremap jk <esc>

inoremap (<CR> (<CR>)<Esc>O
inoremap {<CR> {<CR>}<Esc>O
inoremap {; {<CR>};<Esc>O
inoremap {, {<CR>},<Esc>O
inoremap [<CR> [<CR>]<Esc>O
inoremap [; [<CR>];<Esc>O
inoremap [, [<CR>],<Esc>O

cnoremap cd. cd %:p:h
cnoremap %% <C-R>=expand('%:h').'/'<cr>
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
autocmd vimrc FileType vim setlocal keywordprg=:help
autocmd vimrc FileType vim setlocal omnifunc=syntaxcomplete#Complete
" }}}

" help: {{{
autocmd vimrc FileType help call s:help_filetype_settings()
function! s:help_filetype_settings()
  nnoremap <buffer> q :wincmd c<CR>
endfunction
" }}}
"}}}

" Plugins config: {{{

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
    let $RUST_SRC_PATH = '/Users/leaf/Dev/rust/source/src'
  endif
  if s:has_plug('YouCompleteMe')
    let g:ycm_rust_src_path = $RUST_SRC_PATH
  endif
endif
" }}}

" Ultisnips {{{
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
" }}}

" YouCompleteMe {{{
if s:has_plug('YouCompleteMe')

  " Sometimes YCM is unhappy with the python it uses, so we can force it to
  " use a specific python
  let s:ycm_python=expand('$LOCALAPPDATA/scoop/apps/python/3.5.1/python.exe')
  if executable(s:ycm_python)
    let g:ycm_path_to_python_interpreter = s:ycm_python
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

  nnoremap <leader>mgd :YcmCompleter GoToDefinition<CR>
  nnoremap <leader>mgh :YcmCompleter GoToDeclaration<CR>
  nnoremap <leader>mht :YcmCompleter GetType<CR>
endif
" }}}

" Dirvish: {{{
if s:has_plug('vim-dirvish')
  nnoremap <leader>fj :Dirvish %:p:h<CR>
  nnoremap <leader>pe :Dirvish<CR>

  let s:dirvish_dir_search = '[\\\/]$'

  function! s:dirvish_next()
    let pos = getcurpos()
    let nextline = search(s:dirvish_dir_search)
    if nextline == pos[1]
      normal! j
      let nextline = search(s:dirvish_dir_search)
    endif
    if nextline == 0
      call setpos('.', pos)
      return
    endif
    normal! 0
  endfunction

  function! s:dirvish_previous()
    let pos = getcurpos()
    let nextline = search(s:dirvish_dir_search, 'b')
    if nextline == 0
      call setpos('.', pos)
      return
    endif
    normal! 0
  endfunction

  function! s:dirvish_settings()
    nmap <silent> <buffer> h <Plug>(dirvish_up)
    nmap <silent> <buffer> l :call dirvish#open('edit', 0)<CR>
    nmap <silent> <buffer> J :call <sid>dirvish_next()<CR>
    nmap <silent> <buffer> K :call <sid>dirvish_previous()<CR>
    nmap <silent> <buffer> gh :keeppatterns g@\v[\/]\.[^\/]+[\/]?$@d<CR>
    nnoremap <buffer> gR :grep  %<left><left>
    nnoremap <buffer> gr :<cfile><C-b>grep  <left>
    nmap <silent> <buffer> gd :sort r /[^\/]$/<CR>
    nmap <silent> <buffer> gP :cd % <bar>pwd<CR>
    nmap <silent> <buffer> gp :cd <cfile><bar>pwd<CR>
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

" Unite: {{{
if s:has_plug('unite.vim')

  let g:unite_force_overwrite_statusline = 0
  let g:neomru#do_validate = 0
  let g:unite_source_tag_max_fname_length = 70
  let g:unite_source_history_yank_enable = 1

  let s:sorter = has('ruby') ? 'sorter_selecta' : 'sorter_rank'
  call unite#custom#source('file,directory,file_rec,file_rec/async,neomru/file,tag', 'sorters', [s:sorter])
  call unite#custom#source('file,directory,file_rec,file_rec/async,neomru/file,tag', 'matchers',
  \ ['converter_relative_word', 'matcher_fuzzy'])

  call unite#custom#profile('match_project_files', 'matchers',
  \ ['converter_relative_word', 'matcher_project_files', 'matcher_fuzzy'])

  call unite#custom#profile('default', 'context', {
  \ 'direction' : 'topleft',
  \ 'prompt' : '  →  ',
  \ })

  call unite#custom#profile('source/grep', 'context', {
  \ 'buffer_name' : 'grep',
  \ 'no_quit' : 0
  \ })

  call unite#custom#profile('source/buffer', 'context', {
  \ 'buffer_name' : 'buffer',
  \ 'start_insert' : 1
  \ })

  call unite#custom#profile('source/tag', 'context', {
  \ 'buffer_name' : 'tag',
  \ 'start_insert' : 1,
  \ 'resume' : 1,
  \ 'input' : ''
  \ })

  call unite#custom#profile('source/neomru/file', 'context', {
  \ 'buffer_name' : 'mru',
  \ 'start_insert' : 1
  \ })

  call unite#custom#profile('source/neomru/directory', 'context', {
  \ 'buffer_name' : 'dirs',
  \ 'start_insert' : 1,
  \ 'default_action' : 'cd'
  \ })

  call unite#custom#profile('source/outline', 'context', {
  \ 'buffer_name' : 'outline',
  \ 'start_insert' : 1,
  \ 'auto_highlight' : 1,
  \ })

  nnoremap [unite] <Nop>
  nmap <leader>u [unite]

  nnoremap <silent> [unite]g :<C-u>UniteWithInput grep:.<CR>
  nnoremap <silent> [unite]w :<C-u>UniteWithCursorWord -no-start-insert grep:.<CR>
  nnoremap <silent> [unite]G :<C-u>UniteResume grep<CR>
  nnoremap <silent> [unite]t :<C-u>Unite -no-split -input= tag<CR>
  nnoremap <silent> [unite]y :<C-u>Unite history/yank<CR>
  nnoremap <silent> [unite]b :<C-u>Unite -no-split buffer<CR>
  nnoremap <silent> <leader>pf :<C-u>Unite -no-split -resume -buffer-name=project -no-restore -input= -start-insert -hide-source-names -unique file directory file_rec/async<CR>
  nnoremap <silent> <leader>ff :<C-u>Unite -no-split -resume -buffer-name=file -no-restore -input= -start-insert -hide-source-names -unique file file/new<CR>
  nnoremap <silent> <leader>uR :<C-u>Unite -no-split neomru/file<CR>
  nnoremap <silent> <leader>pp :<C-u>Unite -no-split neomru/directory<CR>
  nnoremap <silent> <leader>ur :<C-u>Unite -no-split -profile-name=match_project_files neomru/file<CR>

  nnoremap <silent> [unite]u :<C-u>UniteResume<CR>
  nnoremap <silent> ]u :<C-u>UniteNext<CR>
  nnoremap <silent> [u :<C-u>UnitePrevious<CR>

  nnoremap <silent> [unite]o :<C-u>Unite -split -vertical -winwidth=30 outline<CR>

  " Custom mappings for the unite buffer
  autocmd vimrc FileType unite call s:unite_settings()
  function! s:unite_settings()
    imap <buffer> <C-j>   <Plug>(unite_select_next_line)
    imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
    imap <buffer> qq      <Plug>(unite_exit)
  endfunction

  " Use pt|ag for grep
  if executable('pt')
    let g:unite_source_grep_command = 'pt'
    let g:unite_source_grep_default_opts = '--nogroup --nocolor'
    let g:unite_source_grep_recursive_opt = ''
    let g:unite_source_grep_encoding = 'utf-8'
    let g:unite_source_rec_async_command = ['pt', '--nocolor', '--nogroup', '-g', '.', '']
  elseif executable('ag')
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts = '--vimgrep'
    let g:unite_source_grep_recursive_opt = ''
    let g:unite_source_rec_async_command = ['ag', '--vimgrep', '-g', '.']
  endif

endif
"}}}

" Fugitive: {{{
if s:has_plug('vim-fugitive')
  nnoremap <silent> <leader>gs :Gstatus<CR>
  nnoremap <silent> <leader>gd :Gdiff<CR>
  nnoremap <silent> <leader>gc :Gcommit<CR>
  nnoremap <silent> <leader>gb :Gblame<CR>
  nnoremap <silent> <leader>gl :Glog<CR>
  nnoremap <silent> <leader>gp :Git pull<CR>
  nnoremap <silent> <leader>gP :Git push<CR>
endif
"}}}

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

" gruvbox: {{{
if s:has_plug('gruvbox')
  if s:is_gui
    let g:gruvbox_invert_selection=0
    let g:gruvbox_contrast_dark='medium'
    let g:gruvbox_contrast_light='hard'
  endif
  let g:gruvbox_italic=0
endif
"}}}

" nofrils: {{{
if s:has_plug('nofrils')
  let g:nofrils_strbackgrounds = 1
  autocmd vimrc ColorScheme nofrils-* :highlight! link Folded String
endif
" }}}

" Tmux Navigator: {{{
if has('nvim') && s:has_plug('vim-tmux-navigator')
  " <C-H> is seen as <BS> with some terms
  nmap <BS> :TmuxNavigateLeft<CR>
endif
" }}}

" Unicode: {{{
if s:has_plug('unicode.vim')
  nnoremap ga :UnicodeName<CR>
endif
" }}}

"}}}

" Commands & Functions: {{{

command! DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_
      \ | diffthis | wincmd p | diffthis

" Utils: {{{
function! CaptureCommand(cmd) abort
  if exists('*capture')
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

function! EchoBuffers() abort
  let buffers = split(CaptureCommand('ls'), "\n")
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
    echon bname
    let bufIdx = s:bufferIndex(bname)
    if argc() > 1 && bufIdx >= 0
      echohl BufferArgList | echon " (" bufIdx+1 ")\n"
    else
      echon "\n"
    endif
  endfor
  echohl None
endfunction

function! EchoHighlights(...) abort
  let groups = split(CaptureCommand('hi'), "\n")
  let matchGroups = []
  for group in groups
    let grpName = ''
    let grpAttrs = ''
    let grpLink = ''
    let ms = matchlist(group, '\(\S\+\)\s\+xxx\s\+\(\(\S\+=\S\+\s*\)\+\)')
    if !empty(ms)
      let [grpName, grpAttrs] = ms[1:2]
    else
      let ms = matchlist(group, '\(\S\+\)\s\+xxx\s\+links to \(\S\+\)')
      if !empty(ms)
        let [grpName, grpLink] = ms[1:2]
      else
        let ms = matchlist(group, '^\s\+links to \(\S\+\)')
        if !empty(ms)
          let grpLink = ms[1]
          let matchGroups[-1][2] = grpLink
          continue
        else
          let ms = matchlist(group, '\(\S\+\)\s\+xxx\s\+cleared')
          if !empty(ms)
            let grpName = ms[1]
          endif
        endif
      endif
    endif
    call add(matchGroups, [grpName, grpAttrs, grpLink])
  endfor

  if a:0 == 1
    call filter(matchGroups, 'match(v:val[0], a:1) >= 0')
  elseif a:0 == 2
    call filter(matchGroups, 'match(v:val[0], a:1) >= 0 && match(v:val[1], a:2) >= 0')
  elseif a:0 == 3
    if a:3 == "cleared"
      call filter(matchGroups, 'match(v:val[0], a:1) >= 0 && empty(v:val[1]) && empty(v:val[2])')
    elseif a:3 == "linked"
      call filter(matchGroups, 'match(v:val[0], a:1) >= 0 && !empty(v:val[2])')
    elseif a:3 == "set"
      call filter(matchGroups, 'match(v:val[0], a:1) >= 0 && !empty(v:val[1])')
    endif
  endif

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
      execute 'echohl ' . grpName | echon "xxx" | echohl None
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
      execute 'echohl ' . grpName | echon "xxx" | echohl None
      echon " links to " grpLink "\n"
    else
      echo grpName "xxx cleared\n"
    endif
  endfor
endfunction

command! -complete=highlight -nargs=* Highlight :call EchoHighlights(<f-args>)
" }}}

" MRU: {{{
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
  let argLead = escape(a:ArgLead, '~')
  return s:UniqPath(filter(map(copy(v:oldfiles), "fnamemodify(v:val, ':h')"), 'v:val =~ argLead && isdirectory(expand(v:val))'))
endfunction

function! s:MRUFComplete(ArgLead, CmdLine, CursorPos)
  let argLead = escape(a:ArgLead, '~')
  return filter(copy(v:oldfiles), 'v:val =~ argLead && !empty(glob(v:val))')
endfunction

function! s:MRU(command, arg)
  execute a:command . " " . a:arg
endfunction

command! -nargs=1 -complete=customlist,<sid>MRUDComplete MD call <sid>MRU('cd', <f-args>)
command! -nargs=1 -complete=customlist,<sid>MRUFComplete MF call <sid>MRU('edit', <f-args>)
nnoremap <leader>pr :MD<space>
nnoremap <leader>fr :MF <C-z>
nnoremap <leader>fR :MF <C-r>=getcwd()<CR>/.*<C-z>
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
      let &columns=999
    endif
  endfunction

  nnoremap coz :<C-U>call <sid>ChangeZoom(-1)<CR>
  nnoremap coZ :<C-U>call <sid>ChangeZoom(1)<CR>

  let s:maximised=0
  let s:restoreLines=0
  let s:restoreCols=0
  function! s:ToggleMaximise(vertical)
    if s:maximised
      let s:maximised=0
      let &lines=s:restoreLines
      let &columns=s:restoreCols
    else
      let s:maximised=1
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
function! ExecRange(line1, line2)
  execute substitute(join(getline(a:line1, a:line2), "\n"), '\n\s*\\', ' ', 'g')
  echom string(a:line2 - a:line1 + 1) . "L executed"
endfunction
command! -range ExecRange call ExecRange(<line1>, <line2>)

autocmd vimrc FileType vim nnoremap <buffer> <leader>xe :ExecRange<CR>|
                         \ xnoremap <buffer> <leader>xe :ExecRange<CR>
"}}}

" slash replacements {{{
nnoremap <silent> <leader>s/ :s,\\,/,g<CR>
nnoremap <silent> <leader>s\ :s,/,\\,g<CR>
xnoremap <silent> <leader>s/ :s,\%V\\,/,g<CR>
xnoremap <silent> <leader>s\ :s,\%V/,\\,g<CR>
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

autocmd vimrc TextChanged,TextChangedI * :call s:update_visual_markers()

let g:myvimrc_visual_marks_groups = [
      \ 'GruvboxBlueSign',  'GruvboxGreenSign', 'GruvboxRedSign',
      \ 'GruvboxPurpleSign', 'GruvboxYellowSign']

function! s:update_visual_markers()
  if !exists('b:myvimrc_visual_marks') || empty(b:myvimrc_visual_marks)
    return
  endif

  if exists('b:myvimrc_visual_marks_last_line_count') && b:myvimrc_visual_marks_last_line_count == line('$')
    return
  endif

  for [k,v] in items(b:myvimrc_visual_marks)
    let [m,l] = v
    let mark_line = line("'".k)
    if mark_line != l
      call matchdelete(m)
      if mark_line > 0
        let grp = g:myvimrc_visual_marks_groups[char2nr(k) % len(g:myvimrc_visual_marks_groups)]
        let m = matchaddpos(grp, [mark_line])
        let b:myvimrc_visual_marks[k] = [m,mark_line]
      else
        call remove(b:myvimrc_visual_marks, k)
      endif
    endif
  endfor

  let b:myvimrc_visual_marks_last_line_count = line('$')
endfunction

function! s:remove_visual_mark(match, reg)
  call matchdelete(a:match)
  call remove(b:myvimrc_visual_marks, a:reg)
  execute 'delmarks ' . a:reg
endfunction

function! ToggleVisualMarker()
  if !exists('b:myvimrc_visual_marks')
    let b:myvimrc_visual_marks = {}
  endif

  let c = getchar()
  let rc = nr2char(c)

  if rc !~ '[a-zA-Z]'
    if rc == ' '
      for [k,v] in items(b:myvimrc_visual_marks)
        let [m,l] = v
        call s:remove_visual_mark(m, k)
      endfor
    endif
    return
  endif

  let curr_line = line('.')

  let toggled_off = 0
  for [k,v] in items(b:myvimrc_visual_marks)
    let [m,l] = v
    if l == curr_line || k == rc
      call s:remove_visual_mark(m, k)
      let toggled_off = l == curr_line && k == rc
    endif
  endfor

  if toggled_off
    return
  endif

  " matchaddpos() wont add a match on blank lines
  if getline('.') == ''
    return
  endif

  let grp = g:myvimrc_visual_marks_groups[c % len(g:myvimrc_visual_marks_groups)]
  let m = matchaddpos(grp, [line('.')])
  let b:myvimrc_visual_marks[rc] = [m,curr_line]
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
    return confirm("Undo into previous session?", "&Yes\n&No", 1) == 1 ? "\<C-L>u" : "\<C-L>"
  else
    return 'u'
  endif
endfunction
" }}}

"}}}

" PrettyLittleStatus: {{{

function! s:is_basic_file()
    return &filetype !~? 'dirvish\|help\|unite\|qf'
endfunction

function! s:is_small_win()
    return winwidth(0) < 60
endfunction

function! StatusLineFilename()
  let fname = expand('%:t')
  return &filetype == 'dirvish' ? expand('%:~') :
       \ &filetype == 'unite' ? unite#view#_get_status_plane_string() :
       \ &filetype == 'help' ? expand('%:t:r') :
       \ &filetype == 'qf' ? get(w:, 'quickfix_title', '') :
       \ empty(fname) ? '[no name]' : fname 
endfunction

function! StatusLinePath()
  if !s:is_basic_file()
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
  return path.(&shellslash ? '/' : '\')
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
  if s:is_small_win() || argc() <= 1
    return ''
  endif

  let bufIdx = s:bufferIndex(expand('%'))
  if bufIdx == -1
    " buffer is not in args list
    return '('. (argidx()+1) . ' of ' . argc() . ')'
  elseif bufIdx == argidx()
    " buffer is in args list and is the current index
    return argidx()+1 . ' of ' . argc()
  else
    return '(' . (argidx()+1) . ') of ' . argc()
  endif
endfunction

function! StatusLineFileFormat()
  if !s:is_basic_file() || s:is_small_win()
    return ''
  endif
  return &binary ? 'binary' : &fileformat == substitute(&fileformats, ",.*$", "", "") ? '' : &fileformat
endfunction

function! StatusLineFileEncoding()
  if !s:is_basic_file() || s:is_small_win()
    return ''
  endif
  return &binary ? '' : &fileencoding == 'utf-8' ? '' : &fileencoding
endfunction

function! StatusLineModified()
  if !s:is_basic_file()
    return ''
  endif
  let modified = &modified ? '*' : ''
  let readonly = &readonly ? '' : ''
  return modified . readonly
endfunction

function! StatusLineFugitive()
  if !s:is_basic_file() || s:is_small_win()
    return ''
  endif
  try
    if exists('*fugitive#head')
      let mark = ''
      let head = fugitive#head()
      return strlen(head) ? mark . head : ''
    endif
  catch
  endtry
  return ''
endfunction

function! StatusLineMode()
  if winwidth(0) < 60
    return 'none'
  endif
  return &previewwindow ? "preview" :
    \ &ft == "dirvish" ? "dir" :
    \ empty(&ft) ? 'none' : &ft
endfunction

function! s:get_colour(higroup, attr)
    let attr = a:attr
    if synIDattr(synIDtrans(hlID(a:higroup)), 'reverse') == 1
      let attr = attr == 'fg' ? 'bg' :
            \    attr == 'bg' ? 'fg' :
            \    attr
    endif
    let colour = synIDattr(synIDtrans(hlID(a:higroup)), attr)
    if (empty(colour) || colour =~ '[bf]g') && a:higroup != 'Normal'
      return s:get_colour('Normal', attr)
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
  execute 'highlight '.a:group.' '.gui.' '.cterm
endfunction

function! s:SetStatusLineColours()
  try
    let wmbg = s:get_colour('WildMenu', 'bg')
    let wmfg = s:get_colour('WildMenu', 'fg')
    let ncbg = s:get_colour('StatusLineNC', 'bg')
    let bg = s:get_colour('StatusLine', 'bg')
    let fg = s:get_colour('StatusLine', 'fg')
    let nbg = s:get_colour('Normal', 'bg')

    call s:SetHiColour('StatusLine', fg, bg, 'bold')
    call s:SetHiColour('User1', fg, bg, 'NONE')
    call s:SetHiColour('User2', wmfg, wmbg, 'NONE')
    call s:SetHiColour('User3', nbg, bg, 'NONE')
    call s:SetHiColour('User4', nbg, ncbg, 'NONE')

    highlight! link TabLineFill StatusLineNC
    highlight! link TabLineSel StatusLine
    highlight! link TabLine StatusLineNC
  catch
    echomsg 'Failed to set custom StatusLine colours, reverting: '.v:exception
    highlight! link User1 StatusLine
    highlight! link User2 StatusLine
    highlight! link User3 StatusLine
    highlight! link User4 StatusLineNC
  endtry

  redrawstatus!
endfunction

function! Status(winnum)
  let active = a:winnum == winnr() || winnr('$') == 1
  let separator = '│'
  if active
    let sl = '%1*'
    let sl.= '%( %{StatusLineMode()} %)'
    let sl.= '%3*'.separator
    let sl.= '%( %1*%{StatusLinePath()}%0*%{StatusLineFilename()} %)'
    let sl.= '%( %2*%{StatusLineModified()}%0* %)'
    let sl.= '%( %1*%{StatusLineArglist()}%0* %)'
    let sl.= '%1*'
    let sl.= '%='
    let sl.= '%( %{StatusLineFileEncoding()} %)'
    let sl.= '%( %{StatusLineFileFormat()} %)'
    let sl.= '%( %{&spell ? &spelllang : ""} %)'
    let sl.= '%( %2*%{StatusLineFugitive()}%0* %)'
    let sl.= '%3*'.separator
    let sl.= '%( %1*%4l:%-3c %3p%% %)'

    return sl
  else
    let sl = '%( %{StatusLineMode()} %)'
    let sl.= '%#User4#'.separator
    let sl.= '%0*'
    let sl.= '%( %{StatusLinePath()}%{StatusLineFilename()} %)'
    let sl.= '%( %{StatusLineModified()} %)'
    return sl
  endif
endfunction

function! s:RefreshStatus()
  let winCount = winnr('$')
  for nr in range(1, winCount)
    call setwinvar(nr, '&statusline', '%!Status('. nr .')')
  endfor
endfunction

let g:prettylittlestatus_disable=0

function! PrettyLittleStatus()
  augroup PrettyLittleStatus
    autocmd!
  augroup END

  if get(g:,'prettylittlestatus_disable', 0)
    return
  endif

  autocmd PrettyLittleStatus ColorScheme * call <SID>SetStatusLineColours()
  call s:SetStatusLineColours()

  autocmd PrettyLittleStatus WinEnter,BufWinEnter * call <SID>RefreshStatus()
  call s:RefreshStatus()
endfunction

autocmd vimrc VimEnter * call PrettyLittleStatus()
" }}}

if has('vim_starting')
  colorscheme hybrid
endif
