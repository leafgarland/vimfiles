git submodule add http://github.com/tpope/vim-fugitive.git bundle/fugitive
git submodule add http://github.com/msanders/snipmate.vim.git bundle/snipmate
git submodule add http://github.com/tpope/vim-surround.git bundle/surround
git submodule add http://github.com/tpope/vim-git.git bundle/git
git submodule add http://github.com/ervandew/supertab.git bundle/supertab
git submodule add http://github.com/sontek/minibufexpl.vim.git bundle/minibufexpl
git submodule add http://github.com/wincent/Command-T.git bundle/command-t
git submodule add http://github.com/mitechie/pyflakes-pathogen.git
git submodule add http://github.com/mileszs/ack.vim.git bundle/ack
git submodule add http://github.com/sjl/gundo.vim.git bundle/gundo
git submodule add http://github.com/fs111/pydoc.vim.git bundle/pydoc
git submodule add http://github.com/reinh/vim-makegreen bundle/makegreen
git submodule add http://github.com/vim-scripts/The-NERD-tree.git bundle/nerdtree
git submodule add http://github.com/sontek/rope-vim.git bundle/ropevim
git submodule add git://github.com/majutsushi/tagbar bundle/tagbar
git submodule add http://github.com/bingaman/vim-sparkup.git bundle/sparkup
git submodule add http://github.com/chrismetcalf/vim-yankring.git bundle/yankring
git submodule init
git submodule update
git submodule foreach git submodule init
git submodule foreach git submodule update
