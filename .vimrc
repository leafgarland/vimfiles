 " vim: foldlevel=0 foldmethod=marker :

" Environment {{{
    " Basics {{{
        set nocompatible
        set background=dark
    " }}}

    " Windows Compatible {{{
        " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
        " across (heterogeneous) systems easier.
        if has('win32') || has('win64')
          set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
        endif
    " }}}

    " Setup Bundle Support {{{
    " The next two lines ensure that the ~/.vim/bundle/ system works
        set rtp+=~/.vim/bundle/vundle
        call vundle#rc()
    " }}}
" }}}

" Bundles {{{
        " Base
        Bundle 'gmarik/vundle'
        Bundle 'MarcWeber/vim-addon-mw-utils'
        Bundle 'tomtom/tlib_vim'
        Bundle "tpope/vim-repeat"
        Bundle "kana/vim-textobj-user"

        " Colour schemes
        Bundle 'altercation/vim-colors-solarized'
        Bundle 'chriskempson/base16-vim'

        " Motions and actions
        Bundle "kana/vim-textobj-indent"
        Bundle "tpope/vim-commentary"
        Bundle 'tpope/vim-surround'
        Bundle "tpope/vim-speeddating"
        Bundle "tpope/vim-unimpaired"
        Bundle 'taxilian/vim-web-indent'
        Bundle 'matchit.zip'

        " Tools
        Bundle 'AutoClose'
        Bundle 'kien/ctrlp.vim'
        Bundle 'vim-scripts/sessionman.vim'
        Bundle 'Lokaltog/vim-powerline'
        Bundle 'Lokaltog/vim-easymotion'
        Bundle 'godlygeek/tabular'
        Bundle 'corntrace/bufexplorer'
        Bundle 'tpope/vim-fugitive'
        Bundle 'gregsexton/gitv'
        Bundle "vim-scripts/scratch.vim"
        Bundle "xolox/vim-shell"
        Bundle 'HTML-AutoCloseTag'
        if has('ruby')
            Bundle 'spf13/vim-preview'
        endif
        if executable('ctags')
            Bundle 'majutsushi/tagbar'
        endif
        if executable('ack')
            Bundle 'mileszs/ack.vim'
        endif

        " Filetypes
        Bundle 'ChrisYip/Better-CSS-Syntax-for-Vim'
        Bundle 'leshill/vim-json'
        Bundle "kchmck/vim-coffee-script"
        Bundle 'spf13/vim-markdown'
        Bundle "PProvost/vim-ps1"
        Bundle "kongo2002/fsharp-vim"
        Bundle "xolox/vim-lua-ftplugin"
        " Bundle "zaiste/VimClojure"
        Bundle 'thinca/vim-ft-clojure'
        Bundle 'chrisbra/csv.vim'
" }}}

" General {{{
    set background=dark
    filetype plugin indent on
    syntax on
    set mouse=a
    scriptencoding utf-8
    set encoding=utf-8

    " always switch to the current file directory.
    " autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

    set shortmess+=fiIlmnrxoOtT      " abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " better unix / windows compatibility
    set virtualedit=onemore         " allow for cursor beyond last character
    set history=1000
    set hidden

    " Setting up the directories {{{
        set backup
        if has('persistent_undo')
            set undofile
            set undolevels=1000
            set undoreload=10000
        endif
    " }}}
" }}}

