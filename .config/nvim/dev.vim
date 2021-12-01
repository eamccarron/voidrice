let mapleader = ","

" Plugins:
    if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
        echo "Downloading junegunn/vim-plug to manage plugins..."
        silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
        silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
        autocmd VimEnter * PlugInstall
    endif

    call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
    " UI:
        Plug 'vim-airline/vim-airline'
        Plug 'ryanoasis/vim-devicons'
        Plug 'airblade/vim-gitgutter'
        Plug 'jreybert/vimagit'
        Plug 'junegunn/goyo.vim'
    " Colors:
        " Plug 'morhetz/gruvbox'
        Plug 'overcache/NeoSolarized'
    " Syntax:
        Plug 'ap/vim-css-color'
        Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
        Plug 'HerringtonDarkholme/yats.vim' " TS Syntax
    " Code Editing:
        Plug 'tpope/vim-surround'
        Plug 'vimwiki/vimwiki'
        Plug 'scrooloose/nerdcommenter'
        Plug 'neoclide/coc.nvim', {'branch': 'release'}
        Plug 'Xuyuanp/nerdtree-git-plugin'
        Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
    " Navigation:
        Plug 'ctrlpvim/ctrlp.vim' " fuzzy find files
        Plug 'preservim/nerdtree'
        " Plug 'scrooloose/nerdtree'
        Plug 'tsony-tsonev/nerdtree-git-plugin'
        Plug 'christoomey/vim-tmux-navigator'
    call plug#end()

" Config:
	set encoding=utf-8
	set nocompatible
	filetype plugin on
    " Enable autocompletion:
	set wildmode=longest,list,full

" Colors:
    colorscheme NeoSolarized
	syntax on
    set termguicolors
    set background=dark
    " Turns off highlighting on the bits of code that are changed, so the line that is changed is highlighted but the actual text that has changed stands out on the line and is readable.
    if &diff
        highlight! link DiffText MatchParen
    endif

" Tabs:
	set tabstop=4
	set shiftwidth=4
	set expandtab
    set cindent

" UI:
	set number relativenumber
    set title
    set go=a
    set mouse=a
    set nohlsearch
    set noshowmode
    set laststatus=0
    set noruler
    " Goyo plugin makes text more readable when writing prose:
    map <leader>f :Goyo \| set bg=light \| set linebreak<CR>
    " Splits open at the bottom and right, which isn't stuipid, unlike vim defaults.
    set splitbelow splitright
    " Turn this on if you are a vim pro that doesn't need to see your commands
    " set noshowcmd
    " don't give |ins-completion-menu| messages.
    set shortmess+=c
    " always show signcolumns
    set signcolumn=yes

    " Highlight symbol under cursor on CursorHold
    autocmd CursorHold * silent call CocActionAsync('highlight')

" Autocomplete:
    " Use tab for trigger completion with characters ahead and navigate.
    " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
    inoremap <silent><expr> <TAB>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<TAB>" :
          \ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    " Use <c-space> to trigger completion.
    inoremap <silent><expr> <c-space> coc#refresh()

    " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
    " Coc only does snippet and additional edit on confirm.
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
    " Or use `complete_info` if your vim support it, like:
    " inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Registers:
    " This lets you paste yanked and deleted text from vim and across vim session
    set clipboard+=unnamedplus
    " Store changed text into the _ 'blackhole' register so it does not overwrite the " register
    nnoremap c "_c

    " Perform dot commands over visual blocks:
	vnoremap . :normal .<CR>

