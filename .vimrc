" vim: foldlevel=0 foldmethod=marker foldmarker={{{,}}} shiftwidth=2

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

let g:vimsyn_embed = 'l'
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
  Pack 'cocopon/iceberg.vim', {'type': 'opt'}
  Pack 'KKPMW/distilled-vim'
  Pack 'cideM/yui'
  Pack 'danishprakash/vim-yami'

  " Motions and actions
  Pack 'kana/vim-textobj-indent'
  Pack 'Julian/vim-textobj-variable-segment'
  Pack 'tpope/vim-commentary'
  Pack 'tpope/vim-unimpaired'
  Pack 'tommcdo/vim-exchange'
  Pack 'wellle/targets.vim'
  Pack 'tommcdo/vim-lion'
  Pack 'machakann/vim-sandwich'

  " Tools
  Pack 'samoshkin/vim-mergetool'
  Pack 'tpope/vim-fugitive'
  Pack 'tpope/vim-rhubarb'
  Pack 'tpope/vim-ragtag'
  Pack 'tpope/vim-scriptease'
  Pack 'justinmk/vim-dirvish'
  Pack 'chrisbra/unicode.vim'
  Pack 'romainl/vim-cool'
  Pack 'sgur/vim-editorconfig'
  Pack 'eraserhd/parinfer-rust', {'do': '!cargo build --release'}
  Pack 'Olical/conjure', {'branch': 'develop'}
  Pack 'Olical/aniseed'
  Pack 'norcalli/nvim-colorizer.lua'
  Pack 'neovim/nvim-lspconfig'
  Pack 'nvim-treesitter/nvim-treesitter'
  " Pack 'nvim-lua/completion-nvim'
  Pack 'hrsh7th/nvim-compe'
  Pack 'clojure-vim/vim-jack-in'
  Pack 'glepnir/lspsaga.nvim'

  " Filetypes
  Pack 'hail2u/vim-css3-syntax'
  Pack 'othree/html5.vim'
  Pack 'elzr/vim-json'
  Pack 'tpope/vim-jdaddy'
  Pack 'PProvost/vim-ps1'
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
  Pack 'leafOfTree/vim-svelte-plugin'
    " Pack 'ianks/vim-tsx'
    " Pack 'leafgarland/typescript-vim'
  Pack 'HerringtonDarkholme/yats.vim'
  Pack 'elmcast/elm-vim'
  Pack 'rust-lang/rust.vim'
  Pack 'wlangstroth/vim-racket'
  Pack 'beyondmarc/glsl.vim'
  Pack 'cespare/vim-toml'
  Pack 'OrangeT/vim-csharp'
  Pack 'hashivim/vim-terraform'
  Pack 'aklt/plantuml-syntax'
  Pack 'ziglang/zig.vim'
  Pack 'janet-lang/janet.vim'
  Pack 'dag/vim-fish'
  Pack 'bakpakin/fennel.vim'
endfunction

"}}}

" General: {{{

set nomodeline
set mouse=a

set belloff=all
set shortmess+=Imc
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

if has('nvim')
  set diffopt+=vertical,algorithm:histogram,indent-heuristic
endif

set wildmode=longest:full,full
set wildignorecase
if has('nvim')
  set wildoptions=tagfile,pum
endif
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

set completeopt=menu,noselect

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

command! -nargs=* Term call s:Term("<mods>", "<args>")
function! s:Term(mods, args)
  if !empty(a:mods)
    execute a:mods 'split'
  endif
  execute 'term' a:args
  call TermBufferSettings()
endfunction

function! TermBufferSettings()
  setlocal nonumber
  setlocal nocursorline
  setlocal signcolumn=no

  nnoremap <silent> <buffer> <C-p> :call SearchPreviousLine('❯')<CR>
  xnoremap <silent> <buffer> <C-p> :call SearchPreviousLine('❯')<CR>
  nnoremap <silent> <buffer> <C-n> :call SearchNextLine('❯')<CR>
  xnoremap <silent> <buffer> <C-n> :call SearchNextLine('❯')<CR>

  autocmd vimrc WinEnter,BufWinEnter <buffer> startinsert

  startinsert
endfunction

if has('nvim')
  set inccommand=split
  set fillchars+=msgsep:━
  highlight link MsgSeparator Title
  autocmd vimrc TextYankPost * silent! lua require'vim.highlight'.on_yank()
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
  set shiftwidth=2
  set shiftround
  set softtabstop=-1
endif
"}}}

" Key Mappings: {{{
let mapleader = "\<space>"
" let maplocalleader = "\\"

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

nnoremap g<C-P> :pwd<CR>

" buffer text object
onoremap <silent> B :<C-u>keepjumps normal! ggVG<CR>
xnoremap <silent> B :<C-u>keepjumps normal! ggVG<CR>

" inner line text object
onoremap <silent> il :<c-u>keepjumps lockmarks normal! g_v^<cr>
xnoremap <silent> il :<C-u>keepjumps lockmarks normal! g_v^<CR>

