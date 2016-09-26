"Auto reload vimrc
augroup reloadvimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }

"KEY MAPPINGS
"Leader Key
let mapleader=","
"Use Tab to switch windows
map <Tab> <C-W>w
"Use leader key + ee to edit vimrc
nnoremap <silent> <leader>ee :e $MYVIMRC<CR>
"Use leader key + ev to edit vimrc by splitting into a new window vertically
nnoremap <silent> <leader>ev :vsplit $MYVIMRC<CR>
"Use leader key + b to build ctags then set to update tag list automatically after each saving, assume that ctags has been installed into OS and .ctags file exists in Home directory
nnoremap <silent> <leader>b :!ctags<CR><CR> <bar> :autocmd BufWritePost * call system("ctags")<CR>
"Use // to search for visually selected text
vnoremap // y/<C-R>"<CR>
"Use SPACE to open a fold at the cursor in normal mode
nnoremap <space> zo
"Use leader key + SPACE to open all fold in normal mode
nnoremap <leader><space> zR
"Use leader key + w to close one tab
nnoremap <leader>w :tabc<CR>
"Use . to delete without cutting or copying (save to the black hole sregister)
noremap . "_d
"Use C-h and C-l to move to the left and right
nnoremap <c-h> 20h
nnoremap <c-l> 20l
"Move cursor in Insert mode
inoremap <c-h> <left>
inoremap <c-l> <right>
"Use leader key + p or P to paste from system clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P