" Shortcuts:
    " Nerdtree shortcut
	map <leader>n :NERDTreeToggle<CR>
    " Spell-check set to <leader>o, 'o' for 'orthography':
    map <leader>o :setlocal spell! spelllang=en_us<CR>
    " Check file in shellcheck:
    map <leader>s :!clear && shellcheck -x %<CR>
    " Replace all is aliased to S.
    nnoremap S :%s//g<Left><Left>
    " Open corresponding .pdf/.html or preview
    map <leader>p :!opout <c-r>%<CR><CR>
    " Comment out selection
    vmap gcc <plug>NERDCommenterToggle
    nmap gcc <plug>NERDCommenterToggle
    " Use `[g` and `]g` to navigate diagnostics
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    " Remap keys for gotos
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    " Use K to show documentation in preview window
    nnoremap <silent> K :call <SID>show_documentation()<CR>

    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      else
        call CocAction('doHover')
      endif
    endfunction

    " Remap for rename current word
    nmap <F2> <Plug>(coc-rename)

    " Remap for format selected region
    xmap <leader>f  <Plug>(coc-format-selected)
    nmap <leader>f  <Plug>(coc-format-selected)

    augroup mygroup
      autocmd!
      " Setup formatexpr specified filetype(s).
      autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
      " Update signature help on jump placeholder
      autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end

    " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
    xmap <leader>a  <Plug>(coc-codeaction-selected)
    nmap <leader>a  <Plug>(coc-codeaction-selected)

    " Remap for do codeAction of current line
    nmap <leader>ac  <Plug>(coc-codeaction)
    " Fix autofix problem of current line
    nmap <leader>qf  <Plug>(coc-fix-current)

    " Create mappings for function text object, requires document symbols feature of languageserver.
    xmap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap if <Plug>(coc-funcobj-i)
    omap af <Plug>(coc-funcobj-a)

    " Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
    nmap <silent> <C-d> <Plug>(coc-range-select)
    xmap <silent> <C-d> <Plug>(coc-range-select)

    " Use `:Format` to format current buffer
    command! -nargs=0 Format :call CocAction('format')

    " Use `:Fold` to fold current buffer
    command! -nargs=? Fold :call     CocAction('fold', <f-args>)

    " use `:OR` for organize import of current buffer
    command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

    " Add status line support, for integration with other plugin, checkout `:h coc-status`
    set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

    " Using CocList
    " Show all diagnostics
    nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
    " Manage extensions
    nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
    " Show commands
    nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
    " Find symbol of current document
    nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
    " Search workspace symbols
    nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
    " Do default action for next item.
    nnoremap <silent> <space>j  :<C-u>CocNext<CR>
    " Do default action for previous item.
    nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
    " Resume latest coc list
    nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" Navigation:
    "Shortcut split navigation
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l
    "Use vim navigation keys for tab navigation:
	map <C-H> gt
	map <C-L> gT
    " Navigate virtual lines with j and k
    noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
    noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
    " Replace ex mode with gq
    map Q gq

"========================================================================================================
" Plugin / file specific config -------------------------------------------------------------------------
"========================================================================================================

" Coc:
let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-pairs',
  \ 'coc-tsserver',
  \ 'coc-eslint',
  \ 'coc-prettier',
  \ 'coc-json',
  \ ]

" Nerdtree:
    " open NERDTree automatically
    " autocmd StdinReadPre * let s:std_in=1
    " autocmd VimEnter * NERDTree

	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    if has('nvim')
        let NERDTreeBookmarksFile = stdpath('data') . '/NERDTreeBookmarks'
    else
        let NERDTreeBookmarksFile = '~/.vim' . '/NERDTreeBookmarks'
    endif
    let g:NERDTreeGitStatusWithFlags = 1
    let g:WebDevIconsUnicodeDecorateFolderNodes = 1
    let g:NERDTreeGitStatusNodeColorization = 1
    let g:NERDTreeColorMapCustom = {
        \ "Staged"    : "#0ee375",
        \ "Modified"  : "#d9bf91",
        \ "Renamed"   : "#51C9FC",
        \ "Untracked" : "#FCE77C",
        \ "Unmerged"  : "#FC51E6",
        \ "Dirty"     : "#FFBD61",
        \ "Clean"     : "#87939A",
        \ "Ignored"   : "#808080"
        \ }
    " Ignore node_modules
    let g:NERDTreeIgnore = ['^node_modules$']

    function! IsNERDTreeOpen()
      return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
    endfunction

    " Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
    " file, and we're not in vimdiff
    function! SyncTree()
      if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
        NERDTreeFind
        wincmd p
      endif
    endfunction

" Highlight currently open buffer in NERDTree
autocmd BufEnter * call SyncTree()


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
    " Always fold on syntax:
        autocmd FileType * setlocal foldmethod=syntax
    " Disables automatic commenting on newline:
        autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
    " Vimwiki initialization:
        autocmd FileType vimwiki call VimWikiInit()
    " Ensure files are read as they should be
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