" disable exmode maps
nnoremap Q <nop>
nnoremap QQ :bdelete!<CR>
nmap gQ <Nop>

if has('nvim')
  let g:tshell = 'term://' . (executable('fish') ? 'fish' : executable('pwsh') ? 'pwsh' : '')
  tnoremap <C-a> <C-\><C-n>
  tnoremap <esc><esc> <C-\><C-n>
  tnoremap <M-;> <C-\><C-n>:
  tnoremap <C-w> <C-\><C-n><C-w>

  tnoremap <C-a>: <C-\><C-n>:
  tnoremap <C-a>n <C-\><C-n>:bnext<CR>
  nnoremap <C-a>n :bnext<CR>
  tnoremap <C-a>p <C-\><C-n>:bprevious<CR>
  nnoremap <C-a>p :bprevious<CR>
  tnoremap <C-a>c <C-\><C-n>:Term<CR>
  nnoremap <C-a>c :Term<CR>
  tnoremap <C-a>s <C-\><C-n>:aboveleft Term<CR>
  nnoremap <C-a>s :aboveleft Term<CR>
  tnoremap <C-a>v <C-\><C-n>:vertical Term<CR>
  nnoremap <C-a>v :vertical Term<CR>
  tnoremap <C-a><C-l> <C-l>
  tnoremap <C-a><C-a> <C-a>
  tnoremap <A-h> <C-\><C-n><C-w>h
  tnoremap <A-l> <C-\><C-n><C-w>l
  tnoremap <A-j> <C-\><C-n><C-w>j
  tnoremap <A-k> <C-\><C-n><C-w>k
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

for key in range(0, 9)
  execute 'nnoremap <C-w>'.key key.'<C-w>w'
  execute 'tnoremap <C-w>'.key '<C-\><C-n>'.key.'<C-w>w'
endfor

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

nnoremap <silent> <leader>sw :<C-U>execute v:count.'FGrep' '<c-r><c-w>'<CR>
xnoremap <silent> <leader>sw :<C-U>execute v:count.'FGrep' '<c-r><c-r>"'<CR>

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

autocmd vimrc VimEnter,FileType * call <SID>ft_load(&filetype)

function! SpellIgnoreSomeWords()
  syntax match spellIgnoreAcronyms '\<\u\(\u\|\d\)\+s\?\>' contains=@NoSpell contained containedin=@Spell
  syntax match spellIgnoreUrl '\w\+:\/\/[^[:space:]]\+' contains=@NoSpell contained containedin=@Spell
endfunction

" elixir: {{{
function! s:ft_elixir()
  call SetLspDefaults()
endfunction
" }}}

" json: {{{
function! s:ft_json()
  if executable('jq')
    setlocal equalprg=jq\ .
  else
    setlocal equalprg=python\ -m\ json.tool
  endif
  setlocal shiftwidth=2
  setlocal concealcursor=n
endfunction
" }}}

" c: {{{
function! s:ft_c()
  let g:c_no_curly_error = 1 
  setlocal shiftwidth=2
  call SetLspDefaults()
endfunction
" }}}

" rust: {{{
function! s:ft_rust()
  call SetLspDefaults()
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
  call EnableSendTerm('dotnet fsi', '', ';;')

  if executable('fantomas')
    setlocal equalprg=fantomas\ --stdin\ --stdout
  endif
  setlocal shiftwidth=4
endfunction
" }}}

" vim {{{
function! s:ft_vim()
  command! -buffer -range SendVim call SendVim('line', <line1>, <line2>)
  nnoremap <silent> <buffer> <leader>ee :SendVim<CR>
  xnoremap <silent> <buffer> <leader>e :<C-U>call SendVim(visualmode(), "'<", "'>")<CR>
  nnoremap <silent> <buffer> <leader>e :set opfunc=g:Sendvim_op<CR>g@
  function! Sendvim_op(type, ...)
   let sel_save = &selection
    let &selection = "inclusive"
    call SendVim(a:type, "'[", "']")
    let &selection = sel_save
  endfunction

  setlocal keywordprg=:help 
  setlocal omnifunc=syntaxcomplete#Complete 
  setlocal shiftwidth=2
  setlocal foldmethod=marker
  setlocal foldlevel=0
endfunction
" }}}

" help {{{
function! s:ft_help()
  nnoremap <buffer> q :wincmd c<CR>
endfunction
" }}}

" quickfix {{{
function! s:ft_qf()
  syntax match qfNoLineCol "||" conceal cchar=|

  syntax match qfFugitive "^fugitive:\/\/.\+\/\/" conceal cchar=| nextgroup=qfFugitiveHash
  syntax match qfFugitiveHash "[a-f0-9]\+" contained
  highlight! link qfFugitiveHash Directory

  setlocal conceallevel=2
  setlocal concealcursor+=n
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
autocmd vimrc BufNewFile,BufRead *.script setfiletype lua
function! s:ft_lua()
  command! -buffer -range SendLua call SendLua('line', <line1>, <line2>)
  nnoremap <silent> <buffer> <leader>ee :SendLua<CR>
  xnoremap <silent> <buffer> <leader>e :<C-U>call SendLua(visualmode(), "'<", "'>")<CR>
  nnoremap <silent> <buffer> <leader>e :set opfunc=Sendlua_op<CR>g@
  function! Sendlua_op(type, ...)
    let sel_save = &selection
    let &selection = "inclusive"
    call SendLua(a:type, "'[", "']")
    let &selection = sel_save
  endfunction

  setlocal keywordprg=:help