" Vim UI {{{
    set showmode
    set cursorline

    if has('cmdline_info')
        set ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " a ruler on steroids
        set showcmd                 " show partial commands in status line and
    endif

    if has('statusline')
        set laststatus=2

        " Broken down into easily includeable segments
        set statusline=%<%f\    " Filename
        set statusline+=%w%h%m%r " Options
        set statusline+=%{fugitive#statusline()} "  Git Hotness
        set statusline+=\ [%{&ff}/%Y]            " filetype
        set statusline+=\ [%{getcwd()}]          " current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif

    set backspace=indent,eol,start  " backspace for dummies
    set linespace=0
    set number
    set showmatch
    set incsearch
    set hlsearch
    set winminheight=0              " windows can be 0 line high
    set ignorecase
    set smartcase
    set wildmenu
    set wildmode=list:longest,full  " completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " backspace and cursor keys wrap to
    set scrolljump=5                " lines to scroll when cursor leaves screen
    set scrolloff=3                 " minimum lines to keep above and below cursor
    set foldenable
    set list
    set listchars=tab:▸»,trail:.,extends:#,nbsp:. " Highlight problematic whitespace
" }}}

" Formatting {{{
    set nowrap
    set autoindent
    set shiftwidth=4                " use indents of 4 spaces
    set expandtab                   " tabs are spaces, not tabs
    set tabstop=4                   " an indentation every four columns
    set softtabstop=4               " let backspace delete indent
" }}}

" Key (re)Mappings {{{

    " Easier moving in tabs and windows
    map <C-J> <C-W>j
    map <C-K> <C-W>k
    map <C-L> <C-W>l
    map <C-H> <C-W>h

    " Wrapped lines goes down/up to next row, rather than next line in file.
    nnoremap j gj
    nnoremap k gk

    """ Code folding options
    nmap <leader>f0 :set foldlevel=0<CR>
    nmap <leader>f1 :set foldlevel=1<CR>
    nmap <leader>f2 :set foldlevel=2<CR>
    nmap <leader>f3 :set foldlevel=3<CR>
    nmap <leader>f5 :set foldlevel=5<CR>
    nmap <leader>f6 :set foldlevel=6<CR>
    nmap <leader>f7 :set foldlevel=7<CR>
    nmap <leader>f8 :set foldlevel=8<CR>
    nmap <leader>f9 :set foldlevel=9<CR>

    "clearing highlighted search
    nmap <silent> <leader>/ :nohlsearch<CR>

    " Shortcuts
    " Change Working Directory to that of the current file
    cmap cwd lcd %:p:h
    cmap cd. lcd %:p:h

    " visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Some helpers to edit mode
    " http://vimcasts.org/e/14
    cnoremap %% <C-R>=expand('%:h').'/'<cr>
    map <leader>ew :e %%
    map <leader>es :sp %%
    map <leader>ev :vsp %%
    map <leader>et :tabe %%

    " Adjust viewports to the same size
    map <Leader>= <C-w>=

    " Easier horizontal scrolling
    map zl zL
    map zh zH

    cnoremap <C-p> <Up>
    cnoremap <C-n> <Down>

    nnoremap <silent> <F7> :set spell!<cr>

    map <leader>ev :e $MYVIMRC<CR>

    nnoremap <c-z> zz
    nnoremap <space> za

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " System clipboard interaction.  Mostly from:
    " https://github.com/henrik/dotfiles/blob/master/vim/config/mappings.vim
    noremap <leader>y "*y
    noremap <leader>p :set paste<CR>"*p:set nopaste<CR>
    noremap <leader>P :set paste<CR>"*P:set nopaste<CR>
    vnoremap <leader>y "*ygv

    nnoremap <leader>bb :b#<CR>

    nnoremap vaa ggvGg_
    nnoremap Vaa ggVG
    nnoremap vv ^vg_
    nmap gV `[v`]

    " Create a split on the given side.
    " From http://technotales.wordpress.com/2010/04/29/vim-splits-a-guide-to-doing-exactly-what-you-want/ via joakimk.
    nmap <leader>swh   :leftabove  vsp<CR>
    nmap <leader>swl :rightbelow vsp<CR>
    nmap <leader>swk     :leftabove  sp<CR>
    nmap <leader>swj   :rightbelow sp<CR>

    " <alt-j> <alt-k> move line
    nnoremap <M-j> :m+<CR>
    nnoremap <M-k> :m-2<CR>
    inoremap <M-j> <Esc>:m+<CR>
    inoremap <M-k> <Esc>:m-2<CR>
    vnoremap <M-j> :m'>+<<CR>gv
    vnoremap <M-k> :m-2<CR>gv

    " Easier to type, and I never use the default behavior.
    noremap H ^
    noremap L $
    vnoremap L g_

    " Heresy
    inoremap <c-a> <esc>I
    inoremap <c-e> <esc>A

    " move to last change
    nnoremap gI `.
" }}}

" Plugins {{{ 

    " Powerline {{{
        let g:Powerline_symbols='compatible'
        let g:Powerline_symbols_override = {'BRANCH': [0x25B8]}
    " }}}

    " Clojure {{{
        let vimclojure#FuzzyIndent=1
        let vimclojure#HighlightBuiltins=1
        let vimclojure#HighlightContrib=0
        let vimclojure#DynamicHighlighting=1
        let vimclojure#ParenRainbow=1
        let vimclojure#WantNailgun = 1
    " }}}

    " Ctags {{{
        set tags=./tags;/,~/.vimtags
    " }}}

    " AutoCloseTag {{{
        " Make it so AutoCloseTag works for xml and xhtml files as well
        au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
        nmap <Leader>ac <Plug>ToggleAutoCloseMappings
    " }}}

    " Tabularize {{{
        if exists(":Tabularize")
          nmap <Leader>a= :Tabularize /=<CR>
          vmap <Leader>a= :Tabularize /=<CR>
          nmap <Leader>a: :Tabularize /:<CR>
          vmap <Leader>a: :Tabularize /:<CR>
          nmap <Leader>a:: :Tabularize /:\zs<CR>
          vmap <Leader>a:: :Tabularize /:\zs<CR>
          nmap <Leader>a, :Tabularize /,<CR>
          vmap <Leader>a, :Tabularize /,<CR>
          nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
          vmap <Leader>a<Bar> :Tabularize /<Bar><CR>

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
     " }}}

     " Session List {{{
        set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
        nmap <leader>sl :SessionList<CR>
        nmap <leader>ss :SessionSave<CR>
     " }}}

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
    " }}}
" }}}

" GUI Settings {{{
    if has('gui_running')
        colorscheme base16
        set guioptions=egt
        set lines=40
        set columns=120
        set guifont=Consolas:h11,Courier\ New:h14
    endif
" }}}

 " Functions {{{

function! InitializeDirectories()
    let separator = "."
    let parent = $HOME
    let prefix = '.vim'
    let dir_list = {
                \ 'backup': 'backupdir',
                \ 'views': 'viewdir',
                \ 'swap': 'directory' }

    if has('persistent_undo')
        let dir_list['undo'] = 'undodir'
    endif

    for [dirname, settingname] in items(dir_list)
        let directory = parent . '/' . prefix . dirname . "/"
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "g")
            exec "set " . settingname . "=" . directory
        endif
    endfor
endfunction
call InitializeDirectories()

" }}}
