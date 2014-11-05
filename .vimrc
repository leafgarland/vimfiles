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
  " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
  " across (heterogeneous) systems easier.
    if has('win32') || has('win64')
      set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
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

  if has('mac')
    Plug 'Valloric/YouCompleteMe'
    Plug 'jszakmeister/vim-togglecursor'
    Plug 'sophacles/vim-processing'
    Plug 'epeli/slimux'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'lambdatoast/elm.vim', {'for': 'elm'}
    Plug 'wlangstroth/vim-racket', {'for': 'racket'}
    Plug 'dag/vim-fish', {'for': 'fish'}
  endif

  call plug#end()
"}}}

" General {{{
  " sensible.vim has decent defaults
  " so run those first and override later
  " runtime! plugin/sensible.vim

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

  set list

  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

  " Opens quick fix window when there are items, close it when empty
  autocmd QuickFixCmdPost [^l]* nested cwindow
  autocmd QuickFixCmdPost    l* nested lwindow
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
  " the button is sooo big, i must hit it lots
  let mapleader = "\<space>"
  nmap <leader><leader> :

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

  " Code folding options
  nnoremap <leader>f0 :set foldlevel=0<CR>
  nnoremap <leader>f1 :set foldlevel=1<CR>
  nnoremap <leader>f2 :set foldlevel=2<CR>
  nnoremap <leader>f3 :set foldlevel=3<CR>
  nnoremap <leader>f5 :set foldlevel=5<CR>
  nnoremap <leader>f6 :set foldlevel=6<CR>
  nnoremap <leader>f7 :set foldlevel=7<CR>
  nnoremap <leader>f8 :set foldlevel=8<CR>
  nnoremap <leader>f9 :set foldlevel=9<CR>
  nnoremap <leader>ff za

  "clearing highlighted search
  nnoremap <silent> <leader>/ :nohlsearch<CR>

  " Change Working Directory to that of the current file
  cnoremap cd. lcd %:p:h

  " visual shifting (does not exit Visual mode)
  vnoremap < <gv
  vnoremap > >gv

  cnoremap %% <C-R>=expand('%:h').'/'<cr>
  noremap <leader>ew :e <C-R>=expand('%:h').'/'<cr>

  " close all preview windows and quickfix|location lists
  nnoremap <silent> <C-W>z :wincmd z<Bar>cclose<Bar>lclose<CR>

  " Easier horizontal scrolling
  noremap zl zL
  noremap zh zH

  cnoremap <C-p> <Up>
  cnoremap <C-n> <Down>

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

  " Easier to type, and I never use the default behavior.
  nnoremap H ^
  nnoremap L $
  vnoremap L g_

  " Split line
  nnoremap U i<CR><Esc>

  " move to last change
  nnoremap gI `.
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
    autocmd FileType fsharp set equalprg=fantomas\ --stdin\ --stdout
    set shiftwidth=2
  " }}}
  augroup end
"}}}

" Plugins {{{
  " IncSearch {{{
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
  " }}}

  " Unite {{{
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

    nnoremap <leader>uf :<C-u>Unite -no-split -buffer-name=files -start-insert file_rec/async:!<cr>
    nnoremap <leader>ut :<C-u>Unite -no-split -buffer-name=files -start-insert file<cr>
    nnoremap <leader>uo :<C-u>UniteWithBufferDir -no-split -buffer-name=files -start-insert file_rec/async:!<cr>
    nnoremap <leader>ur :<C-u>Unite -hide-source-names -no-split -buffer-name=mru -start-insert file_mru<cr>
    nnoremap <leader>uy :<C-u>Unite -no-split -buffer-name=yank history/yank<cr>
    nnoremap <leader>ue :<C-u>Unite -no-split -buffer-name=buffer buffer<cr>

    " Custom mappings for the unite buffer
    autocmd FileType unite call s:unite_settings()
    function! s:unite_settings()
      " Enable navigation with control-j and control-k in insert mode
      imap <buffer> <C-j>   <Plug>(unite_select_next_line)
      imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
    endfunction
  "}}}

  " Butane {{{
    noremap <leader>bd :Bclose<CR>      " Close the buffer.
    noremap <leader>bD :Bclose!<CR>     " Close the buffer & discard changes.
  "}}}

  " Airline {{{
    let g:airline_left_sep = ''
    let g:airline_right_sep = ''
    let g:airline_theme = 'powerlineish'
    let g:airline#extensions#whitespace#enabled = 0
  "}}}

  " Ctags {{{
    set tags=./tags;/,~/.vimtags
  "}}}

  " Fugitive {{{
    nnoremap <silent> <leader>gs :Gstatus<CR>
    nnoremap <silent> <leader>gd :Gdiff<CR>
    nnoremap <silent> <leader>gc :Gcommit<CR>
    nnoremap <silent> <leader>gb :Gblame<CR>
    nnoremap <silent> <leader>gl :Glog<CR>
    nnoremap <silent> <leader>gp :Git push<CR>
  "}}}

  "{{{ Slimux
    map <C-c><C-c> :SlimuxREPLSendLine<CR>
    vmap <C-c><C-c> :SlimuxREPLSendSelection<CR>
    map <Leader>a :SlimuxShellLast<CR>
    map <Leader>k :SlimuxSendKeysLast<CR>
    let g:slimux_scheme_keybindings=2
  "}}}
"}}}

" GUI Settings {{{
  let t_Co=256
  let base16colorspace=256
  colorscheme base16-monokai
  if has('gui_running')
    set cursorline
    set guioptions=egt
    set lines=50
    set columns=120
    set guifont=Source_Code_Pro:h12,Monaco:h16,Consolas:h11,Courier\ New:h14
  endif

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