endfunction
"}}}

" fennel: {{{
function! s:ft_fennel()
  if exists(':ConjureEval') == 0
    call EnableSendTerm('lua fennel', '', '')
    nmap <buffer> <leader>ee <leader>eaF
  endif
  ParinferOff
  autocmd TextChanged,TextChangedI,TextChangedP <buffer> ++once ParinferOn
endfunction
"}}}

" janet: {{{
function! s:ft_janet()
  " call EnableSendTerm(get(b:, 'janet_cmd', 'janet'), " ", "\<CR>")
  " nmap <buffer> <leader>ee <leader>eaF
  setlocal suffixesadd=.janet
  setlocal includeexpr=trim(system(\"janet\ -e\ '(print\ (first\ (module/find\ \\\"\".v:fname.\"\\\")))'\"))
  setlocal equalprg=janet\ -e\ '(import\ spork/fmt)(fmt/format-print\ (:read\ stdin\ :all))'

  nnoremap <buffer> <leader>dq :ConjureEval (quit)<CR>
  nnoremap <buffer> <leader>ds :ConjureEval (.step)(.ppasm)<CR>
  nnoremap <buffer> <leader>df eConjureEval (.frame)<CR>

  let b:parinfer_comment_char = "#"
  let b:parinfer_janet_long_strings = 1
  ParinferOff
  autocmd TextChanged,TextChangedI,TextChangedP <buffer> ++once ParinferOn
endfunction
"}}}

" clojure: {{{
function! s:ft_clojure()
  if exists(':ConjureEval') == 0
    call EnableSendTerm('clj', " ", "\<CR>")
    nmap <buffer> <leader>ee <leader>eaF
  endif
  ParinferOff
  autocmd TextChanged,TextChangedI,TextChangedP <buffer> ++once ParinferOn
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
  setfiletype xxd
  set nonumber
  wincmd p
  %!xxd -c 6 -g 1
  setfiletype xxd
  set nonumber
  35wincmd |
endfunction
command! HexBin call HexBin()
" }}}

" Float with border: {{{

if has('vim_starting')
  let s:border_buf = 0
  let s:border_win = 0
endif

function! OpenWindowWithBorder(buf, options)
  let row = a:options.row - 1
  let height = a:options.height + 2
  let col = a:options.col - 1
  let width = a:options.width + 2
  let opts = {'relative': a:options.relative, 'row': row, 'col': col, 'width': width, 'height': height, 'style': 'minimal', 'focusable': v:false}

  if s:border_buf == 0
    let s:border_buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_name(s:border_buf, 'float_win_border_buf')
  endif
  let top = "╭" . repeat("─", width - 2) . "╮"
  let mid = "│" . repeat(" ", width - 2) . "│"
  let bot = "╰" . repeat("─", width - 2) . "╯"
  let lines = [top] + repeat([mid], height - 2) + [bot]
  call nvim_buf_set_lines(s:border_buf, 0, -1, v:true, lines)
  let bwin = nvim_open_win(s:border_buf, v:true, opts)
  let win = nvim_open_win(a:buf, v:true, a:options)
  execute 'autocmd vimrc WinClosed' win 'call nvim_win_close('.bwin.', 1)'
endfunction
" }}}

" Terminal Toggle: {{{

function! ResetToggleTerminal(...)
  let t:term_win = 0
  let t:term_buf = 0
endfunction

function! ToggleTerminal(height, width)
  let t:term_win = get(t:, 'term_win', 0)
  let t:term_buf = get(t:, 'term_buf', 0)
  if win_getid() == t:term_win
    call nvim_win_close(t:term_win, 1)
    let t:term_win = 0
  else
    call s:openTermFloating(a:height, a:width)
    let t:term_win = win_getid()
  endif
endfunction

function! ToggleTerminal2()
  let t:term_buf = get(t:, 'term_buf', 0)
  if bufnr() == t:term_buf
    execute 'buffer' b:previous_buffer
  elseif t:term_buf != 0
    let wnr = bufwinnr(t:term_buf)
    if wnr > 0
      execute wnr 'wincmd w'
      execute 'buffer' b:previous_buffer
      wincmd w
    endif
    let previous_buffer = bufnr()
    execute 'buffer' t:term_buf
    let b:previous_buffer = previous_buffer
    startinsert
  else
    let previous_buffer = bufnr()
    terminal
    let t:term_buf = bufnr()
    let b:previous_buffer = previous_buffer
    call TermBufferSettings()
  endif
endfunction

function! s:openTermFloating(height, width) abort
  let width = min([&columns, a:width])
  let height = min([&lines, a:height])
  let col=(&columns-width)/2
  let row=(&lines-height)/2
  let opts = {
        \ 'relative': 'editor',
        \ 'width': width,
        \ 'height': height,
        \ 'col': col,
        \ 'row': row,
        \ 'anchor': 'NW',
        \ 'style': 'minimal'
        \ }

  if t:term_buf != 0
    " switch to existing term buffer
    call OpenWindowWithBorder(t:term_buf, opts)
    startinsert
  else
    " create new term buffer
    let t:term_buf = nvim_create_buf(v:false, v:true)
    call OpenWindowWithBorder(t:term_buf, opts)
    call termopen(executable('fish') ? 'fish' : 'pwsh', {'on_exit': function('ResetToggleTerminal')})
    call TermBufferSettings()
  endif
endfunction

if has('vim_starting')
  call ResetToggleTerminal()
endif

nnoremap <silent> <C-a>t :call ToggleTerminal(&lines-8,&columns-20)<CR>
tnoremap <silent> <C-a>t <C-\><C-n>:call ToggleTerminal(&lines-8,&columns-20)<CR>
nnoremap <silent> <C-a>x :call ToggleTerminal2()<CR>
tnoremap <silent> <C-a>x <C-\><C-n>:call ToggleTerminal2()<CR>

" }}}

" Floating grep {{{
command! -count=0 -nargs=+ FGrep call FloatGrep(<count>, <f-args>)
function! FloatGrep(context, ...)
  let width = &columns-20
  let height = &lines-20
  let col=(&columns-width)/2
  let row=(&lines-height)/2
  let opts = {
        \ 'relative': 'editor',
        \ 'width': width,
        \ 'height': height,
        \ 'col': col,
        \ 'row': row,
        \ 'anchor': 'NW',
        \ 'style': 'minimal',
        \ }

  let term_buf = nvim_create_buf(v:false, v:true)
  call OpenWindowWithBorder(term_buf, opts)
  let args = ['rg', '-C'.a:context] + a:000
  call termopen(args)

  setlocal cursorline
  setlocal winhighlight=EndOfBuffer:,Normal:

  nnoremap <silent> <buffer> <C-p> :call <SID>SearchNextFile(v:true)<CR>
  nnoremap <silent> <buffer> <C-n> :call <SID>SearchNextFile(v:false)<CR>
  nnoremap <silent> <buffer> <C-k> :call <SID>SearchNextMatch(v:true)<CR>
  nnoremap <silent> <buffer> <C-j> :call <SID>SearchNextMatch(v:false)<CR>

  nnoremap <buffer> o :call <SID>OpenRipgrepFileAtCursor()<CR>
  nnoremap <buffer> <CR> :call <SID>OpenRipgrepFileAtCursor()<CR>
  nnoremap <buffer> q :bwipeout!<CR>

  normal gg
endfunction

function! s:SearchNextFile(backwards)
  let flags = a:backwards ? 'bW' : 'W'
  call search('\%1l\f\+$\|\n\n\zs\f\+$', flags)
  normal zz
endfunction

function! s:SearchNextMatch(backwards)
  let flags = a:backwards ? 'bW' : 'W'
  call search('^\d\+:', flags)
  normal zz
endfunction

function! s:OpenRipgrepFileAtCursor()
  let loc = s:GetRipgrepFileAtCursor()
  if empty(loc)
    return
  endif
  let [fname, lnum] = loc
  if !filereadable(fname)
    return
  endif
  bwipeout!
  execute 'edit' '+'.lnum fname
endfunction

function! s:GetRipgrepFileAtCursor()
  let line = getline('.')
  if line !~ '^\d\+[:-]'
    if filereadable(line)
      return [line, 1]
    endif
    return
  endif
  let linenum = matchlist(line, '^\d\+')[0]
  let fline = search('^\f\+$', 'bnW')
  if fline == 0
    return
  endif

  let fname = getline(fline)
  return [fname, linenum]
endfunction

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
  execute 'botright cwindow' (min([10, max([3, size])]))
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
command! -bang -nargs=0 BClose setlocal bufhidden=delete<bar>bnext
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
command! -complete=highlight -nargs=? Highlight :filter/<args>/ highlight
" }}}

" Recent files etc: {{{
function! s:MRUDComplete(ArgLead, CmdLine, CursorPos)
  let dirs = uniq(sort(filter(map(copy(v:oldfiles), {_,x->fnamemodify(x, ':h')}), {_,x->isdirectory(x)})))
  if empty(a:ArgLead)
    return dirs
  else
    return systemlist('fzy -e '.a:ArgLead, dirs)
  endif
endfunction

function! s:MRUFComplete(ArgLead, CmdLine, CursorPos)
  let files = uniq(sort(filter(copy(v:oldfiles), {_,x->filereadable(x)})))
  if empty(a:ArgLead)
    return files
  else
    return systemlist('fzy -e '.a:ArgLead, files)
  endif
endfunction

function! s:FdFilesComplete(ArgLead, CmdLine, CursorPos)
  if empty(a:ArgLead)
    return systemlist(['fd -tf', '--max-results', '100'])
  endif
  return systemlist('fd -tf | fzy -e ' . a:ArgLead)
endfunction

function! s:Run(command, arg, mods)
  execute a:mods a:command a:arg
endfunction

command! -nargs=1 -complete=customlist,<sid>MRUDComplete OldDirs call <sid>Run('tcd', <q-args>, <q-mods>)
command! -nargs=1 -complete=customlist,<sid>MRUFComplete OldFiles call <sid>Run('edit', <q-args>, <q-mods>)
command! -nargs=1 -complete=customlist,<sid>FdFilesComplete FdFiles call <sid>Run('edit', <q-args>, <q-mods>)
nnoremap <leader>pr :OldDirs 
nnoremap <leader>fr :OldFiles 
nnoremap <leader>fR :OldFiles <C-r>=expand('%:p:.:~:h')<CR>
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

let g:my_colour_sequence = [
  \ ['Orange', '#e2a478'],
  \ ['Blue',   '#84a0c6'],
  \ ['Green',  '#b3be82'],
  \ ['Red',    '#e27878'],
  \ ['Purple', '#a093c7'],
  \ ['Yellow', '#f9c199'],
  \ ['Aqua',   '#89b8c2']]

function! MyCustomColours()
  for [n,c] in g:my_colour_sequence
    execute 'highlight Marker'.n.'Sign guifg='.c 'guibg=#2a3158'
    execute 'highlight CustomTab'.n 'guibg='.c 'guifg=#000000'
    execute 'highlight CustomTab2'.n 'guibg='.c 'guifg=#000000 gui=bold'
    execute 'highlight CustomTab3'.n 'guibg='.c 'gui=reverse guifg='.printf("#%02x%02x%02x", float2nr(("0x".c[1:2])*0.5),float2nr(("0x".c[3:4])*0.5),float2nr(("0x".c[5:6])*0.5))
  endfor
endfunction

let g:myvimrc_visual_marks_groups = map(copy(g:my_colour_sequence), {_,x -> ('Marker'.x[0].'Sign')})

nnoremap <expr> <leader>m ToggleVisualMarker()
nnoremap <expr> m UpdateVisualMarker()

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

function! EnableSendTerm(cmd, linesep, endsep)
  let b:sendtermcmd = a:cmd
  if !empty(a:linesep)
    let b:sendtermlinesep = a:linesep
  endif
  if !empty(a:endsep)
    let b:sendtermendsep = a:endsep
  endif

  command! -buffer -range SendTerm call SendTerm('line', <line1>, <line2>)
  nnoremap <silent> <buffer> <leader>ee :SendTerm<CR>
  xnoremap <silent> <buffer> <leader>e :<C-U>call SendTerm(visualmode(), "'<", "'>")<CR>
  nnoremap <silent> <buffer> <leader>e :set opfunc=Sendterm_op<CR>g@
endfunction

function! Sendterm_op(type, ...)
  let sel_save = &selection
  let &selection = "inclusive"

  call SendTerm(a:type, "'[", "']")

  let &selection = sel_save
endfunction

function! s:get_text(mode, linesep, endsep, start, end)
  if a:mode == 'line'
    let sl = a:start
    let el = a:end
  else  
    let [_, sl, sc, _] = getpos(a:start)
    let [_, el, ec, _] = getpos(a:end)
  endif

  let lines = getline(sl, el)

  if empty(lines)
    return lines
  endif

  if a:mode ==# 'char' || a:mode ==# 'v'
    let sc = sc - 1
    let ec = ec - 1
    let lines[-1] = lines[-1][:ec]
    let lines[0] = lines[0][sc:]
  endif

  return map(lines, {_, line -> trim(line, "\r\n").a:linesep}) + [a:endsep]
endfunction 

function! SendTerm(mode, start, end)
  let cmd = get(b:, 'sendtermcmd', '')
  if empty(cmd)
    return
  endif

  let tid = get(b:, 'sendtermid', 0)
  let bid = get(b:, 'sendtermbufferid', 0)
  let lsp = get(b:, 'sendtermlinesep', '')
  let esp = get(b:, 'sendtermendsep', '')
  if !tid
    botright split new
    let tid = termopen(cmd)
    call TermBufferSettings()
    let bid = bufnr('')
    wincmd p
    let b:sendtermid = tid
    let b:sendtermbufferid = bid
  elseif bufexists(bid) && empty(win_findbuf(bid))
    execute 'botright sbuffer' bid
    wincmd p
  endif

  let text = s:get_text(a:mode, lsp, esp, a:start, a:end)
  let text += [""]

  try
    call chansend(b:sendtermid, text)
  catch
    unlet b:sendtermid
    unlet b:sendtermbufferid
    call SendTerm(a:mode, a:start, a:end)
  endtry
endfunction

function! SendVim(mode, start, end)
  let text = s:get_text(a:mode, '', '', a:start, a:end)
  execute substitute(join(text, "\n"), '\n\s*\\', ' ', 'g')
endfunction

function! SendLua(mode, start, end)
  let text = s:get_text(a:mode, '', '', a:start, a:end)
  " execute 'lua' 'assert(loadstring("'.escape(join(text, "\\n"), '"').'"))()'
  execute 'lua' join(text, "\n")
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
  return winnr()
