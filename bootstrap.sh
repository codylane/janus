#!/usr/bin/env bash
set -e

# download all the janus tools
mkdir -p janus/janus/vim/tools/

cd janus/janus/vim/tools/

[ -d ansible-vim ]             || git clone https://github.com/pearofducks/ansible-vim.git
[ -d tabular ]                 || git clone https://github.com/godlygeek/tabular.git
[ -d tcomment_vim ]            || git clone https://github.com/tomtom/tcomment_vim.git
[ -d vim-flake8 ]              || git clone https://github.com/nvie/vim-flake8.git
[ -d vim-puppet ]              || git clone https://github.com/rodjek/vim-puppet.git
[ -d vim-tmux-navigator ]      || git clone https://github.com/christoomey/vim-tmux-navigator.git
[ -d vim-airline ]             || git clone https://github.com/vim-airline/vim-airline.git
[ -d supertab ]                || git clone https://github.com/ervandew/supertab.git
[ -d tlib_vim ]                || git clone https://github.com/tomtom/tlib_vim.git
[ -d vim-unimpaired ]          || git clone https://github.com/tpope/vim-unimpaired.git
[ -d Kwbd.vim ]                    || git clone https://github.com/rgarver/Kwbd.vim.git
[ -d nerdtree ]                || git clone https://github.com/scrooloose/nerdtree.git
[ -d vim-buffergator ]         || git clone https://github.com/jeetsukumaran/vim-buffergator.git
[ -d vim-repeat ]              || git clone https://github.com/tpope/vim-repeat.git
[ -d vim-snipmate ]            || git clone https://github.com/garbas/vim-snipmate.git
[ -d vim-fugitive ]            || git clone https://github.com/tpope/vim-fugitive.git
[ -d vim-addon-mw-utils ]      || git clone https://github.com/MarcWeber/vim-addon-mw-utils.git
[ -d vim-snippets ]            || git clone https://github.com/honza/vim-snippets.git
[ -d syntastic ]               || git clone https://github.com/vim-syntastic/syntastic.git
[ -d vim-gitgutter ]           || git clone https://github.com/airblade/vim-gitgutter.git
[ -d vim-css-color ]           || git clone https://github.com/ap/vim-css-color.git
[ -d vim-indent-object ]       || git clone https://github.com/michaeljsmith/vim-indent-object.git
[ -d ctrlp.vim ]               || git clone https://github.com/ctrlpvim/ctrlp.vim.git
[ -d vim-multiple-cursors ]    || git clone https://github.com/terryma/vim-multiple-cursors.git
[ -d vim-surround ]            || git clone https://github.com/tpope/vim-surround.git
[ -d nerdcommenter ]           || git clone https://github.com/scrooloose/nerdcommenter.git
[ -d vim-vroom ]               || git clone https://github.com/skalnik/vim-vroom.git
[ -d vim-easymotion ]          || git clone https://github.com/Lokaltog/vim-easymotion.git
[ -d webapi-vim ]              || git clone https://github.com/mattn/webapi-vim.git
[ -d NrrwRgn ]                 || git clone https://github.com/chrisbra/NrrwRgn.git
[ -d vim-eunuch ]              || git clone https://github.com/tpope/vim-eunuch.git
[ -d vim-trailing-whitespace ] || git clone https://github.com/bronson/vim-trailing-whitespace.git
[ -d ack.vim ]                     || git clone https://github.com/mileszs/ack.vim.git
[ -d gundo.vim ]               || git clone https://github.com/sjl/gundo.vim.git
[ -d vimwiki ]                 || git clone https://github.com/vim-scripts/vimwiki.git
[ -d vim-endwise ]             || git clone https://github.com/tpope/vim-endwise.git
[ -d vim-visualstar ]          || git clone https://github.com/thinca/vim-visualstar.git
[ -d tagbar ]                  || git clone https://github.com/majutsushi/tagbar.git
[ -d gist-vim ]                || git clone https://github.com/mattn/gist-vim.git
[ -d vim-dispatch ]            || git clone https://github.com/tpope/vim-dispatch.git
[ -d ZoomWin ]                 || git clone https://github.com/sh-dude/ZoomWin.git

cd - >>/dev/null
