" vim: foldlevel=0 foldmethod=marker shiftwidth=2 :

" Environment {{{

" Basics {{{
if &shell =~# 'fish$'
  set shell=zsh
endif
set nocompatible
set background=dark
"}}}

" Windows Compatible {{{
let s:is_win = has('win32') || has('win64')
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

" Plugins {{{
call plug#begin('~/.vim/bundle')

" Base
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-repeat'
Plug 'kana/vim-textobj-user'
Plug 'Shougo/vimproc'

" Colour schemes and pretty things
Plug 'chriskempson/base16-vim'
Plug 'bling/vim-airline'
Plug 'morhetz/gruvbox/'
Plug 'junegunn/seoul256.vim'

" Motions and actions
Plug 'kana/vim-textobj-indent'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-abolish'
Plug 'tommcdo/vim-exchange'
Plug 'matchit.zip'
Plug 'wellle/targets.vim'
Plug 'haya14busa/incsearch.vim'

" Tools
Plug 'Shougo/unite.vim'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/vimfiler.vim'
Plug 'Soares/butane.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-projectionist'

" Filetypes
Plug 'ChrisYip/Better-CSS-Syntax-for-Vim', {'for': 'css'}
Plug 'leshill/vim-json', {'for': 'json'}
Plug 'tpope/vim-jdaddy', {'for': 'json'}
Plug 'vim-pandoc/vim-pandoc-syntax', {'for': 'pandoc'}
Plug 'vim-pandoc/vim-pandoc', {'for': 'pandoc'}
Plug 'PProvost/vim-ps1', {'for': 'ps1'}
Plug 'fsharp/fsharpbinding', {'for': 'fsharp', 'rtp': 'vim'}
Plug 'tpope/vim-fireplace', {'for': 'clojure'}
Plug 'guns/vim-clojure-static', {'for': 'clojure'}
Plug 'guns/vim-sexp', {'for': 'clojure'}
Plug 'guns/vim-clojure-highlight', {'for': 'clojure'}
Plug 'tpope/vim-sexp-mappings-for-regular-people', {'for': 'clojure'}
Plug 'jimenezrick/vimerl', {'for': 'erlang'}
Plug 'edkolev/erlang-motions.vim', {'for': 'erlang'}
Plug 'elixir-lang/vim-elixir', {'for': 'elixir'}
Plug 'pangloss/vim-javascript', {'for': 'javascript'}
Plug 'mxw/vim-jsx', {'for': 'javascript'}
Plug 'leafgarland/typescript-vim', {'for': 'typescript'}
Plug 'jb55/Vim-Roy', {'for': 'roy'}
Plug 'Blackrush/vim-gocode', {'for': 'go'}
Plug 'findango/vim-mdx', {'for': 'mdx'}
Plug 'lambdatoast/elm.vim', {'for': 'elm'}

if has('mac')
  Plug 'jszakmeister/vim-togglecursor'
  Plug 'sophacles/vim-processing'
  Plug 'epeli/slimux'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'wlangstroth/vim-racket', {'for': 'racket'}
  Plug 'dag/vim-fish', {'for': 'fish'}
endif

let s:use_ycm=0
if s:use_ycm
  if s:is_win
    Plug '~/.vim/win-bundle/ycm'
  else
    Plug 'Valloric/YouCompleteMe'
  endif
else
  Plug 'ajh17/VimCompletesMe'
  " Plug 'Shougo/neocomplete.vim'
  Plug 'OmniSharp/omnisharp-vim'
endif

call plug#end()

function! s:has_plug(name)
  return index(g:plugs_order, a:name) >= 0
endfunction
"}}}

" General {{{
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

set cryptmethod=blowfish
" disables swaps, backups and history etc for encrypted files
autocmd BufReadPost * if &key != "" | setl noswapfile nowritebackup viminfo= nobackup noshelltemp secure | endif

let g:netrw_menu = 0
"}}}

" Vim UI {{{
set showmode

if has('cmdline_info')
  set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " a ruler on steroids
endif

set sidescroll=1
set sidescrolloff=5
set scrolloff=5

set linespace=0
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

set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

set tags=./tags;/,~/.vimtags

" Opens quick fix window when there are items, close it when empty
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow
"}}}

" GUI Settings {{{
if has('gui_running')
  set cursorline
  set guioptions=egt
  set lines=50
  set columns=120
  set guifont=Source_Code_Pro:h12,Monaco:h16,Consolas:h11,Courier\ New:h14
else
  let t_Co=256
  let base16colorspace=256
endif
"}}}

" Formatting {{{
set nowrap
set autoindent
set shiftwidth=4                " use indents of 4 spaces
set expandtab                   " tabs are spaces, not tabs
set tabstop=4                   " an indentation every four columns
set softtabstop=4               " let backspace delete indent
"}}}

" Key Mappings {{{

" Show syntax groups under cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" the button is sooo big, i must hit it lots
let mapleader = "\<space>"
nmap <leader><leader> :
vmap <leader><leader> :