endfunction

function! StatusLineFilename()
  let fname = &buftype == 'nofile' ? expand('%') : expand('%:t')
  return &filetype == 'dirvish' ? s:GetDirvishName() :
       \ &filetype == 'help' ? expand('%:t:r') :
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
  let modified = &modified ? "+" : ''
  let readonly = &readonly ? "" : ''
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

function! StatusLineMode()
  let m = &ft == 'dirvish' ? "dir" :
      \ &ft == 'qf' ? (empty(getloclist(0)) ? 'qf' : 'loc') :
      \ &buftype == 'terminal' ? "term" :
      \ &ft
  return !empty(m) ? m : 'none'
endfunction

function! LspStatus() abort
    let sl = ''
    if luaeval('vim.lsp.buf.server_ready()')
        let sl.='LSP'
    endif
    return sl
endfunction

function! Status(active)
  if a:active
    let sl = '%0*'
    let sl.= '%( %{StatusLineMode()} %)'
    let sl.= '%0*'
    let sl.= '%( %{StatusLinePath()}%1*%{StatusLineFilename()} %)'
    let sl.= '%<'
    let sl.= '%2*'
    let sl.= '%( %{StatusLineModified()} %)'
    let sl.= '%0*'
    let sl.= '%( %{StatusLineBufType()} %)'
    let sl.= '%( %{StatusLineArglist()} %)'
    let sl.= '%='
    let sl.= '%2*'
    let sl.= '%( %{LspStatus()} %)'
    let sl.= '%0*'
    let sl.= '%( %{StatusLineFileEncoding()} %)'
    let sl.= '%( %{StatusLineFileFormat()} %)'
    let sl.= '%( %{&spell ? &spelllang : ""} %)'
    let sl.= '%( %{StatusLineDiffMerge()} %)'
    let sl.= '%2*'
    let sl.= '%( %{StatusLineFugitive()} %)'
    let sl.= '%0*'
    let sl.= '%( %4l:%-3c %3p%% %)'
    let sl.= '%2*'
    let sl.= '%2*%( %{StatusLineWinNum()} %)'
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
  let tabnr = tabpagenr()
  let winnr = tabpagewinnr(tabnr)
  let cwd = PathShorten(getcwd(exists(':tcd') ? -1 : winnr, tabnr), &columns - 6)
  let isLocalCwd = haslocaldir(exists(':tcd') ? -1 : winnr, tabnr)
  let gitDir = cwd.'/.git'
  let gitHead =  fugitive#Head(0, gitDir)
  let prettytabnr = nr2char(0x2789 + tabnr)

  let s = '%#TabLineFill#'
  let s.= ' '.prettytabnr.' '
  let s.= '%='
  let s.= '%( '.gitHead.' %)'
  if isLocalCwd
    let s.= '%#TabLine#'
  else
    let s.= '%#TabLineSel#'
  endif
  let s.= ' '.cwd.' '
  return s
