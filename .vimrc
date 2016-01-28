" vim: foldlevel=0 foldmethod=marker shiftwidth=2

" Environment: {{{
set nocompatible
set encoding=utf8
set background=dark
if &shell =~# 'fish$'
  set shell=bash
endif

" Windows Compatible: {{{
let s:is_win = has('win32') || has('win64')
let s:is_gui = has('gui_running')
let s:is_wincon = !s:is_gui && s:is_win
if s:is_win
  " On Windows, also use '.vim' instead of 'vimfiles'
  set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
  " On windows, if gvim.exe is executed from cygwin bash shell, the shell
  " needs to be changed to the shell most plugins expect on windows.
  " This does not change &shell inside cygwin or msys vim.
  if &shell =~# 'bash$'
    set shell=$COMSPEC
  endif
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
if !s:is_wincon
  Plug 'morhetz/gruvbox/'
  Plug 'NLKNguyen/papercolor-theme'
  Plug 'itchyny/lightline.vim'
endif

" Motions and actions
Plug 'kana/vim-textobj-indent'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-abolish'
Plug 'tommcdo/vim-exchange'
Plug 'matchit.zip'
Plug 'wellle/targets.vim'
Plug 'haya14busa/incsearch.vim'

" Tools
Plug 'Soares/butane.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-projectionist'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" Unite
Plug 'Shougo/unite.vim'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/unite-outline'
Plug 'tsukkee/unite-tag'
Plug 'Shougo/vimfiler.vim'
Plug 'thinca/vim-ref'

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
Plug 'guns/vim-sexp', {'for': ['clojure', 'scheme']}
Plug 'guns/vim-clojure-highlight', {'for': 'clojure'}
Plug 'tpope/vim-sexp-mappings-for-regular-people', {'for': ['clojure', 'scheme']}
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
Plug 'ajhager/elm-vim', {'for': 'elm'}
Plug 'rust-lang/rust.vim', {'for': 'rust'}
Plug 'racer-rust/vim-racer', {'for': 'rust'}
Plug 'raichoo/purescript-vim', {'for': 'purescript'}
Plug 'wlangstroth/vim-racket', {'for': 'racket'}
Plug 'beyondmarc/glsl.vim'
Plug 'cespare/vim-toml', {'for': 'toml'}
Plug 'dleonard0/pony-vim-syntax', {'for': 'pony'}

if has('mac')
  if has('nvim')
    Plug 'benekastah/neomake'
  else
    Plug 'scrooloose/syntastic'
    Plug 'jszakmeister/vim-togglecursor'
  endif
  Plug 'tmux-plugins/vim-tmux-focus-events'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'tmux-plugins/vim-tmux'
  Plug 'epeli/slimux'
  Plug 'dag/vim-fish', {'for': 'fish'}
else
  Plug 'scrooloose/syntastic', {'for': 'fsharp'}
endif

let s:use_ycm=0
if s:use_ycm
  if s:is_win
    Plug '~/.vim/win-bundle/ycm'
  else
    Plug 'Valloric/YouCompleteMe'
  endif
else
  if has('nvim')
    Plug 'Shougo/deoplete.nvim'
  else
    Plug 'Shougo/neocomplete.vim'
  endif
  Plug 'OmniSharp/omnisharp-vim'
endif

call plug#end()

function! s:has_plug(name)
  return index(g:plugs_order, a:name) >= 0
endfunction
"}}}

" General: {{{
set mouse=a

set shortmess+=fiIlmnrxoOtT      " abbrev. of messages (avoids 'hit enter')
set viewoptions=folds,options,cursor,unix,slash " better unix / windows compatibility
set virtualedit=onemore         " allow for cursor beyond last character
set history=1000
set hidden

set backup
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//

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
set noshowmode
set noshowcmd

if has('cmdline_info')
  set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
endif

set sidescroll=1
set sidescrolloff=5
set scrolloff=5

set number
set hlsearch
set cursorline
set winminheight=0              " windows can be 0 line high
set ignorecase
set wildmode=list:longest,full  " completion, list matches, then longest common part, then all.
set whichwrap=b,s,h,l,<,>,[,]   " backspace and cursor keys wrap to

set foldenable
set foldmethod=syntax
set foldlevelstart=9
set foldnestmax=10

