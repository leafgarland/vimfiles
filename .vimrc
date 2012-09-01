" vim: set foldmarker={,} foldlevel=0 foldmethod=marker

" Environment {
    " Basics {
        set nocompatible
        set background=dark
    " }

    " Windows Compatible {
        " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
        " across (heterogeneous) systems easier.
        if has('win32') || has('win64')
          set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
        endif
    " }
    "
    " Setup Bundle Support {
    " The next two lines ensure that the ~/.vim/bundle/ system works
        set rtp+=~/.vim/bundle/vundle
        call vundle#rc()
    " }
" }

" Bundles {
        Bundle 'gmarik/vundle'
        Bundle 'MarcWeber/vim-addon-mw-utils'
        Bundle 'tomtom/tlib_vim'
        Bundle "kana/vim-textobj-user"
        if executable('ack')
            Bundle 'mileszs/ack.vim'
        endif

        Bundle 'altercation/vim-colors-solarized'
        Bundle 'AutoClose'
        Bundle 'kien/ctrlp.vim'
        Bundle 'vim-scripts/sessionman.vim'
        Bundle 'matchit.zip'
        Bundle 'Lokaltog/vim-powerline'
        Bundle 'Lokaltog/vim-easymotion'
        Bundle 'godlygeek/tabular'
        Bundle 'corntrace/bufexplorer'
        Bundle 'tpope/vim-fugitive'
        if executable('ctags')
            Bundle 'majutsushi/tagbar'
        endif

        Bundle 'leshill/vim-json'
        Bundle 'groenewege/vim-less'
        Bundle 'taxilian/vim-web-indent'

        Bundle 'HTML-AutoCloseTag'
        Bundle 'ChrisYip/Better-CSS-Syntax-for-Vim'

        Bundle 'spf13/vim-markdown'
        Bundle 'spf13/vim-preview'
        Bundle "PProvost/vim-ps1"
        Bundle "kana/vim-scratch"
        Bundle "kana/vim-textobj-indent"
        Bundle "kchmck/vim-coffee-script"
        Bundle "kongo2002/fsharp-vim"
        Bundle "michaeljsmith/vim-indent-object"
        Bundle "tpope/vim-commentary"
        Bundle 'tpope/vim-surround'
        Bundle "tpope/vim-repeat"
        Bundle "tpope/vim-speeddating"
        Bundle "tpope/vim-unimpaired"
        Bundle "vim-scripts/YankRing.vim"
        Bundle "xolox/vim-easytags"
        Bundle "xolox/vim-lua-ftplugin"
        Bundle "xolox/vim-shell"
        Bundle "zaiste/VimClojure"
" }

" General {
    set background=dark
    filetype plugin indent on
    syntax on
    set mouse=a
    scriptencoding utf-8
    set encoding=utf-8

    " always switch to the current file directory.
    autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif

    set shortmess+=filmnrxoOtT      " abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " better unix / windows compatibility
    set virtualedit=onemore         " allow for cursor beyond last character
    set history=1000
    set hidden

    " Setting up the directories {
        set backup
        if has('persistent_undo')
            set undofile
            set undolevels=1000
            set undoreload=10000
        endif
    " }
" }

" Vim UI {
    color solarized
    let g:solarized_termtrans=1

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
    set linespace=0                 " No extra spaces between rows
    set number                      " Line numbers on
    set showmatch                   " show matching brackets/parenthesis
    set incsearch                   " find as you type search
    set hlsearch                    " highlight search terms
    set winminheight=0              " windows can be 0 line high
    set ignorecase                  " case insensitive search
    set smartcase                   " case sensitive when uc present
    set wildmenu                    " show list instead of just completing
    set wildmode=list:longest,full  " command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " backspace and cursor keys wrap to
    set scrolljump=5                " lines to scroll when cursor leaves screen
    set scrolloff=3                 " minimum lines to keep above and below cursor
    set foldenable                  " auto fold code
    set list
    set listchars=tab:,.,trail:.,extends:#,nbsp:. " Highlight problematic whitespace

" }

" Formatting {
    set nowrap                      " wrap long lines
    set autoindent                  " indent at the same level of the previous line
    set shiftwidth=4                " use indents of 4 spaces
    set expandtab                   " tabs are spaces, not tabs
    set tabstop=4                   " an indentation every four columns
    set softtabstop=4               " let backspace delete indent
" }

" Key (re)Mappings {

    " Easier moving in tabs and windows
    map <C-J> <C-W>j<C-W>_
    map <C-K> <C-W>k<C-W>_
    map <C-L> <C-W>l<C-W>_
    map <C-H> <C-W>h<C-W>_

    " Wrapped lines goes down/up to next row, rather than next line in file.
    nnoremap j gj
    nnoremap k gk

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

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

    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null

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

    inoremap <silent> <F7> <c-O>:call SpellToggle()<cr>
    map <silent> <F7> :call SpellToggle()<cr>
    function SpellToggle()
        if &spell == 1
            set nospell
        else
            set spell
        endif
    endfunction
" }

" Plugins {

    " Powerline {
        let g:Powerline_symbols='compatible'
        let g:Powerline_symbols_override = {'BRANCH': [0x2325]}
    " }

    " Clojure {
        let vimclojure#FuzzyIndent=1
        let vimclojure#HighlightBuiltins=1
        let vimclojure#HighlightContrib=1
        let vimclojure#DynamicHighlighting=1
        let vimclojure#ParenRainbow=1
        let vimclojure#WantNailgun = 1
    " }

    " Ctags {
        set tags=./tags;/,~/.vimtags
    " }

    " AutoCloseTag {
        " Make it so AutoCloseTag works for xml and xhtml files as well
        au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
        nmap <Leader>ac <Plug>ToggleAutoCloseMappings
    " }

    " Tabularize {
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
     " }

     " Session List {
        set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
        nmap <leader>sl :SessionList<CR>
        nmap <leader>ss :SessionSave<CR>
     " }

     " Buffer explorer {
        nmap <leader>b :BufExplorer<CR>
     " }

     " ctrlp {
        let g:ctrlp_working_path_mode = 2
        let g:ctrlp_custom_ignore = {
            \ 'dir':  '\.git$\|\.hg$\|\.svn$',
            \ 'file': '\.exe$\|\.so$\|\.dll$' }
     "}

     " yankring {
        let g:yankring_replace_n_pkey = '<c-,>'
        let g:yankring_replace_n_nkey = '<c-.>'
     " }

     " TagBar {
        nnoremap <silent> <leader>tt :TagbarToggle<CR>
     "}

     " PythonMode {
     " Disable if python support not present
        if !has('python')
           let g:pymode = 1
        endif
     " }

     " Fugitive {
        nnoremap <silent> <leader>gs :Gstatus<CR>
        nnoremap <silent> <leader>gd :Gdiff<CR>
        nnoremap <silent> <leader>gc :Gcommit<CR>
        nnoremap <silent> <leader>gb :Gblame<CR>
        nnoremap <silent> <leader>gl :Glog<CR>
        nnoremap <silent> <leader>gp :Git push<CR>
     "}
" }

" GUI Settings {
    if has('gui_running')
        set guioptions-=T
        set guioptions-=L
        set guioptions-=l
        set guioptions-=m
        set guioptions-=R
        set guioptions-=r
        set lines=40
        set columns=120
        set guifont=Consolas:h11,Courier\ New:h14
    endif
" }

 " Functions {

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

" }
