set number
set shiftwidth=4
set autoindent
set relativenumber
set ruler
set ttyfast
set tabstop=4
syntax on
noremap <Up>    <Nop>
noremap <Down>  <Nop>
noremap <Left>  <Nop>
noremap <Right> <Nop>
set clipboard=unnamedplus
vmap <C-c> "+y
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!


let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
	endif

call plug#begin()
Plug 'mattn/emmet-vim'
Plug 'https://github.com/AndrewRadev/tagalong.vim.git'
Plug 'https://github.com/tpope/vim-surround.git'
Plug 'dense-analysis/ale' 
Plug 'sheerun/vim-polyglot'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()

"let g:ale_fixers = {
"	 \ 'html': ['prettier'],
" \ 'css': ['stylelint'],
" \}
"let g:ale_linters = {
"	 \ 'html': ['htmlhint'],
" \ 'css': ['stylelint'],
" \}
"let g:ale_linters_explicit = 1
"let g:ale_fix_on_save = 1
"let g:user_emmet_install_global = 0
"autocmd FileType html,css EmmetInstall
"let g:user_emmet_leader_key=','
"
"let g:tagalong_verbose = 1

nnoremap <C-p> :Files<CR>