set linebreak

set list
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

set tags=./tags;/,~/.vimtags

augroup vimrc_ui
  autocmd!

  " Show CursorLine in active window only
  autocmd WinEnter * set cursorline
  autocmd WinLeave * set nocursorline

  " Opens quick fix window when there are items, close it when empty
  autocmd QuickFixCmdPost [^l]* nested cwindow
  autocmd QuickFixCmdPost    l* nested lwindow
augroup end

"}}}

" GUI Settings: {{{
if s:is_gui
  set cursorline
  set guioptions=gt
  set linespace=0
  set lines=50
  set columns=120
  set guifont=Source_Code_Pro:h12,Monaco:h16,Consolas:h11,Courier\ New:h14
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

if has('nvim')
  tnoremap <Esc><Esc> <C-\><C-n>
  tnoremap <C-h> <C-\><C-n><C-w>h
  tnoremap <C-j> <C-\><C-n><C-w>j
  tnoremap <C-k> <C-\><C-n><C-w>k
  tnoremap <C-l> <C-\><C-n><C-w>l
endif

" Show syntax groups under cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" the button is sooo big, i must hit it lots
let mapleader = "\<space>"
nmap <leader><leader> :
vmap <leader><leader> :

nnoremap <leader>fs :w<CR>

" switch to alternate buffer
nnoremap <leader><tab> :b#<CR>

" Easier moving in tabs and windows
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h
" windows cmds under <leader>w
nnoremap <leader>w <C-w>
nnoremap <leader>ww <C-w>p
" close all preview windows and quickfix|location lists
nnoremap <silent> <C-w>z :wincmd z<Bar>cclose<Bar>lclose<CR>
" Create a split on the given side.
nnoremap <leader>wsh   :leftabove  vsp<CR>
nnoremap <leader>wsl :rightbelow vsp<CR>
nnoremap <leader>wsk     :leftabove  sp<CR>
nnoremap <leader>wsj   :rightbelow sp<CR>

" Wrapped lines goes down/up to next row, rather than next line in file.
nnoremap j gj
nnoremap k gk

" get out of insert quickly
inoremap jk <esc>

" split line
nnoremap <leader>j i<CR><Esc>

" folding options
nnoremap <leader>z za
nnoremap <leader>eF :<C-U>let &foldlevel=v:count<CR>

"clearing highlighted search
nnoremap <silent> <leader>/ :nohlsearch<CR>

" Change Working Directory to that of the current file
cnoremap cd. lcd %:p:h
cnoremap %% <C-R>=expand('%:h').'/'<cr>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

noremap <leader>ew :e <C-R>=expand('%:h').'/'<cr>

" Easier horizontal scrolling
noremap zl 20zl
noremap zh 20zh

noremap <leader>fed :e $MYVIMRC<CR>

" copy/paste from system
nnoremap <C-y> "*y
vnoremap <C-y> "*y
if s:is_gui
  nnoremap <C-p> "*]p
  nnoremap <C-P> "*]P
  vnoremap <C-p> "*]p
  vnoremap <C-P> "*]P
else
  nnoremap <C-p> :set paste<CR>"*]p:set nopaste<CR>
  nnoremap <C-P> :set paste<CR>"*]P:set nopaste<CR>
  vnoremap <C-p> :<C-U>set paste<CR>"*]p:set nopaste<CR>
  vnoremap <C-P> :<C-U>set paste<CR>"*]P:set nopaste<CR>
endif

