set nocompatible        " Use Vim defaults (much better!)
set background=light
set backspace=2         " allow backspacing over everything in insert mode
set autoindent          " always set autoindenting on
set smartindent
set nobackup            " Don't keep a backup file
set esckeys
set ts=4
set textwidth=75
set formatoptions=tcroql
set shiftwidth=2
set noexpandtab
syntax on
set viminfo='20,\"500
set history=1000          " keep 50 lines of command line history
set ruler               " show the cursor position all the time
set visualbell
set laststatus=2
"set hlsearch
"set incsearch
set showmatch
set noignorecase
"set list
"set lcs=tab:»·
"set lcs+=trail:·
"set lcs+=eol:$
set ttyfast
set scrolljump=5
set foldenable

" Map <CTRL>-B to run PHP parser check
noremap <C-P> :!php -l %<CR>
set dictionary-=/home/cwage/slimdotfiles/funclist.txt dictionary+=/home/cwage/slimdotfiles/funclist.txt
" Use the dictionary completion
set complete-=k complete+=k

" This function determines, wether we are on the start of the line text (then tab indents) or
" if we want to try autocompletion
function InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction

" Remap the tab key to select action with InsertTabWrapper
inoremap <tab> <c-r>=InsertTabWrapper()<cr>

autocmd BufRead *tmp/mutt* set syntax=mail
autocmd BufRead *tmp/mutt* startinsert!
autocmd BufRead *tmp/mutt* set laststatus=1
autocmd BufRead *tmp/mutt* set nohlsearch
autocmd BufRead *tmp/mutt* set expandtab
autocmd BufRead *tmp/mutt* set textwidth=72
autocmd BufRead *muttrc set syntax=muttrc
autocmd BufRead *.mutt set syntax=muttrc

autocmd BufRead *bind* set ts=2

map !t !!date
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>


autocmd BufRead *yml* set et
autocmd BufRead *yml* set sw=2
autocmd BufRead *yml* set sts=2
autocmd BufRead *yml* set smarttab
autocmd BufRead *yml* set list
"autocmd BufRead *yml* set listchars=trail:-
"autocmd BufRead *yml* set lcs=tab:»·
"autocmd BufRead *yml* set lcs+=trail:·
"autocmd BufRead *yml* set lcs+=eol:$

highlight Normal guibg=linen
set runtimepath^=~/.vim/bundle/node

set foldmarker=%%%FOLD,%%%END\ FOLD%%%
set foldmethod=marker