"Vim SETTINGS
set hlsearch "Set highlight searching
set number relativenumber "Vim starts with line numbers and relative number enabling
set numberwidth=4 "Setting number of spaces between line numbers and codes
set autoindent
set tabstop=4 "Setting tab width
set shiftwidth=4 "Setting indent
set statusline+=%F "Setting visible status line
set expandtab "Using spaces instead of tab
set ttyfast "make vim scrolls more smoothly, assume fast connection
set ttyscroll=0 "don't know why but this make smooth scroll much better when scroll down (no ghost cursor lines when scrolling down from the last line; no delay cursorline when scrolling down from somewhere in the middle. This will disable scrolling when set mouse=a
set mouse=a "enable using the mouse
set backspace=indent,eol,start "allow backspacing everything in insert mode
" set foldmethod=marker "enable folding triggered by markers (the {{{ things)
syntax on
set fillchars=vert:\│ "continuous vertical split line
set cursorline "highlight cursor line to easily spot the cursor
set viminfo+=n~/.vim/viminfo "specify the place of viminfo
set noshowmode "show mode using only airline, no need to show below it

"PLUGGINS using Vim-plug
call plug#begin('~/.vim/plugged') "Pluggins START


Plug 'scrooloose/nerdtree' "Directory tree of projects
"Use F4 for NERDTree toggling
nnoremap <F4> :NERDTreeToggle<CR>
let g:NERDTreeWinSize = 30 "Set NERDTree sidebar width
autocmd VimEnter * NERDTree "Open NERDTree at startup
" autocmd VimEnter * wincmd p "Move cursor to main window when at opening


Plug 'majutsushi/tagbar' "Show functions, variables, etc. of a file
"Use F3 for Tagbar opening
nnoremap <F3> :TagbarToggle<CR>
" let g:tagbar_width = 35


Plug 'haya14busa/incsearch.vim' "Searching
" auto disable highlight after searching (by moving cursor)
let g:incsearch#auto_nohlsearch = 1
" If cursor is in first or last line of window, scroll to middle line.
function! s:MaybeMiddle()
    let l:range=2
    if winline() < 1 + l:range || winline() > winheight(0) - l:range
        normal! zz
    endif
endfunction
map <silent> n  <Plug>(incsearch-nohl-n):call <SID>MaybeMiddle()<CR>
map <silent> N  <Plug>(incsearch-nohl-N):call <SID>MaybeMiddle()<CR>
" add N for disabling moving cursor
map *  <Plug>(incsearch-nohl-*)N
map #  <Plug>(incsearch-nohl-#)N
map g* <Plug>(incsearch-nohl-g*)N
map g# <Plug>(incsearch-nohl-g#)N

let s:center_module = {"name": "Center"}

function! s:center_module.priority(event) abort
    return a:event is# "on_char" ? 999 : 0
endfunction

function! s:center_module.on_leave(cmdline) abort
    if exists("s:center_on_leave_flag")
        unlet s:center_on_leave_flag
        normal! zz
    endif
endfunction

function! s:center_module.on_char_pre(cmdline) abort
    if a:cmdline.is_input("<Over>(center)")
        call a:cmdline.setchar("")
    endif
endfunction

function! s:center_module.on_char(cmdline) abort
    if a:cmdline.is_input("<Over>(center)")
        normal! zz
        let s:center_on_leave_flag = 1
    endif
endfunction

function! s:config_center(...) abort
    return extend(copy({
                \   "modules": [s:center_module],
                \   "keymap": {
                \       "\<Tab>": {
                \           "key": "<Over>(incsearch-next)<Over>(center)",
                \           "noremap": 1
                \       },
                \       "\<S-Tab>": {
                \           "key": "<Over>(incsearch-prev)<Over>(center)",
                \           "noremap": 1
                \       }
                \   },
                \   "is_expr": 0
                \ }), get(a:, 1, {}))
endfunction

noremap <silent><expr> / incsearch#go(<SID>config_center({"command": "/"}))
noremap <silent><expr> ? incsearch#go(<SID>config_center({"command": "?"}))
noremap <silent><expr> g/ incsearch#go(<SID>config_center({"command": "/", "is_stay": 1}))


Plug 'chiel92/vim-autoformat' "Autoformat code: indentation, etc.
"Use F5 for autoformat
noremap <F5> :Autoformat<CR>


" Plug 'valloric/youcompleteme', { 'on': [], 'do': './install.py' } "Autocompletion
Plug 'valloric/youcompleteme' "Autocompletion
let g:ycm_key_list_select_completion=['<C-j>', '<Down>']
let g:ycm_key_list_previous_completion=['<C-k>', '<Up>']


Plug 'tomtom/tcomment_vim' "Used to comment code


Plug 'terryma/vim-smooth-scroll' "Used to move in a file easily
nnoremap <silent> <c-p> :call smooth_scroll#up(&scroll/2   ,20 ,1)<CR>
nnoremap <silent> <c-n> :call smooth_scroll#down(&scroll/2 ,20 ,1)<CR>
nnoremap <silent> <c-u> :call smooth_scroll#up(&scroll     ,20 ,2)<CR>
nnoremap <silent> <c-d> :call smooth_scroll#down(&scroll   ,20 ,2)<CR>
nnoremap <silent> <c-b> :call smooth_scroll#up(&scroll*2   ,20 ,2)<CR>
nnoremap <silent> <c-f> :call smooth_scroll#down(&scroll*2 ,20 ,2)<CR>


Plug 'sjl/gundo.vim' "Undo history
let g:gundo_right = 1 "move the tree to the right
nnoremap <F2> :GundoToggle<CR>


Plug 'SirVer/ultisnips' "Forming funtion syntax: name, parentheses, indentation, etc.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"


Plug 'honza/vim-snippets' "Give SilVer/ultiships database to process

Plug 'jszakmeister/vim-togglecursor' "toggle cursor shape in insert mode, but only useful in some terminals
let g:togglecursor_leave = "line"
let g:togglecursor_force = "cursorshape" "Assume the terminal is Konsole


Plug 'klen/python-mode' "More differentiate colors between portions of code
let g:pymode_folding = 0
let g:pymode_lint_on_write = 0
let g:pymode_rope = 0
let g:pymode_options = 0

Plug 'tpope/vim-fugitive' "show git branches on airline

Plug 'jiangmiao/auto-pairs' "auto brackets
let g:AutoPairsMapCh = 0 "unmap <C-h> to delete brackets, quotes in pair

Plug 'haitran14/vim-airline'
let g:airline_themes='solarized'
let g:airline_powerline_fonts = 1 "enable powerline fonts
let g:airline#extensions#tabline#enabled = 1 "display tabline
" let g:airline#extensions#tabline#show_tabs = 1 "enable/disable displaying tabs, regardless of number
let g:airline#extensions#tabline#tab_min_count = 2 "only show tab line when there is >=2 tabs
let g:airline#extensions#tabline#tab_nr_type = 1 "show only tab number
let g:airline#extensions#tabline#show_tab_nr = 1 "enable displaying tab number
let g:airline#extensions#tabline#show_tab_type = 1 "show whether this tab is 'tabs' or 'buffer'
let g:airline#extensions#tabline#show_close_button = 0 "hide close button (X) of one opened tab in the tabline
let g:airline#extensions#tabline#fnamemod = ':t' "show only filename and hide path in tab name
let g:airline#extensions#tabline#formatter = 'unique_tail_improved' "show path when tabs have identical file name
let g:airline#extensions#tabline#show_buffers = 0 "hide buffers to activate tabline formatter right above
" let g:airline#extensions#tabline#left_sep = ' ' "set straight tab
" let g:airline#extensions#tabline#left_alt_sep = '|' "put '|' character between straight tabs on tabline
" let g:airline#extensions#tagbar#enabled = 0 "hide function name on airline, to save performance
let g:airline#extensions#branch#enabled = 1 "display git branch
" let g:airline#extensions#branch#displayed_head_limit = 10 "truncate long branch names to a fixed length
" let g:airline#extensions#branch#format = 2 "truncate all path sections but the last one
let g:airline#extensions#whitespace#enabled = 1 "enable detection of whitespace errors
let g:airline#extensions#whitespace#checks = [ 'indent', 'trailing', 'mixed-indent-file' ] "specify which whitespace types to check for errors
let g:airline#extensions#whitespace#show_message = 1 "show messages when whitespace errors occur
let g:airline#extensions#whitespace#mixed_indent_algo = 0 "must be all spaces or all tabs before the first non-whitespace character
let g:airline#extensions#ycm#enabled = 1 "enable ycm integration


Plug 'haitran14/vim-colors-solarized'
syntax enable
set background=dark
let &t_Co=16
let g:solarized_termcolors=16
nnoremap <silent> <F12> :let &background = (&background == "dark"? "light" : "dark")<CR>


call plug#end() "Pluggins END

colorscheme solarized