" move to end of copy/paste
vnoremap y y`]
vnoremap p p`]
nnoremap p p`]

" duplicate visual selection
vnoremap D y'>p

nnoremap <leader>bo :b#<CR>
nnoremap <leader>bn :bn<CR>
nnoremap <leader>bp :bp<CR>

" select whole buffer
nnoremap vaa ggvGg_
nnoremap Vaa ggVG
" select current line, no whitespace
nnoremap vv ^vg_
" select last changed/yanked
nnoremap gV `[v`]

" <alt-j> <alt-k> move line
nnoremap <M-j> :m+<CR>
nnoremap <M-k> :m-2<CR>
inoremap <M-j> <Esc>:m+<CR>
inoremap <M-k> <Esc>:m-2<CR>
vnoremap <M-j> :m'>+<<CR>gv
vnoremap <M-k> :m-2<CR>gv

" Move to start/end of text in line
nnoremap H ^
nnoremap L $
vnoremap H ^
vnoremap L g_

" move to last change
nnoremap gI `.

" search for word under cursor in current file using vimgrep
nnoremap <leader>8 :lvimgrep <cword> % \| lopen<CR>
vnoremap <leader>8 y:<C-U>lvimgrep /<C-R>"/ % \| lopen<CR>gv

" delete all non-matching/matching lines using last used search
nnoremap <leader>v :v//d<CR>
nnoremap <leader>V :g//d<CR>

" same as above but only within selected lines
vnoremap <leader>v :v//d<CR>
vnoremap <leader>V :g//d<CR>

"}}}

" Filetypes: {{{
augroup vimrc_filetypes
  autocmd!

  " log: {{{
  autocmd BufNewFile,BufRead *.log setfiletype log4net
  autocmd BufNewFile,BufRead *.log.? setfiletype log4net
  " }}}

  " json: {{{
  autocmd FileType json setlocal equalprg=python\ -m\ json.tool
  autocmd FileType json setlocal shiftwidth=2
  " }}}

  " xml: {{{
  let g:xml_syntax_folding=1
  autocmd BufNewFile,BufRead *.config setfiletype xml
  autocmd BufNewFile,BufRead *.*proj setfiletype xml
  autocmd BufNewFile,BufRead *.xaml setfiletype xml

  autocmd FileType xml call s:xml_filetype_settings()
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
    autocmd FileType fsharp setlocal equalprg=fantomas\ --stdin\ --stdout
  endif
  autocmd FileType fsharp setlocal shiftwidth=2
  " }}}

  " help: {{{
  autocmd FileType help call s:help_filetype_settings()
  function! s:help_filetype_settings()
    nnoremap <buffer> q :wincmd c<CR>
  endfunction
  " }}}

augroup end
"}}}

" Plugins config: {{{

" Targets: {{{
  " add curly braces
  let g:targets_argOpening = '[({[]'
  let g:targets_argClosing = '[]})]'
  " args separated by , and ;
  let g:targets_argSeparator = '[,;]'
" }}}

" Omnisharp: {{{
if s:has_plug('omnisharp-vim')
  " let g:OmniSharp_server_type = 'roslyn'
  if s:has_plug('neocomplete-vim')
    augroup vimrc_omnisharp_neocomplete
      autocmd!
      autocmd FileType cs call s:omnisharp_neocomplete_cs()
    augroup END
    function! s:omnisharp_neocomplete_cs()
      let g:neocomplete#sources#omni#input_patterns.cs = '.*[^=\);]'
      let g:neocomplete#sources.cs = ['omni']
      setlocal omnifunc=OmniSharp#Complete
    endfunction
  endif
endif
" }}}

" FSharp: {{{
if s:has_plug('vim-fsharp')
  let g:fsharpbinding_debug=1
  augroup vimrc_fsharpbinding_settings
    autocmd!
    autocmd FileType fsharp call s:fsharpbinding_settings()
  augroup END
  function! s:fsharpbinding_settings()
    setlocal include=^#load\ 
    setlocal complete+=i

    if s:has_plug('neocomplete.vim')
    endif

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
endif
" }}}

" deoplete {{{
if s:has_plug('deoplete.nvim')
  let g:deoplete#enable_at_startup = 1
  let g:deoplete#enable_smart_case = 1
  let g:deoplete#sources = {}
  let g:deoplete#sources._ = ['buffer', 'file']
endif
" }}}

" Ultisnips {{{
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
" }}}

" YouCompleteMe {{{
if s:has_plug('YouCompleteMe')
  let g:ycm_semantic_triggers =  {
    \   'c' : ['->', '.'],
    \   'objc' : ['->', '.'],
    \   'ocaml' : ['.', '#'],
    \   'cpp,objcpp' : ['->', '.', '::'],
    \   'perl' : ['->'],
    \   'php' : ['->', '::'],
    \   'cs,java,javascript,d,vim,python,perl6,scala,vb,elixir,go' : ['.'],
    \   'ruby,rust' : ['.', '::'],
    \   'lua' : ['.', ':'],
    \   'erlang' : [':'],
    \   'fsharp' : ['.'],
    \ }
  nnoremap <leader>mgd :YcmCompleter GoToDefinition<CR>
  nnoremap <leader>mgh :YcmCompleter GoToDeclaration<CR>
  nnoremap <leader>mht :YcmCompleter GetType<CR>
endif
" }}}

" Neocomplete: {{{
if s:has_plug('neocomplete.vim')
  let g:neocomplete#enable_at_startup = 1

  " For smart TAB completion.
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" :
         \ <SID>check_back_space() ? "\<TAB>" :
         \ neocomplete#start_manual_complete()
  function! s:check_back_space()
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
  endfunction

  imap <C-k>  <Plug>(neocomplete_start_unite_complete)
endif
" }}}

" IncSearch: {{{
if s:has_plug('incsearch.vim')
  " let g:incsearch#magic = '\v' " very magic
  let g:incsearch#do_not_save_error_message_history = 1
  let g:incsearch#auto_nohlsearch = 1
  map n  <Plug>(incsearch-nohl-n)
  map N  <Plug>(incsearch-nohl-N)
  map *  <Plug>(incsearch-nohl-*)
  map #  <Plug>(incsearch-nohl-#)
  map g* <Plug>(incsearch-nohl-g*)
  map g# <Plug>(incsearch-nohl-g#)
  map /  <Plug>(incsearch-forward)
  map ?  <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)
