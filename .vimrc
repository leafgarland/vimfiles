" vim: foldlevel=0 foldmethod=marker shiftwidth=2 :

" Environment {{{
  " Basics {{{
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

  " Setup Bundle Support {{{
  " The next two lines ensure that the ~/.vim/bundle/ system works
      set runtimepath+=~/.vim/bundle/vundle
      call vundle#rc()
  "}}}
"}}}

" Bundles {{{
  " Base
  Bundle 'gmarik/vundle'
  Bundle 'tpope/vim-sensible'
  Bundle 'tpope/vim-dispatch'
  Bundle 'tpope/vim-repeat'
  Bundle 'kana/vim-textobj-user'
  Bundle 'Shougo/vimproc'

  " Colour schemes and pretty things
  Bundle 'chriskempson/base16-vim'
  Bundle 'Pychimp/vim-luna'
  Bundle 'bling/vim-airline'
  Bundle 'w0ng/vim-hybrid'

  " Motions and actions
  Bundle 'kana/vim-textobj-indent'
  Bundle 'tpope/vim-commentary'
  Bundle 'tpope/vim-surround'
  Bundle 'tpope/vim-speeddating'
  Bundle 'tpope/vim-unimpaired'
  Bundle 'tpope/vim-abolish'
  Bundle 'justinmk/vim-sneak'
  Bundle 'tommcdo/vim-exchange'
  Bundle 'matchit.zip'

  " Tools
  Bundle 'Shougo/unite.vim'
  Bundle 'Soares/butane.vim'
  Bundle 'tpope/vim-fugitive'
  Bundle 'tpope/vim-ragtag'
  Bundle 'tpope/vim-vinegar'

  " Filetypes
  Bundle 'ChrisYip/Better-CSS-Syntax-for-Vim'
  Bundle 'leshill/vim-json'
  Bundle 'kchmck/vim-coffee-script'
  Bundle 'spf13/vim-markdown'
  Bundle 'PProvost/vim-ps1'
  Bundle 'kongo2002/fsharp-vim'
  Bundle 'tpope/vim-fireplace'
  Bundle 'guns/vim-clojure-static'
  Bundle 'guns/vim-sexp'
  Bundle 'tpope/vim-sexp-mappings-for-regular-people'
  Bundle 'leafgarland/typescript-vim'
  Bundle 'jb55/Vim-Roy'
  Bundle 'Blackrush/vim-gocode'
  Bundle 'derekwyatt/vim-scala'
  if has('mac')
    Bundle 'Valloric/YouCompleteMe'
    Bundle 'jszakmeister/vim-togglecursor'
    Bundle 'wlangstroth/vim-racket'
  endif
"}}}

" General {{{
  " sensible.vim has decent defaults
  " so run those first and override later
  runtime! plugin/sensible.vim

  set mouse=a

  " always switch to the current file directory.
  " autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

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

  set linespace=0
  set number
  set hlsearch
  set winminheight=0              " windows can be 0 line high
  set ignorecase
  set wildmode=list:longest,full  " completion, list matches, then longest common part, then all.
  set whichwrap=b,s,h,l,<,>,[,]   " backspace and cursor keys wrap to

  set foldenable
  set foldmethod=syntax
  set foldlevelstart=2
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

  " duplicate visual selection
  vmap D y'>p

  " Easier moving in tabs and windows
  nnoremap <C-J> <C-W>j
  nnoremap <C-K> <C-W>k
  nnoremap <C-L> <C-W>l
  nnoremap <C-H> <C-W>h

  " Wrapped lines goes down/up to next row, rather than next line in file.
  nnoremap j gj
  nnoremap k gk

  " get out of insert quickly
  inoremap ii <esc>

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

  " Shortcuts
  " Change Working Directory to that of the current file
  cnoremap cwd lcd %:p:h
  cnoremap cd. lcd %:p:h

  " visual shifting (does not exit Visual mode)
  vnoremap < <gv
  vnoremap > >gv

  " Some helpers to edit mode
  " http://vimcasts.org/e/14
  cnoremap %% <C-R>=expand('%:h').'/'<cr>
  noremap <leader>ew :e %%
  noremap <leader>es :sp %%
  noremap <leader>ev :vsp %%
  noremap <leader>et :tabe %%

  " Adjust viewports to the same size
  noremap <Leader>= <C-w>=

  " Easier horizontal scrolling
  noremap zl zL
  noremap zh zH

  cnoremap <C-p> <Up>
  cnoremap <C-n> <Down>

  nnoremap <silent> <F7> :set spell!<cr>

  noremap <leader>ee :e $MYVIMRC<CR>

  nnoremap <c-z> zz

  " System clipboard interaction.  Mostly from:
  " https://github.com/henrik/dotfiles/blob/master/vim/config/mappings.vim
  nnoremap <leader>y "*y
  nnoremap <leader>p :set paste<CR>"*p:set nopaste<CR>
  nnoremap <leader>P :set paste<CR>"*P:set nopaste<CR>
  vnoremap <leader>y "*ygv

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
  nnoremap K i<CR><Esc>

  " move to last change
  nnoremap gI `.
"}}}

" Filetypes {{{
  augroup FileTypeStuff
    autocmd!

  " json {{{
    autocmd FileType json set equalprg=python\ -m\ json.tool
  " }}}
  " xml {{{
    autocmd BufNewFile,BufRead *.config setfiletype xml
    autocmd BufNewFile,BufRead *.*proj setfiletype xml
    let g:xml_syntax_folding=1
    autocmd FileType xml set foldmethod=syntax
    autocmd FileType xml set equalprg=xmllint\ --format\ -
  " }}}
  " fsharp {{{
    autocmd FileType fsharp set equalprg=fantomas\ --stdin\ --stdout
  " }}}
  augroup end
"}}}

" Plugins {{{
  " Unite {{{
    " Use ag for search
    if executable('ag')
      set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow
      set grepformat=%f:%l:%c:%m
      let g:unite_source_grep_command = 'ag'
      let g:unite_source_grep_default_opts = '--nogroup --nocolor -S -C4'
      let g:unite_source_grep_recursive_opt = ''
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
    let g:airline_theme = 'base16'
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

  " Scratch {{{
    command! ScratchToggle call ScratchToggle()

    function! ScratchToggle()
      if exists("w:is_scratch_window")
        unlet w:is_scratch_window
        exec "q"
      else
        exec "normal! :Sscratch\<cr>\<C-W>J:resize 13\<cr>"
        let w:is_scratch_window = 1
      endif
    endfunction

    nnoremap <silent> <leader><tab> :ScratchToggle<cr>
  "}}}

  "{{{ Sneak
    " let g:sneak#streak = 1
    " hi link SneakPluginTarget ErrorMsg
    " hi link SneakPluginScope  Comment
  "}}}
"}}}

" GUI Settings {{{
  let t_Co=256
  let base16colorspace=256
  colorscheme base16-default
  if has('gui_running')
    colorscheme base16-monokai
    let g:airline_theme = 'base16'
    set cursorline
    set guioptions=egt
    set lines=40
    set columns=120
    set guifont=Source_Code_Pro:h12,Monaco:h16,Consolas:h11,Courier\ New:h14
  endif

"}}}

" Functions {{{
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