nnoremap <leader>w :w<CR>

" Easier moving in tabs and windows
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h

" Wrapped lines goes down/up to next row, rather than next line in file.
nnoremap j gj
nnoremap k gk

" get out of insert quickly
inoremap jk <esc>

" split line
nnoremap <leader>j i<CR><Esc>

" folding options
nnoremap <leader>ff za
nnoremap <leader>F :<C-U>let &foldlevel=v:count<CR>

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

" close all preview windows and quickfix|location lists
nnoremap <silent> <C-W>z :wincmd z<Bar>cclose<Bar>lclose<CR>

" Easier horizontal scrolling
noremap zl 20zl
noremap zh 20zh

noremap <leader>ee :e $MYVIMRC<CR>

nnoremap <leader>y "*y
nnoremap <leader>p :set paste<CR>"*]p:set nopaste<CR>
nnoremap <leader>P :set paste<CR>"*]P:set nopaste<CR>
vnoremap <leader>y "*ygv

vnoremap y y`]
vnoremap p p`]
nnoremap p p`]

" duplicate visual selection
vmap D y'>p

nnoremap <leader>bb :b#<CR>
nnoremap <leader>bn :bn<CR>
nnoremap <leader>bp :bp<CR>

nnoremap vaa ggvGg_
nnoremap Vaa ggVG
nnoremap vv ^vg_
nnoremap gV `[v`]

" Create a split on the given side.
" From http://technotales.wordpress.com/2010/04/29/vim-splits-a-guide-to-doing-exactly-what-you-want/ via joakimk.
nnoremap <leader>swh   :leftabove  vsp<CR>
nnoremap <leader>swl :rightbelow vsp<CR>
nnoremap <leader>swk     :leftabove  sp<CR>
nnoremap <leader>swj   :rightbelow sp<CR>

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
vnoremap L g_

" move to last change
nnoremap gI `.

" search for word under cursor in current file using vimgrep
nnoremap <leader>8 :vimgrep <cword> %<CR>
vnoremap <leader>8 y:<C-U>vimgrep '<C-R>"' %<CR>gv

" delete all non-matching/matching lines using last used search
nnoremap <leader>v :v//d<CR>
nnoremap <leader>V :g//d<CR>

" same as above but only within selected lines
vnoremap <leader>v :v//d<CR>
vnoremap <leader>V :g//d<CR>

"}}}

" Filetypes {{{
augroup FileTypeStuff
  autocmd!

  " json {{{
  autocmd FileType json set equalprg=python\ -m\ json.tool
  set shiftwidth=2
  " }}}

  " xml {{{
  autocmd BufNewFile,BufRead *.config setfiletype xml
  autocmd BufNewFile,BufRead *.*proj setfiletype xml
  autocmd BufNewFile,BufRead *.xaml setfiletype xml
  let g:xml_syntax_folding=1
  autocmd FileType xml set foldmethod=syntax
  autocmd FileType xml set equalprg=xmllint\ --format\ -
  set shiftwidth=2
  " }}}

  " fsharp {{{
  if executable('fantomas')
  autocmd FileType fsharp set equalprg=fantomas\ --stdin\ --stdout
  endif
  set shiftwidth=2
  " }}}
augroup end
"}}}

" Plugins config {{{

" Omnisharp {{{
if s:has_plug('omnisharp-vim')
  if s:has_plug('neocomplete-vim')
    augroup omnisharp-neocomplete
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

" FSharp {{{
if s:has_plug('fsharpbinding')
  augroup fsharpbinding-settings
    autocmd!
    autocmd FileType fsharp call s:fsharpbinding_settings()
  augroup END
  function! s:fsharpbinding_settings()
    if s:has_plug('neocomplete-vim')
      let g:neocomplete#sources#omni#input_patterns.fsharp = '.*[^=\);]'
      let g:neocomplete#sources.fsharp = ['omni']
    endif

    nmap <leader>i :call fsharpbinding#python#FsiSendLine() <CR>
    vmap <leader>i :<C-U>call fsharpbinding#python#FsiSendSel() <CR>
  endfunction
endif
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
    \   'ruby' : ['.', '::'],
    \   'lua' : ['.', ':'],
    \   'erlang' : [':'],
    \   'fsharp' : ['.'],
    \ }
endif
" }}}