endfunction

function! s:RefreshStatus()
  for nr in range(1, winnr('$'))
    call setwinvar(nr, '&statusline', '%!Status('.(nr==winnr()).')')
  endfor
endfunction

function! PrettyLittleStatus()
  augroup PrettyLittleStatus
    autocmd!
  augroup END

  if get(g:,'prettylittlestatus_timer', 0)
    call timer_stop(g:prettylittlestatus_timer)
  endif

  set tabline=%!TabLine()

  autocmd PrettyLittleStatus SessionLoadPost,VimEnter,WinEnter,BufWinEnter,FileType,BufUnload * call <SID>RefreshStatus()
  let g:prettylittlestatus_timer = timer_start(30000, {_->execute('redrawtabline')}, {'repeat': -1})

  if !has('vim_starting')
    call s:RefreshStatus()
  endif
endfunction

call PrettyLittleStatus()
" }}}

" Plugins config: {{{

" Colorizer: {{{
lua << EOF
  require 'colorizer'.setup {
    'css';
    'html';
    'vim';
  }
EOF
" }}}

" nvim-compe: {{{

set completeopt=menuone,noselect

lua << EOF
require'compe'.setup {
  source = {
    path = true;
    buffer = true;
    calc = true;
    vsnip = false;
    nvim_lsp = true;
    nvim_lua = true;
    spell = true;
    tags = false;
    snippets_nvim = false;
    treesitter = true;
    omni = true;
  };
}
EOF