endif
" }}}

" VimFiler: {{{
if s:has_plug('vimfiler.vim')
  let g:vimfiler_as_default_explorer = 1
  nnoremap <leader>fj :VimFilerBufferDir -find -safe<CR>
endif
" }}}

" Syntastic: {{{
if s:has_plug('syntastic')
  let g:syntastic_stl_format = '[Syntax: %E{line:%fe }%W{#W:%w}%B{ }%E{#E:%e}]'
endif
" }}}

" Unite: {{{
if s:has_plug('unite.vim')

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
  nnoremap <silent> <leader>bb :<C-u>Unite -no-split buffer<CR>
  nnoremap <silent> <leader>pf :<C-u>Unite -no-split -resume -buffer-name=project -no-restore -input= -start-insert -hide-source-names -unique file directory file_rec/async<CR>
  nnoremap <silent> <leader>ff :<C-u>Unite -no-split -resume -buffer-name=file -no-restore -input= -start-insert -hide-source-names -unique file file/new<CR>
  nnoremap <silent> <leader>fR :<C-u>Unite -no-split neomru/file<CR>
  nnoremap <silent> <leader>pp :<C-u>Unite -no-split neomru/directory<CR>
  nnoremap <silent> <leader>fr :<C-u>Unite -no-split -profile-name=match_project_files neomru/file<CR>

  nnoremap <silent> [unite]u :<C-u>UniteResume<CR>
  nnoremap <silent> ]u :<C-u>UniteNext<CR>
  nnoremap <silent> [u :<C-u>UnitePrevious<CR>

  nnoremap <silent> [unite]o :<C-u>Unite -split -vertical -winwidth=30 outline<CR>

  " Custom mappings for the unite buffer
  autocmd FileType unite call s:unite_settings()
  function! s:unite_settings()
    imap <buffer> <C-j>   <Plug>(unite_select_next_line)
    imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
    imap <buffer> qq      <Plug>(unite_exit)

    if s:has_plug('vim-airline')
      function! airline#extensions#unite#apply(...)
        if &ft == 'unite'
          call a:1.add_section('airline_a', ' Unite ')
          call a:1.add_section('airline_b', ' %{get(unite#get_context(), "buffer_name", "")} ')
          call a:1.add_section('airline_c', ' ')
          return 1
        endif
      endfunction
    endif
  endfunction

  " Use ag for search
  if executable('ag')
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts = '--vimgrep'
    let g:unite_source_grep_recursive_opt = ''
    let g:unite_source_rec_async_command = ['ag', '--vimgrep', '-g .']
  elseif executable('pt')
    let g:unite_source_grep_command = 'pt'
    let g:unite_source_grep_default_opts = '/nogroup /nocolor /smart-case /follow /C0'
    let g:unite_source_grep_recursive_opt = ''
    let g:unite_source_rec_async_command = ['pt', '/nocolor', '/nogroup', '-g .']
  endif

endif
"}}}

" Butane: {{{
if s:has_plug('butane.vim')
  noremap <leader>bd :Bclose<CR>
  noremap <leader>bD :Bclose!<CR>
  noremap <leader>br :Breset<CR>
  noremap <leader>bR :Breset!<CR>
endif
"}}}

" Lightline: {{{
if (s:has_plug('lightline.vim'))
  let g:lightline = {
    \ 'colorscheme': 'mygruvbox',
    \ 'active': {
    \   'left': [ [ 'mode' ], [ 'filename' ], [ 'modified' ] ],
    \   'right': [ [ 'lineinfo' ], [ 'fugitive' ] ]
    \ },
    \ 'inactive': {
    \   'left': [ [ 'mode' ], [ 'filename' ], [ 'modified' ] ],
    \   'right': [ [ 'lineinfo' ], [ 'fugitive' ] ]
    \ },
    \ 'component_function': {
    \   'fugitive': 'LightLineFugitive',
    \   'filename': 'LightLineFilename',
    \   'mode': 'LightLineMode',
    \   'modified': 'LightLineModified',
    \ },
    \ 'component': {
    \   'lineinfo': '%4l:%-3c %3p%%'
    \ },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '', 'right': '' },
    \ 'mode_map': {
    \   'n': 'N ', 'i': 'I ', 'R': 'R ', 'v': 'V ',
    \   'V': 'VL', 'c': 'C ', "\<C-v>": 'VB', 's': 'S ',
    \   'S': 'SL', "\<C-s>": 'SB', 't': 'T ', '?': '  '
    \ }
    \ }

  function! s:is_basic_file()
      return &filetype !~? 'help\|vimfiler\|unite\|qf'
  endfunction

  function! LightLineFilename()
    let fname = expand('%:~:.')
    return &filetype == 'vimfiler' ? vimfiler#get_status_string() :
         \ &filetype == 'unite' ? unite#get_status_string() :
         \ &filetype == 'help' ? expand('%:t:r') :
         \ &filetype == 'qf' ? get(w:, 'quickfix_title', '') :
         \ strlen(fname) ? fname : '[no name]'
  endfunction

  function! LightLineModified()
    if !s:is_basic_file()
      return ''
    endif
    let modified = &modified ? '+' : ''
    let readonly = &readonly ? '' : ''
    return modified . readonly
  endfunction

  function! LightLineFugitive()
    try
      if s:is_basic_file() && exists('*fugitive#head')
        let mark = ''
        let head = fugitive#head()
        return strlen(head) ? mark . head : ''
      endif
    catch
    endtry
    return ''
  endfunction

  function! LightLineMode()
    return &ft == 'help' ? 'Help' :
         \ &ft == 'unite' ? 'Unite' :
         \ &ft == 'vimfiler' ? 'VimFiler' :
         \ &ft == 'qf' ? (get(w:, 'quickfix_title', '') =~? ':[lL]' ? 'LocList' : 'QuickFix') :
         \ winwidth(0) > 60 ? lightline#mode() : ''
  endfunction

  let g:unite_force_overwrite_statusline = 0
  let g:vimfiler_force_overwrite_statusline = 0
