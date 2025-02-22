let mapleader = ","

if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'tpope/vim-surround'
Plug 'preservim/nerdtree'
Plug 'junegunn/goyo.vim'
Plug 'jreybert/vimagit'
Plug 'lukesmithxyz/vimling'
Plug 'vimwiki/vimwiki'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'ap/vim-css-color'
Plug 'overcache/NeoSolarized'
call plug#end()

" Colors:
    colorscheme NeoSolarized
    set termguicolors
    set background=dark
    " Turns off highlighting on the bits of code that are changed, so the line that is changed is highlighted but the actual text that has changed stands out on the line and is readable.
    if &diff
        highlight! link DiffText MatchParen
    endif

" Config:
    set title
    set go=a
    set mouse=a
    set nohlsearch
    set clipboard+=unnamedplus
    set noshowmode
    set noruler
    set laststatus=0
    set noshowcmd
	set encoding=utf-8
	set number relativenumber
	set nocompatible
	filetype plugin on
	syntax on
    " Enable autocompletion:
	set wildmode=longest,list,full

" Tabs:
	set tabstop=4
	set shiftwidth=4
	set expandtab

" View:

nnoremap c "_c
" Perform dot commands over visual blocks:
	vnoremap . :normal .<CR>
" Goyo plugin makes text more readable when writing prose:
	map <leader>f :Goyo \| set bg=light \| set linebreak<CR>
" Splits open at the bottom and right, which isn't stuipid, unlike vim defaults.
	set splitbelow splitright

" Nerdtree:
	map <leader>n :NERDTreeToggle<CR>
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    if has('nvim')
        let NERDTreeBookmarksFile = stdpath('data') . '/NERDTreeBookmarks'
    else
        let NERDTreeBookmarksFile = '~/.vim' . '/NERDTreeBookmarks'
    endif

" vimling:
	" nm <leader><leader>d :call ToggleDeadKeys()<CR>
	" imap <leader><leader>d <esc>:call ToggleDeadKeys()<CR>a
	" nm <leader><leader>i :call ToggleIPA()<CR>
	" imap <leader><leader>i <esc>:call ToggleIPA()<CR>a
	" nm <leader><leader>q :call ToggleProse()<CR>

" Navigation:
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l
    "Use vim navigation keys for tab navigation:
	map <C-H> gt
	map <C-L> gT

" Shortcuts:
    " Spell-check set to <leader>o, 'o' for 'orthography':
        map <leader>o :setlocal spell! spelllang=en_us<CR>
    " Check file in shellcheck:
        map <leader>s :!clear && shellcheck -x %<CR>
    " Replace all is aliased to S.
        nnoremap S :%s//g<Left><Left>
    " Open corresponding .pdf/.html or preview
        map <leader>p :!opout <c-r>%<CR><CR>

" Replace ex mode with gq
	map Q gq



" Vimwiki:
	map <leader>v :VimwikiIndex<CR>

	let g:vimwiki_ext2syntax = {
\       '.Rmd': 'markdown',
\       '.rmd': 'default',
\       '.md': 'markdown',
\       '.markdown': 'default',
\       '.mdown': 'markdown'
    \ }
    let g:vimwiki_list = [{
\       'path': '~/Documents/vimwiki',
\       'syntax': 'default',
\       'ext': '.md'
    \ },{
\       'path': '~/Documents/vimwiki-wiki/wiki',
\       'path_html': '~Documents/vimwiki-wiki/docs',
\       'auto_toc': 1
    \ }]

    function VimWikiInit()
        " Smaller tabs are better for todo list nesting
        setlocal tabstop=2
        setlocal shiftwidth=2
        " Set header colors from solarized color palette
        hi VimwikiHeader1 guifg=#dc322f
        hi VimwikiHeader2 guifg=#859900
        hi VimwikiHeader3 guifg=#268bd2
        hi VimwikiHeader4 guifg=#d33682
        hi VimwikiHeader5 guifg=#2aa198
        hi VimwikiHeader6 guifg=#cb4b16
    endfunction

" Save file as sudo on files that require root permission
	cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!


" Automations:
    " Vimwiki initialization:
        autocmd FileType vimwiki call VimWikiInit()
    " Disables automatic commenting on newline:
        autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
    " Ensure files are read as what I want:
        autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
        autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
        autocmd BufRead,BufNewFile *.tex set filetype=tex

    " Enable Goyo by default for mutt writing
        autocmd BufRead,BufNewFile /tmp/neomutt* let g:goyo_width=80
        autocmd BufRead,BufNewFile /tmp/neomutt* :Goyo | set bg=light
        autocmd BufRead,BufNewFile /tmp/neomutt* map ZZ :Goyo\|x!<CR>
        autocmd BufRead,BufNewFile /tmp/neomutt* map ZQ :Goyo\|q!<CR>

    " Automatically deletes all trailing whitespace and newlines at end of file on save.
        autocmd BufWritePre * %s/\s\+$//e
        autocmd BufWritePre * %s/\n\+\%$//e
        autocmd BufWritePre *.[ch] %s/\%$/\r/e

    " Automatic recompilations / config updates:

    " When shortcut files are updated, renew bash and ranger configs with new material:
        autocmd BufWritePost bm-files,bm-dirs
            \ !shortcuts
    " Run xrdb whenever Xdefaults or Xresources are updated.
        autocmd BufRead,BufNewFile Xresources,Xdefaults,xresources,xdefaults
            \ set filetype=xdefaults
        autocmd BufWritePost Xresources,Xdefaults,xresources,xdefaults
            \ !xrdb %
    " Recompile dwmblocks on config edit.
        autocmd BufWritePost ~/.local/src/dwmblocks/config.h
            \ !cd ~/.local/src/dwmblocks/;
            \ sudo make install &&
            \ { killall -q dwmblocks;setsid -f dwmblocks }
    " Recompile lsd when icons updated
        autocmd BufWritePost ~/.local/src/lsd/src/icon.rs
            \ !cd ~/.local/src/lsd/;
            \ cargo build
    " Recompile kitty when config is updated
        autocmd BufWritePost ~/.config/kitty/kitty.conf
            \ !kill -USR1 $(pidof kitty)


" Function for toggling the bottom statusbar:
let s:hidden_all = 1
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
    endif
endfunction
nnoremap <leader>H :call ToggleHiddenAll()<CR>
