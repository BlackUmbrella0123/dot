" REFERENCES:
" https://github.com/wklken/k-vim
" https://github.com/chenxuan520/vim-fast
" https://github.com/wsdjeg/SpaceVim
" https://github.com/skywind3000/vim

" OPTIONS:
set nocompatible
syntax on
filetype plugin indent on
set lazyredraw
set background=dark
set termguicolors
colorscheme desert
set clipboard^=unnamed,unnamedplus
set ruler
set showmode
set mouse=
set number
set relativenumber
set nowrap
set cursorline
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent
set smartindent
set ignorecase
set smartcase
set incsearch
set hlsearch
set wildmenu
set wildmode=longest:full,full
set noswapfile
set nobackup
set noundofile
set history=1000
set noerrorbells
set visualbell
set splitbelow
set splitright
set updatetime=1000
set laststatus=2
set showtabline=2

" KEYBINDINGS:
let mapleader = " "
let maplocalleader = ","
imap jk <Esc>
nnoremap j gj
nnoremap k gk
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
imap <C-a> <Home>
imap <C-e> <End>
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" AUTOCMD
augroup my_goto_last_loc
  autocmd!
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal! g\ " | redraw! | endif
augroup END
augroup my_close_with_q
  autocmd!
  autocmd FileType help,qf,startuptime setlocal nobuflisted | nnoremap <silent> <buffer> q :close<CR>
augroup END
augroup my_fix_json_conceal
  autocmd!
  autocmd FileType json,jsonc,json5 setlocal conceallevel=0
augroup END
augroup my_auto_create_dir
  autocmd!
  autocmd BufWritePre *
        \ if expand('<afile>') !~# '^\w\w\+:[\\/][\\/]' &&
        \ !isdirectory(expand('<afile>:p:h')) |
        \ call mkdir(expand('<afile>:p:h'), 'p') |
        \ endif
augroup END
augroup my_disable_auto_comment
  autocmd!
  autocmd FileType *
        \ setlocal formatoptions-=c |
        \ setlocal formatoptions-=r |
        \ setlocal formatoptions-=o
augroup END
augroup my_resize_splits
  autocmd!
  autocmd VimResized * abdo wincmd=
augroup END
augroup my_wrap_spell
  autocmd!
  autocmd FileType gitcommit,markdown,text,plaintex setlocal wrap | setlocal spell
augroup END
augroup my_big_file_protect
  autocmd!
  autocmd BufReadPre *
        \ if getfsize(expand('<afile>')) > 2 * 1024 * 1024 |
        \ setlocal noswapfile |
        \ setlocal foldmethod=manual |
        \ setlocal undolevels=-1 |
        \ syntax off |
        \ endif
augroup END

" PLUGINS:
let data_dir = has('win32') || has('win64') ? '$HOME\vimfiles' : '~/.vim'
if empty(glob(data_dir.'/autoload/plug.vim'))
  if has('win32') || has('win64')
    silent execute '!powershell -Command "New-Item -Path "'.data_dir.' -Name autoload -Type Directory -Force; Invoke-WebRequest -Uri https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -OutFile '.data_dir.'\autoload\plug.vim"'
  else
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  endif
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
augroup my_install_plugins_automatically
  autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
        \| PlugInstall --sync | source $MYVIMRC
        \| endif
augroup END

call plug#begin()

Plug 'morhetz/gruvbox', { 'on': [] }
augroup plug_gruvbox
  autocmd!
  autocmd BufReadPost * call plug#load('gruvbox')
        \| autocmd! plug_gruvbox
        \| let g:gruvbox_contrast_dark = 'hard'
        \| colorscheme gruvbox
augroup END

Plug 'vim-airline/vim-airline', { 'on': [] }
augroup plug_airline
  autocmd!
  autocmd BufReadPost * call plug#load('vim-airline')
        \| autocmd! plug_airline
        \| let g:airline_extensions = []
        \| let g:airline#extensions#tabline#enabled = 1
        \| let g:airline#extensions#tabline#formatter = 'unique_tail'
augroup END

Plug 'machakann/vim-highlightedyank', { 'on': [] }
augroup plug_highlightedyank
  autocmd!
  autocmd BufReadPost * call plug#load('vim-highlightedyank')
        \| autocmd! plug_highlightedyank
        \| let g:highlightedyank_highlight_duration = 1000
augroup END

Plug 'airblade/vim-gitgutter', { 'on': [] }
augroup plug_gitgutter
  autocmd!
  autocmd BufReadPost * call plug#load('vim-gitgutter')
        \| autocmd! plug_gitgutter
augroup END

Plug 'LunarWatcher/auto-pairs', { 'on': [] }
augroup plug_autopairs
  autocmd!
  autocmd InsertEnter * call plug#load('auto-pairs')
        \| autocmd! plug_autopairs
        \| call autopairs#AutoPairsTryInit()
augroup END

Plug 'luochen1990/rainbow', { 'on': [] }
augroup plug_rainbow
  autocmd!
  autocmd InsertEnter * call plug#load('rainbow')
        \| autocmd! plug_rainbow
        \| call rainbow_main#toggle()
augroup END

Plug 'dense-analysis/ale', { 'on': [] }
augroup plug_ale
  autocmd!
  autocmd BufReadPost * call plug#load('ale')
        \| autocmd! plug_ale
augroup END

Plug 'ap/vim-css-color', { 'on': [] }
augroup plug_css_color
  autocmd!
  autocmd BufReadPre * call plug#load('vim-css-color')
        \| autocmd! plug_css_color
augroup END

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim', { 'on': ['Commands', 'Files', 'Buffers', 'Colors', 'Rg', 'History', 'BLines', 'Lines'] }
let g:fzf_layout = { 'window': { 'width': 0.92, 'height': 0.88, 'border': 'rounded' } }
nnoremap <leader><leader> :Commands<CR>
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fc :Colors<CR>
nnoremap <leader>fw :Rg 
nnoremap <leader>fr :History<CR>
nnoremap <leader>fs :BLines<CR>
nnoremap <leader>fS :Lines<CR>

call plug#end()