endif
" }}}

" Fugitive: {{{
if s:has_plug('vim-fugitive')
  nnoremap <silent> <leader>gs :Gstatus<CR>
  nnoremap <silent> <leader>gd :Gdiff<CR>
  nnoremap <silent> <leader>gc :Gcommit<CR>
  nnoremap <silent> <leader>gb :Gblame<CR>
  nnoremap <silent> <leader>gl :Glog<CR>
  nnoremap <silent> <leader>gp :Git push<CR>
endif
"}}}

"{{{ Slimux
if s:has_plug('slimux')
  augroup slimux-settings
    autocmd!
    autocmd FileType scheme call s:slimux_scheme_settings()
    autocmd FileType fsharp call s:slimux_fsharp_settings()
  augroup END
  function! s:slimux_scheme_settings()
    nnoremap <buffer> <silent> <leader>l :SlimuxSchemeEvalBuffer<CR>
    nnoremap <buffer> <silent> <leader>i :SlimuxSchemeEvalDefun<CR>
    vnoremap <buffer> <silent> <leader>i :SlimuxREPLSendSelection<CR>
  endfunction
  function! s:slimux_fsharp_settings()
    nnoremap <buffer> <silent> <leader>l :SlimuxREPLSendBuffer<CR>
    nnoremap <buffer> <silent> <leader>i :SlimuxREPLSendLine<CR>
    vnoremap <buffer> <silent> <leader>i :SlimuxREPLSendSelection<CR>
  endfunction
  " Add ;; to the end of the fsharp sent text
  function! SlimuxPost_fsharp(target_pane)
    call system('tmux send-keys -t ' . a:target_pane . ' \\\; \\\; C-m')
  endfunction
  let g:slimux_scheme_keybindings=1
