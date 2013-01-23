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
  Bundle 'MarcWeber/vim-addon-mw-utils'
  Bundle 'tomtom/tlib_vim'
  Bundle 'tpope/vim-repeat'
  Bundle 'kana/vim-textobj-user'

  " Colour schemes
  Bundle 'altercation/vim-colors-solarized'
  Bundle 'chriskempson/base16-vim'

  " Motions and actions
  Bundle 'kana/vim-textobj-indent'
  Bundle 'tpope/vim-commentary'
  Bundle 'tpope/vim-surround'
  Bundle 'tpope/vim-speeddating'
  Bundle 'tpope/vim-unimpaired'
  Bundle 'taxilian/vim-web-indent'
  Bundle 'dahu/vim-fanfingtastic'
  Bundle 'matchit.zip'
  Bundle 'maxbrunsfeld/vim-yankstack'
  Bundle 'camelcasemotion'

  " Tools
  Bundle 'Soares/butane.vim'
  " Bundle 'AutoClose'
  " Bundle 'HTML-AutoCloseTag'
  Bundle 'kien/ctrlp.vim'
  Bundle 'vim-scripts/sessionman.vim'
  Bundle 'Lokaltog/vim-powerline'
  Bundle 'godlygeek/tabular'
  Bundle 'corntrace/bufexplorer'
  Bundle 'tpope/vim-fugitive'
  Bundle 'gregsexton/gitv'
  Bundle 'vim-scripts/scratch.vim'
  if executable('ctags')
    Bundle 'majutsushi/tagbar'
  endif
  if executable('ack')
    Bundle 'mileszs/ack.vim'
  endif

  " Filetypes
  Bundle 'ChrisYip/Better-CSS-Syntax-for-Vim'
  Bundle 'leshill/vim-json'
  Bundle 'kchmck/vim-coffee-script'
  Bundle 'spf13/vim-markdown'
  Bundle 'PProvost/vim-ps1'
  Bundle 'kongo2002/fsharp-vim'
  Bundle 'xolox/vim-lua-ftplugin'
  Bundle 'leafgarland/typescript-vim'
  if has('mac')
    Bundle 'Rip-Rip/clang_complete'
    Bundle 'jszakmeister/vim-togglecursor'
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

  let g:netrw_menu = 0
  "}}}
"}}}

" Vim UI {{{
  set showmode
  set cursorline

  if has('cmdline_info')
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " a ruler on steroids
  endif

  if has('statusline')

    " Broken down into easily includeable segments
    set statusline=%<%f\    " Filename
    set statusline+=%w%h%m%r " Options
    set statusline+=%{fugitive#statusline()} "  Git Hotness
    set statusline+=\ [%{&ff}/%Y]            " filetype
    set statusline+=\ [%{getcwd()}]          " current dir
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
  endif

  set linespace=0
  set number
  set hlsearch
  set winminheight=0              " windows can be 0 line high
  set ignorecase
  set wildmode=list:longest,full  " completion, list matches, then longest common part, then all.
  set whichwrap=b,s,h,l,<,>,[,]   " backspace and cursor keys wrap to
  set foldenable
  set list

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
  inoremap kj <esc>
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

  noremap <leader>ev :e $MYVIMRC<CR>

  nnoremap <c-z> zz
  nnoremap <space> za

  " System clipboard interaction.  Mostly from:
  " https://github.com/henrik/dotfiles/blob/master/vim/config/mappings.vim
  nnoremap <leader>y "*y
  nnoremap <leader>p :set paste<CR>"*p:set nopaste<CR>
  nnoremap <leader>P :set paste<CR>"*P:set nopaste<CR>
  vnoremap <leader>y "*ygv

  nnoremap <leader>bb :b#<CR>         " toggle buffer
  nnoremap <leader>bn :bn<CR>          " Next buffer.
  nnoremap <leader>bp :bp<CR>          " Previous buffer.

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
    autocmd FileType json map <leader>jq :%!python -m json.tool<CR>
  " }}}
  " xml {{{
    let g:xml_syntax_folding=1
    autocmd FileType xml set foldmethod=syntax
  " }}}
  augroup end
"}}}

" Plugins {{{

  " Butane {{{
    noremap <leader>bd :Bclose<CR>      " Close the buffer.
    noremap <leader>bD :Bclose!<CR>     " Close the buffer & discard changes.
  "}}}

  " Powerline {{{
    let g:Powerline_symbols='compatible'
    let g:Powerline_symbols_override = {'BRANCH': [0x00BB], 'LINE': [0x007C]}
    let g:Powerline_dividers_override = ['',[0x2022], '',[0x2022]]
  "}}}

  " Clojure {{{
    let vimclojure#FuzzyIndent=1
    let vimclojure#HighlightBuiltins=1
    let vimclojure#HighlightContrib=0
    let vimclojure#DynamicHighlighting=1
    let vimclojure#ParenRainbow=1
    let vimclojure#WantNailgun = 1
  "}}}

  " Ctags {{{
    set tags=./tags;/,~/.vimtags
  "}}}

  " AutoCloseTag {{{
  " Make it so AutoCloseTag works for xml and xhtml files as well
    autocmd FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
    nnoremap <Leader>ac <Plug>ToggleAutoCloseMappings
  "}}}

  " Tabularize {{{
    if exists(":Tabularize")
      nnoremap <Leader>a= :Tabularize /=<CR>
      vnoremap <Leader>a= :Tabularize /=<CR>
      nnoremap <Leader>a: :Tabularize /:<CR>
      vnoremap <Leader>a: :Tabularize /:<CR>
      nnoremap <Leader>a:: :Tabularize /:\zs<CR>
      vnoremap <Leader>a:: :Tabularize /:\zs<CR>
      nnoremap <Leader>a, :Tabularize /,<CR>
      vnoremap <Leader>a, :Tabularize /,<CR>
      nnoremap <Leader>a<Bar> :Tabularize /<Bar><CR>
      vnoremap <Leader>a<Bar> :Tabularize /<Bar><CR>

      " The following function automatically aligns when typing a
      " supported character
      inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

      function! s:align()
        let p = '^\s*|\s.*\s|\s*$'
        if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
          let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
          let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
          Tabularize/|/l1
          normal! 0
          call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
        endif
      endfunction

    endif
  "}}}

  " Session List {{{
    set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
    nnoremap <leader>sl :SessionList<CR>
    nnoremap <leader>ss :SessionSave<CR>
  "}}}

  " ctrlp {{{
    let g:ctrlp_working_path_mode = 2
    let g:ctrlp_custom_ignore = {
          \ 'dir':  '\.git$\|\.hg$\|\.svn$',
          \ 'file': '\.exe$\|\.so$\|\.dll$' }
  "}}}

  " TagBar {{{
    nnoremap <silent> <leader>tt :TagbarToggle<CR>
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
"}}}

" GUI Settings {{{
  colorscheme base16-default
  if has('gui_running')
    set guioptions=egt
    set lines=40
    set columns=120
    set guifont=Droid_Sans_Mono_for_Powerline:h12,Source_Code_Pro:h12,Monaco:h16,Consolas:h11,Courier\ New:h14
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
