

" neovim の設定ファイル
" 最小設定

""""""""""""""""""""""""""""""""""""""""""""""""""""
" terminal
""""""""""""""""""""""""""""""""""""""""""""""""""""
" :T でターミナルを下に開く
command! -nargs=* T split | wincmd j | resize 10 | terminal <args> 

" 常にinsertモードでターミナルを開く
autocmd TermOpen * startinsert

" ターミナルモードで行番号を非表示
autocmd TermOpen * setlocal norelativenumber
autocmd TermOpen * setlocal nonumber

" ESC で抜ける
tnoremap <ESC> <C-\><C-n>

""""""""""""""""""""""""""""""""""""""""""""""""""""
" space を leaderキー に設定
let mapleader = "\<Space>"

set nobackup " バックアップファイルを作らない
set noswapfile " スワップファイルを作らない

" lineのラップなし
set wrap!

set title

"インデント可視化
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%

set encoding=utf-8 " エンコーディング
scriptencoding utf-8 " エンコーディング
set helplang=ja "help日本語化

set number "行番号を表示
set relativenumber

set backspace=indent,eol,start " 挿入モードでバックスペースで削除できるようにする

"棒状カーソル"
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"
inoremap <Esc> <Esc>lh
set clipboard+=unnamedplus " ヤンクするとクリップボードに保存される
set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching 
set ignorecase              " case insensitive 
set mouse=av                 " マウスが使用できるようになる
set hlsearch                " highlight search 
set incsearch               " incremental search
set tabstop=4               " number of columns occupied by a tab 
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set splitright              " open new split panes to right and below
set splitbelow

" move line or visually selected block - alt+j/k
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
" move split panes to left/bottom/top/right
 nnoremap <A-h> <C-W>H
 nnoremap <A-j> <C-W>J
 nnoremap <A-k> <C-W>K
 nnoremap <A-l> <C-W>L

" move between panes to left/bottom/top/right
 nnoremap <C-h> <C-w>h
 nnoremap <C-j> <C-w>j
 nnoremap <C-k> <C-w>k
 nnoremap <C-l> <C-w>l

" Press i to enter insert mode, and ii to exit insert mode.
:inoremap ii <Esc>
:inoremap jk <Esc>
:inoremap kj <Esc>
:vnoremap jk <Esc>
:vnoremap kj <Esc>

""""""""""""""""""""""""""""""""""""""""""""""""""""
" pluginの設定
""""""""""""""""""""""""""""""""""""""""""""""""""""
" plug#begin()からendまでに必要なpluginを記述
call plug#begin()
 " NERDTree* コマンド => file system explorer
 Plug 'https://github.com/preservim/nerdtree' " File explor
 Plug 'https://github.com/vim-airline/vim-airline'
 Plug 'https://github.com/ap/vim-css-color':

" https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions
 Plug 'neoclide/coc.nvim', {'branch': 'release'} 

 Plug 'https://github.com/terryma/vim-multiple-cursors'
 Plug 'https://github.com/rafi/awesome-vim-colorschemes'

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin NERDTree 
" :cd 移動したいディレクトリ
" press Enter
" shift CD でrootに移動
""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree をnvimした際に実行 初期の場所: ファイル
autocmd VimEnter * NERDTree | wincmd p

" Ctrl+eでNERDTreeを開く
nnoremap <silent><C-e> :NERDTreeFocus<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plug 'https://github.com/rafi/awesome-vim-colorschemes'
""""""""""""""""""""""""""""""""""""""""""""""""""""
colorscheme jellybeans

""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plug 'https://github.com/terryma/vim-multiple-cursors'
""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ctrl + n で複数選択 
nnoremap <Leader>n :fp<C-n><C-n><CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plug 'neoclide/coc.nvim', {'branch': 'release'} 
""""""""""""""""""""""""""""""""""""""""""""""""""""
" snippetsの設定 実行したファイルの拡張子
nnoremap <Leader>sni :CocCommand snippets.editSnippets <CR>

" tabで補完の選択
inoremap <expr> <TAB> pumvisible() ? "\<C-y>" : "\<CR>"