inoremap <silent><expr> <C-a> compe#complete()
inoremap <silent><expr> <CR> compe#confirm('<CR>')
inoremap <silent><expr> <C-e> compe#close('<C-e>')

" }}}

" Complete: {{{

" set completeopt=menuone,noinsert,noselect

" let g:completion_chain_complete_list = {
"     \'clojure' : [
"     \    {'mode': 'omni'},
"     \    {'complete_items': ['path']},
"     \    {'mode': '<c-p>'},
"     \    {'mode': '<c-n>'}
"     \],
"     \'vim' : [
"     \    {'mode': 'cmd'},
"     \    {'complete_items': ['path']},
"     \    {'mode': '<c-p>'},
"     \    {'mode': '<c-n>'}
"     \],
"     \'default' : [
"     \    {'complete_items': ['lsp','path']},
"     \    {'mode': '<c-p>'},
"     \    {'mode': '<c-n>'}
"     \]
"     \}
" let g:completion_enable_auto_popup = 0
" let g:completion_auto_change_source = 1

" imap <tab> <Plug>(completion_smart_tab)
" imap <s-tab> <Plug>(completion_smart_s_tab)

" autocmd BufEnter * lua require'completion'.on_attach()

" }}}

" Conjure: {{{
let g:conjure#mapping#eval_root_form = ["\<leader>ee"]
let g:conjure#mapping#eval_buf = ["<leader>eb"]
let g:conjure#mapping#eval_current_form = ["<leader>ec"]
let g:conjure#mapping#eval_file = ["<leader>ef"]
let g:conjure#mapping#eval_marked_form = ["<leader>em"]
let g:conjure#mapping#eval_motion = ["<leader>e"]
let g:conjure#mapping#eval_visual = ["<leader>e"]
let g:conjure#mapping#eval_word = ["<leader>ew"]
" }}}