endif
"}}}

" PaperColor: {{{
if s:has_plug('papercolor-theme')
  let g:PaperColor_Dark_Override={'cursorline' : 'NONE'}
  let g:PaperColor_Light_Override={'cursorline' : 'NONE'}
  colorscheme PaperColor
endif
" }}}

" gruvbox: {{{
if s:has_plug('gruvbox')
  if s:is_gui
    let g:gruvbox_invert_selection=0
    let g:gruvbox_contrast_dark='medium'
    let g:gruvbox_contrast_light='hard'
  endif
  let g:gruvbox_italic=0
  let g:airline_theme='gruvbox'
  colorscheme gruvbox
  highlight CursorLine guibg=NONE
  highlight CursorLineNr guibg=NONE

  " Lightline gruvbox colorscheme: {{{
  if exists('g:lightline')
    function! s:getGruvColor(group)
      let guiColor = synIDattr(hlID(a:group), "fg", "gui") 
      let termColor = synIDattr(hlID(a:group), "fg", "cterm") 
      return [ guiColor, termColor ]
    endfunction

    let s:bg0  = s:getGruvColor('GruvboxBg0')
    let s:bg1  = s:getGruvColor('GruvboxBg1')
    let s:bg2  = s:getGruvColor('GruvboxBg2')
    let s:bg3  = s:getGruvColor('GruvboxBg3')
    let s:bg4  = s:getGruvColor('GruvboxBg4')
    let s:bg4  = s:getGruvColor('GruvboxGray')
    let s:fg0  = s:getGruvColor('GruvboxFg0')
    let s:fg1  = s:getGruvColor('GruvboxFg1')
    let s:fg2  = s:getGruvColor('GruvboxFg2')
    let s:fg3  = s:getGruvColor('GruvboxFg3')
    let s:fg4  = s:getGruvColor('GruvboxFg4')

    let s:aqua   = s:getGruvColor('GruvboxAqua')
    let s:blue   = s:getGruvColor('GruvboxBlue')
    let s:green = s:getGruvColor('GruvboxGreen')
    let s:orange = s:getGruvColor('GruvboxOrange')
    let s:purple = s:getGruvColor('GruvboxPurple')
    let s:red = s:getGruvColor('GruvboxRed')
    let s:yellow = s:getGruvColor('GruvboxYellow')

    let s:p = {'normal':{}, 'inactive':{}, 'insert':{}, 'replace':{}, 'visual':{}, 'tabline':{}}

    let s:p.normal.left = [ [ s:blue, s:bg2], [ s:fg0, s:bg3], [ s:orange, s:bg3 ] ]
    let s:p.normal.right = [ [ s:green, s:bg3], [ s:yellow , s:bg3] ]
    let s:p.normal.middle = [ [ s:fg3, s:bg3] ]

    let s:p.inactive.left = [ [ s:bg4, s:bg2], [ s:bg4 , s:bg2], [ s:bg4, s:bg2 ] ]
    let s:p.inactive.right = [ [ s:bg4, s:bg2], [ s:bg4 , s:bg2] ]
    let s:p.inactive.middle = [ [ s:bg4, s:bg2] ]

    let s:p.insert = deepcopy(s:p.normal)
    let s:p.insert.left[0] = [ s:yellow, s:bg2 ]
    let s:p.visual = deepcopy(s:p.normal)
    let s:p.visual.left[0] = [ s:green, s:bg2 ]

    let s:p.tabline.left = [ [ s:fg4, s:bg2 ] ]
    let s:p.tabline.tabsel = [ [ s:bg0, s:yellow ] ]
    let s:p.tabline.middle = [ [ s:bg0, s:bg0 ] ]
    let s:p.tabline.right = [ [ s:bg0, s:orange ] ]

    let s:p.normal.error = [ [ s:bg0, s:orange ] ]
    let s:p.normal.warning = [ [ s:bg2, s:yellow ] ]

    let g:lightline#colorscheme#mygruvbox#palette = lightline#colorscheme#flatten(s:p)
  endif
  "}}}