" Neocomplete {{{
if s:has_plug('neocomplete-vim')
  let g:neocomplete#enable_at_startup = 1
  " " let g:neocomplete#enable_smart_case = 1
  " let g:neocomplete#sources#syntax#min_keyword_length = 3

  " " Plugin key-mappings.
  " inoremap <expr><C-g>     neocomplete#undo_completion()
  " inoremap <expr><C-l>     neocomplete#complete_common_string()

  " Recommended key-mappings.
  " <CR>: close popup and save indent.

  " inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  " function! s:my_cr_function()
  "   return neocomplete#close_popup() . "\<CR>"
  "   " For no inserting <CR> key.
  "   "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
  " endfunction

  " <TAB>: completion.
  " inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

  " " <C-h>, <BS>: close popup and delete backword char.
  " " inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
  " " inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

  " " Enable omni completion.
  " autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  " autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  " autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  " autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  " autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

  " " call neocomplete#util#set_default_dictionary(
  " "   \ 'g:neocomplete#delimiter_patterns',
  " "   \ 'fsharp',
  " "   \ ['.'])

  " if !exists('g:neocomplete#sources')
  " let g:neocomplete#sources = {}
  " endif
  " let g:neocomplete#sources.fsharp = ['buffer', 'omni', 'file']

  " " Enable heavy omni completion.
  " if !exists('g:neocomplete#sources#omni#input_patterns')
  "   let g:neocomplete#sources#omni#input_patterns = {}
  " endif
  " let g:neocomplete#sources#omni#input_patterns.fsharp = '.*[^=\);]'
  " "let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
  " " et g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
  " "let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
endif
" }}}

" IncSearch {{{
if s:has_plug('incsearch.vim')
  let g:incsearch#magic = '\v' " very magic
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
  augroup incsearch-keymap
    autocmd!
    autocmd VimEnter call s:incsearch_keymap()
  augroup END
  function! s:incsearch_keymap()
    IncSearchNoreMap <C-n> <Over>(buffer-complete)
  endfunction
endif
" }}}

" VimFiler {{{
if s:has_plug('vimfiler.vim')
  nnoremap <leader>uv :VimFilerBufferDir<CR>
endif
" }}}
" Unite {{{
if s:has_plug('unite.vim')
  " Use ag for search
  if executable('ag')
    set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow\ -C0
    set grepformat=%f:%l:%c:%m
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts = '--line-numbers --nogroup --nocolor --smart-case --follow -C0'
    let g:unite_source_grep_recursive_opt = ''
    let g:unite_source_rec_async_command = 'ag --follow --nocolor --nogroup --hidden -g ""'
  elseif executable('pt')
    set grepprg=pt\ /nogroup\ /nocolor\ /smart-case\ /follow
    set grepformat=%f:%l:%m
    let g:unite_source_grep_command = 'pt'
    let g:unite_source_grep_default_opts = '/nogroup /nocolor /smart-case /follow /C0'
    let g:unite_source_grep_recursive_opt = ''
    let g:unite_source_rec_async_command = 'pt /nocolor /nogroup -g .'
  endif

  let g:unite_source_history_yank_enable = 1
  call unite#filters#matcher_default#use(['matcher_fuzzy'])

  nnoremap <silent> <leader>uf :<C-u>Unite -no-split -start-insert file_rec/async<cr>
  nnoremap <silent> <leader>ut :<C-u>Unite -no-split -start-insert file<cr>
  nnoremap <silent> <leader>uo :<C-u>UniteWithBufferDir -no-split -start-insert file_rec/async<cr>
  nnoremap <silent> <leader>ur :<C-u>Unite -hide-source-names -no-split -start-insert file_mru<cr>
  nnoremap <silent> <leader>uy :<C-u>Unite -no-split history/yank<cr>
  nnoremap <silent> <leader>ue :<C-u>Unite -no-split buffer<cr>

  " Custom mappings for the unite buffer
  autocmd FileType unite call s:unite_settings()
  function! s:unite_settings()
    " Enable navigation with control-j and control-k in insert mode
    imap <buffer> <C-j>   <Plug>(unite_select_next_line)
    imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
  endfunction
endif
"}}}

" Butane {{{
if s:has_plug('butane.vim')
  noremap <leader>bd :Bclose<CR>
  noremap <leader>bD :Bclose!<CR>
  noremap <leader>br :Breset<CR>
  noremap <leader>bR :Breset!<CR>
endif
"}}}

" Airline {{{
if s:has_plug('vim-airline')
  let g:airline_left_sep = ''
  let g:airline_right_sep = ''
  let g:airline_theme = 'powerlineish'
  let g:airline#extensions#whitespace#enabled = 0
endif
"}}}

" Fugitive {{{
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
  map <C-c><C-c> :SlimuxREPLSendLine<CR>
  vmap <C-c><C-c> :SlimuxREPLSendSelection<CR>
  map <Leader>a :SlimuxShellLast<CR>
  map <Leader>k :SlimuxSendKeysLast<CR>
  let g:slimux_scheme_keybindings=2
endif
"}}}

" gruvbox {{{
if s:has_plug('gruvbox')
  if has('gui_running')
    let g:gruvbox_invert_selection=0
    let g:gruvbox_italic=0
    let g:gruvbox_contrast_dark='medium'
  else
    let g:gruvbox_italic=0
  endif
  colorscheme gruvbox
  let g:airline_theme='gruvbox'
endif
"}}}

"}}}

" Functions {{{

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

augroup vim_evaluate
  autocmd!
  autocmd FileType vim nnoremap <buffer> <leader>xe :VimEvaluate<CR> |
        \ vnoremap <buffer> <leader>xe :VimEvaluate<CR>
augroup end
"}}}

"}}}