" LSP: {{{

if has('vim_starting') && has('nvim')
lua << EOF
  vim.cmd('packadd nvim-lspconfig')
  vim.lsp.set_log_level('error')
  local lsp = require'lspconfig'
  lsp.rls.setup{} 
  lsp.elixirls.setup{ cmd = {'/Users/lg/Dev/erlang/elixir-ls/release/language_server.sh'} } 
  lsp.clangd.setup{ cmd = {'/usr/local/opt/llvm/bin/clangd', '--background-index'} }
EOF
endif

function! SetLspDefaults()
  " setlocal omnifunc=v:lua.vim.lsp.omnifunc
  nnoremap <buffer> <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
  nnoremap <buffer> <silent> gD    <cmd>lua vim.lsp.buf.declaration()<CR>
  nnoremap <buffer> <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
  nnoremap <buffer> <silent> gi    <cmd>lua vim.lsp.buf.implementation()<CR>
  nnoremap <buffer> <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
  nnoremap <buffer> <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
  nnoremap <buffer> <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
  nnoremap <buffer> <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
endfunction
" }}}

" Treesitter: {{{

if has('vim_starting') && has('nvim')
lua << EOF
  vim.cmd('packadd nvim-treesitter')
  require'nvim-treesitter.configs'.setup {
    incremental_selection = {
      enable = true,
    },
    highlight = {
      enable = true,
    },
    refactor = {
      highlight_definitions = { enable = true },
      highlight_current_scope = { enable = true },
    },
    navigation = {
      enable = true,
    },
  }
EOF
endif
" }}}

" Fugitive: {{{
nnoremap <leader>vc :0G<CR>
nnoremap <leader>vl :Glog -- %<CR>
xnoremap <leader>vl :Glog -- %<CR>
nnoremap <leader>vm :Glog master.. -- %<CR>
nnoremap <leader>va :Gblame<CR>
xnoremap <leader>va :Gblame<CR>
nnoremap <leader>vb :Gbrowse -<CR>
xnoremap <leader>vb :Gbrowse -<CR>

command! -nargs=* Glm :Glog master.. <args> --
command! -nargs=* Glp :Glog @{push}.. <args> --
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

" Dirvish: {{{
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
" }}}

" Unicode: {{{
nnoremap ga :UnicodeName<CR>
" }}}

" Pandoc: {{{
let g:pandoc#syntax#codeblocks#embeds#langs = [
      \ "rust",
      \ "bash=sh"]
let g:pandoc#modules#disabled = ['bibliographies']
let g:pandoc#filetypes#pandoc_markdown = 1
" }}}

" vim-sexp: {{{
let g:sexp_filetypes='clojure,scheme,lisp,timl,janet,fennel'
let g:sexp_enable_insert_mode_mappings=0
" }}}

"}}}

" Colorschemes: {{{

" Iceberg: {{{
function! ColorschemeIceberg()
  colorscheme iceberg

  highlight NormalFloat guibg=#1e2132 guifg=fg
  highlight String gui=italic
  highlight Pmenu guibg=#6b7089 guifg=#161821
  highlight StatusLine guibg=#2a3158 guifg=#cdd1e6 gui=NONE
  highlight StatusLineTerm guibg=#2a3158 guifg=#cdd1e6 gui=NONE
  highlight StatusLineNC guibg=#2a3158 guifg=#6b7089 gui=NONE
  highlight StatusLineTermNC guibg=#2a3158 guifg=#6b7089 gui=NONE
  highlight User1 guifg=#b4be82 guibg=#2a3158 gui=bold
  highlight User2 guifg=#e2a478 guibg=#2a3158 gui=bold
  highlight User3 gui=NONE guibg=#e2a478 guifg=#2a3158
  highlight VertSplit guifg=#2a3158 guibg=bg gui=NONE

  highlight link JanetFunction JanetSymbol
  highlight link JanetMacro JanetSymbol
  highlight link JanetSpecial JanetSymbol
  highlight link JanetSpecialForm JanetSymbol
  highlight link JanetError Error

  call MyCustomColours()