endif
"}}}

" seoul: {{{
if s:has_plug('seoul256.vim')
  " darker background (233-239)
  let g:seoul256_background = 234
endif
"}}}

"}}}

" Functions: {{{

" vp doesn't replace paste buffer {{{
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction

function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction

vmap <silent> <expr> p <sid>Repl()
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
if s:is_gui
  let s:zoom_level=split(split(&gfn, ',')[0], ':')[1][1:]
  function! s:ChangeZoom(zoomInc)
    let s:zoom_level = min([max([4, (s:zoom_level + a:zoomInc)]), 28])
    let &gfn=substitute(&gfn, ':h\d\+', ':h' . s:zoom_level, '')
    if s:maximised
      let &lines=999
      let &columns=999
    endif
  endfunction

  nnoremap coz :<C-U>call <sid>ChangeZoom(-2)<CR>
  nnoremap coZ :<C-U>call <sid>ChangeZoom(2)<CR>

  let s:maximised=0
  let s:restoreLines=0
  let s:restoreCols=0
  function! s:ToggleMaximise()
    if s:maximised
      let s:maximised=0
      let &lines=s:restoreLines
      let &columns=s:restoreCols
    else
      let s:maximised=1
      let s:restoreLines=&lines
      let s:restoreCols=&columns
      let &lines=999
      let &columns=999
    endif
  endfunction

  nnoremap com :<C-U>call <sid>ToggleMaximise()<CR>
endif
" }}}

" Evaluate Vim code regions {{{
" taken from kana/VimScratch
function! VimEvaluate_linewise(line1, line2, adjust_cursorp)
  let bufnr = bufnr('')
  call VimEvaluate([bufnr, a:line1, 1, 0],
        \                  [bufnr, a:line2, len(getline(a:line2)), 0],
        \                  a:adjust_cursorp)
endfunction

function! VimEvaluate(range_head, range_tail, adjust_cursorp)
  " Yank the script.
  let original_pos = getpos('.')
  let original_reg_a = @a
  call setpos('.', a:range_head)
  normal! v
  call setpos('.', a:range_tail)
  silent normal! "ay
  let script = @a
  let @a = original_reg_a

  " Evaluate it.
  execute substitute(script, '\n\s*\\', '', 'g')

  if a:adjust_cursorp
    " Move to the next line of the script (add new line if necessary).
    call setpos('.', a:range_tail)
    if line('.') == line('$')
      put =''
    else
      normal! +
    endif
  else
    call setpos('.', original_pos)
  endif
endfunction

command! -bang -bar -nargs=0 -range VimEvaluate
      \ call VimEvaluate_linewise(<line1>, <line2>, '<bang>' != '!')

augroup vimrc_vim_evaluate
  autocmd!
  autocmd FileType vim nnoremap <buffer> <leader>xe :VimEvaluate<CR> |
        \ vnoremap <buffer> <leader>xe :VimEvaluate<CR>
augroup end
"}}}

" slash replacements {{{
command! -range SlashForwards :<line1>,<line2>s/\\/\//g
command! -range SlashBackwards :<line1>,<line2>s/\//\\/g
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

"}}}

" Windows console vim {{{
if s:is_wincon
  " tidy up the colors when running in Windows console.
  colorscheme default
  highlight Comment ctermfg=8
  highlight Folded ctermfg=0 ctermbg=8
  highlight CursorLine ctermbg=NONE cterm=NONE
  highlight LineNr ctermfg=7
  highlight CursorLineNr ctermfg=14
  highlight MatchParen ctermbg=NONE ctermfg=NONE cterm=reverse
  highlight Pmenu ctermbg=7 ctermfg=0
  highlight PmenuSel ctermbg=8 ctermfg=15
endif
" }}}