endfunction
"}}}

" Distilled: {{{
function! ColorschemeDistilled()
  colorscheme distilled

  highlight NormalFloat guibg=#1e2132 guifg=fg
  highlight String guifg=#ecb534
  highlight PreProc gui=bold
  highlight Statement gui=italic
  highlight EndOfBuffer guifg=#6194ba guibg=#14263b
  highlight NonText guifg=#6194ba guibg=bg
  highlight SignColumn guibg=bg
  highlight MatchParen guifg=#88c563 guibg=bg gui=bold
  highlight clear StatusLine
  highlight clear StatusLineNC
  highlight clear User1
  highlight clear User2
  highlight clear User3
  highlight StatusLine guibg=#6194ba guifg=#e4e4dd
  highlight StatusLineTerm guibg=#41749a guifg=black
  highlight StatusLineNC gui=NONE guifg=#24364b guibg=#6194ba
  highlight User1 gui=bold guibg=#6194ba guifg=gold
  highlight User2 gui=bold guibg=#5184aa guifg=gold
  highlight ErrorMsg guibg=#e76d6d guifg=black

  highlight link LspDiagnosticsError Error
  highlight link LspDiagnosticsWarning WarningMsg

  highlight link JanetFunction JanetSymbol
  highlight link JanetMacro JanetSymbol
  highlight link JanetSpecial JanetSymbol
  highlight link JanetSpecialForm JanetSymbol
  highlight link JanetError Error

  highlight link elixirDocTest SpecialComment
  highlight link elixirInterpolationDelimiter Comment
  highlight link elixirOperator SpecialComment
  highlight link elixirFunctionDeclaration Title
  highlight link elixirModuleDeclaration Title

  highlight diffRemoved guifg=#e76d6d guibg=bg gui=NONE
  highlight diffAdded guifg=#88c563 guibg=bg gui=NONE
  highlight link diffFile String

  call MyCustomColours()
endfunction
"}}}

" Yami: {{{
function! ColorschemeYami()
  colorscheme yami

  highlight NormalFloat guibg=#23242a guifg=fg
  highlight User1 gui=bold guibg=#23242a guifg=gold
  highlight User2 gui=bold guibg=#23242a guifg=#f87070
  highlight StatusLineNC gui=none guibg=#23242a guifg=#666666
  highlight TabLine gui=none guibg=#23242a guifg=#666666
  highlight TabLineSel gui=bold guibg=#23242a guifg=fg
  highlight TabLineFill gui=none guibg=#23242a guifg=#f87070
  highlight Title guifg=fg gui=bold
  highlight Constant guifg=#d6aba7
  highlight Pmenu guifg=bg guibg=fg gui=none
  highlight PmenuSel guibg=#ffe59e
  highlight PmenuSbar guibg=#666666
  highlight PmenuThumb guibg=#c4c4c5
  highlight Comment gui=italic
  highlight! link vimLineComment Comment
  highlight vimCommentTitle guifg=fg gui=bold,italic
  highlight Delimiter guifg=#c4b4e5 gui=none
  highlight String guifg=#c6ebb7
  highlight MatchParen guibg=none guifg=gold gui=bold
  highlight NormalNC guibg=#1c1920
  highlight MsgArea guibg=black
  highlight MsgSeparator guifg=gold guibg=black
  highlight IncSearch gui=reverse
  highlight Macro gui=italic
  highlight Special gui=italic
  highlight Function gui=bold

  highlight helpHyperTextJump gui=underline

  highlight link LspDiagnosticsError Error
  highlight link LspDiagnosticsWarning WarningMsg

  highlight link JanetFunction JanetSymbol
  highlight link JanetMacro JanetSymbol
  highlight link JanetSpecial JanetSymbol
  highlight link JanetSpecialForm JanetSymbol
  highlight link JanetError Error
  highlight link JanetParen Delimiter

  highlight link elixirDocTest SpecialComment
  highlight link elixirInterpolationDelimiter Comment
  highlight link elixirOperator SpecialComment
  highlight link elixirFunctionDeclaration Title
  highlight link elixirModuleDeclaration Title

  highlight link zigMultilineStringDelimiter Delimiter

  highlight link diffAdded DiffAdd
  highlight link diffRemoved DiffDelete
  highlight link diffLine Folded
  highlight link diffSubname Folded
  highlight link diffFile WarningMsg
  highlight link gitKeyword Title
  highlight link gitIdentityKeyword Title

  call MyCustomColours()
endfunction
"}}}

if has('vim_starting')
  " the colorscheme is applied after vim starts up, so my customizations are
  " lost unless we delay setting the colorscheme
  autocmd vimrc VimEnter * ++once call ColorschemeYami()
endif

"}}}
