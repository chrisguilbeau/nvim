" NVIM_LISTEN_ADDRESS should be 0.0.0.0:9090
" debug should listen on 0.0.0.0:9091
" zogotech vars
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 0
set guicursor=
" add in the ibeam
let g:zogotech_root = "h:/"
let g:zogotech_dev = resolve(g:zogotech_root . "dev")
let g:zogotech_prist = resolve(g:zogotech_root . "prist")
let g:zogotech_hg = resolve(g:zogotech_root . "hg")

" some important things to set up early
set clipboard=unnamed " system clipboard
nnoremap <leader>ii :edit $MYVIMRC<CR>
nnoremap <leader>ig :edit ~/.config/nvim/ginit.vim<CR>
nnoremap <leader>xi :source $MYVIMRC<CR>

" plug auto install
" set the data dir depending on the OS
if has('win32')
    let data_dir = $LOCALAPPDATA . '/nvim'
else
    let data_dir = $HOME . '/.config/nvim'
endif
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

set noshellslash
call plug#begin(data_dir . '/plugged')
Plug 'easymotion/vim-easymotion'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ap/vim-css-color'
Plug 'dense-analysis/ale'
Plug 'farmergreg/vim-lastplace'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'kshenoy/vim-signature'
Plug 'lifepillar/vim-solarized8'
Plug 'ludovicchabant/vim-lawrencium'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'mbbill/undotree'
Plug 'mhinz/vim-signify', { 'tag': 'legacy' }
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/playground'
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vimjas/vim-python-pep8-indent'
" copilot
" Plug 'zbirenbaum/copilot.lua' " not a fan
Plug 'github/copilot.vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'CopilotC-Nvim/CopilotChat.nvim'
Plug 'folke/tokyonight.nvim'
Plug 'duane9/nvim-rg'
Plug 'nuvic/flexoki-nvim'
call plug#end()

" solarized
let g:solarized_statusline = 'low'
let g:solarized_italics = 0
let g:solarized_old_cursor_style = 1
let g:solarized_extra_hi_groups = 1

" set common things
set termguicolors
set bg=light
colorscheme vim
let g:airline_theme='light'
" colorscheme solarized8
" set guifont="Comic Code:h10"
set cc=80
" common to all
set guioptions-=m        " remove menu bar
set guioptions-=T        " remove toolbar
set guioptions-=r        " remove right-hand scroll bar
set guioptions-=L        " remove left-hand scroll bar
set guioptions-=e        " no graphical tabs (so it doesn't mess with window size
hi SignColumn guibg=grey90
hi SingatureMarkText guibg=grey70
hi String guifg=indianred3
hi Visual guibg=#eadc8e
" set the tab bar colors
hi TabLineSel guibg=white guifg=black gui=bold
hi TabLine guibg=grey70 guifg=grey30 gui=None
hi TabLineFill guibg=grey90 guifg=black gui=None
" set the color column and things like that
hi ColorColumn guibg=mistyrose
" set the diff colors
hi DiffAdd ctermfg=15 guifg=NONE ctermbg=10 guibg=darkseagreen1
hi DiffChange ctermfg=15 guifg=black ctermbg=11 guibg=lightcyan1
hi DiffText ctermfg=15 guifg=black ctermbg=1 guibg=cadetblue1
hi DiffDelete ctermfg=15 guifg=NONE ctermbg=12 guibg=mistyrose

" do some extra things if in debug mode
if (v:servername == "0.0.0.0:9091")
    " turn on line and column hilighting
    set cursorlineopt=both
    set cursorline
    " turn on line numbers
    set number
endif


" vanilla vim stuff
" set shellslash
set undodir=$TEMP
set undofile

" airline
" let g:airline_theme='base16_one_light'
" let g:airline_theme='solarized'
let g:airline_extensions = ['ale']

" signify - show hg stuff in the gutter
let g:signify_disable_by_default = 1
nmap <leader>hg :SignifyToggle<cr>

" undo stuff
set undodir=$TEMP
set undofile
nmap <leader>u :UndotreeToggle<cr>

" python syntax
let g:python_highlight_all = 1

" csv
let g:csv_autocmd_arrange = 1

function! CssLint2GetCommand(buffer) abort
    return 'csslint ' . g:ale_css_csslint_options . ' %t'
endfunction

" ale
let g:ale_linters = {
            \ 'python': ['flake8'],
            \ 'javascript': ['jshint'],
            \ 'css': ['csslint2']}

let g:ale_python_flake8_executable = 'h:/src/python/python.exe'
let g:ale_python_flake8_options = '-m flake8'
" let g:ale_python_ruff_executable = 'ruff'
let g:ale_css_csslint_options =
            \'--ignore=' . join([
            \ 'ids',
            \ 'box-model',
            \ 'fallback-colors',
            \ 'overqualified-elements',
            \ 'order-alphabetical',
            \ 'adjoining-classes'
            \], ',') .
            \ ' --format=compact'
let g:ale_jshint_config_loc = g:zogotech_hg . '/cg.dotfiles/jshint.config'
let g:ale_open_list = 0
" close ale window when window is closed
augroup CloseLoclistWindowGroup
    autocmd!
    autocmd QuitPre * if empty(&buftype) | lclose | endif
augroup END
let g:ale_keep_list_window_open = 0
let g:ale_list_window_size=3
" only lint on save
let g:ale_lint_on_text_changed = 'normal'
" let g:ale_lint_on_insert_leave = 0
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'
" add some helpful keymaps
nmap ]a :ALENextWrap<cr>
nmap [a :ALEPreviousWrap<cr>

" lawrencium
nmap <leader>Hg :tabnew %<cr>:Hgvdiff<cr><c-w><c-r>

" yankstack
call yankstack#setup()
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste

" context
let g:context_enabled = 0

" diff
set diffopt+=context:9999

function! DirDiffDone(...)
    execute 'setlocal cursorline'
    execute 'on'
    hi DiffAdd ctermfg=15 guifg=NONE ctermbg=10 guibg=darkseagreen1
    hi DiffChange ctermfg=15 guifg=black ctermbg=11 guibg=lightcyan1
    hi DiffText ctermfg=15 guifg=black ctermbg=1 guibg=cadetblue1
    hi DiffDelete ctermfg=15 guifg=NONE ctermbg=12 guibg=mistyrose
    nmap <buffer> <return> :call DirDiffEnter()<cr>
endfunc

function! DirDiffEnter()
    let parts = split(getline('.'))
    if parts[0] == 'Only'
        exec 'windo diffoff'
        exec 'on'
        exec 'spl'
        exec 'wincmd b'
        exec 'resize ' . string(min([line('$') + 1, 10]))
        exec 'wincmd t'
        exec 'e ' . parts[2][0:len(parts[2]) - 2] . '/' . parts[3]
        return
    endif
    if parts[0] != 'Files'
        echo 'Not diffable!'
        return
    endif
    " get the filenames to diff
    let left = parts[1]
    let right = parts[3]
    " clean diffs
    exec 'windo diffoff'
    " make sure I'm the only window
    exec 'on'
    " set up the window into three panes
    exec 'spl'
    exec 'wincmd b'
    exec 'resize ' . string(min([line('$') + 1, 10]))
    exec 'wincmd t'
    exec 'vspl'
    " open the files
    exec 'edit ' . left
    exec 'setlocal readonly'
    exec 'diffthis'
    exec 'setlocal nofoldenable'
    exec 'setlocal foldcolumn=0'
    exec 'set signcolumn=no'
    exec 'wincmd l'
    exec 'edit ' . right
    exec 'diffthis'
    exec 'setlocal nofoldenable'
    exec 'setlocal foldcolumn=0'
    exec 'normal! gg'
    exec 'set signcolumn=no'
    " diff the files!
endfunc

function! Zdiff()
    try
        let prist = g:zogotech_prist
        let src = g:zogotech_dev
        let left = input("left: ", prist, "dir")
        if len(left) == 0
            echo 'Cancelled!'
            return
        endif
        let right = input("left: " . left . " right: ", src, "dir")
        if len(right) == 0
            echo 'Cancelled!'
            return
        endif
        execute 'tabnew'
        execute 'set nowrap'
        let zdiff = "diff -rq --exclude=nvim-undo --exclude=vim-undo --exclude=etags --exclude=.hg --exclude=*.pyc --exclude=__pycache__ --exclude=*.swp --exclude=zebra --exclude=etags2 --exclude=tags --exclude=files --exclude=commit "
        let cmd = zdiff . left . ' ' . right
        put = system(cmd)
        execute '1delete'
        exec 'setlocal nomod'
        exec 'setlocal noma'
        call DirDiffDone()
    catch
        echo 'ERROR: ' . v:exception
    endtry
endfunc

" FZF
" let $FZF_DEFAULT_COMMAND = 'rg --files --follow --path-separator / '
let $FZF_DEFAULT_COMMAND = 'fd -t=f .'
let $FZF_DEFAULT_OPTS = '--color=bw --ansi'
let g:fzf_layout = { 'down': '50%' }
let g:fzf_preview_window = []
" let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
function! FzfInsert(line)
    put =a:line
endfunction
function! FzfGetRegisters() abort
  redir => l:regs
  silent registers
  redir END
  return split(l:regs, '\n')[1:]
endfunction
command! FzfReg call fzf#run({
            \  'source':  FzfGetRegisters(),
            \  'sink':    function('FzfInsert'),
            \  'options': '-s',
            \  'down':    '40%'})
" command! -bang -nargs=? -complete=dir Files
"             \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', 'bat {}']}, <bang>0)

function! ZimportSink(line)
    put! =a:line
    normal \si
endfunction

command! Zimport call fzf#run({
            \  'source':  "rg --follow -I \"^from\\s+\\S+\\s+import\\s+\\S+.*$\" |tr -s \" \" | sort | uniq",
            \  'sink':    function('ZimportSink'),
            \  'options': '-s',
            \  'down':    '40%'})

command! Pyimport call fzf#run({
            \  'source':  "rg --follow -I \"^from\\s+\\S+\\s+import\\s+\\S+.*$\" |tr -s \" \" | sort | uniq",
            \  'sink':    function('FzfInsert'),
            \  'options': '-s',
            \  'down':    '40%'})

function! Zinit()
    let g:zogotech_undo = g:zogotech_dev . "/nvim-undo"
    let g:zogotech_tags = g:zogotech_dev . "/tags"
    " expand the path to resolve the junction in winders
    " get output of the command "z_get_proj"
    let proj = escape(trim(system('z_get_proj')), ' ')
    exec 'set title'
    exec 'set titlestring=' . proj
    exec "cd " . g:zogotech_dev
    let g:my_files_cmd = 'cd c:/ZogoTech/dev && rg --files --follow --path-separator / -tpy -tjs -tcss appserver server webserver support'
    let g:zogotech_rg_command = 'rg --files --follow --path-separator / --type-add "pyc:*.pyc" -Tpyc appserver server webserver support'
    " let $FZF_DEFAULT_COMMAND = g:zogotech_rg_command
    let $FZF_DEFAULT_COMMAND = 'fd -t=f -epy -ejs -ecss -etxt --path-separator / .'
    " setup undo directory
    if !isdirectory(g:zogotech_undo)
        call mkdir(g:zogotech_undo, "", 0700)
    endif
    execute 'set undodir=' . g:zogotech_undo
    set undofile
    execute 'set tags=' . g:zogotech_tags
    nmap <leader>zi :Zimport<cr>
    if empty(glob("tags"))
        echo "Creating initial tags file..."
        execute "normal " . '\' . "xt"
    endif
    let g:copilot_workspace_folders = [g:zogotech_dev . '/appserver', g:zogotech_dev . '/server', g:zogotech_dev . '/webserver', g:zogotech_dev . '/support']
    exec "TSContextDisable"
    echo "The Z has been initted."
    nmap <leader>xt :!ctags -R --exclude="*.min.js" --exclude=.hg --tag-relative=always appserver server webserver support<cr>
endfunction

" Vanilla vim below this line
syntax on
filetype plugin on    " make commands smarter for your file ]m
filetype indent on
set clipboard=unnamed " system clipboard
set noto              " wait forever for leader sequences
set showcmd           " show command as you type it
" set nowmnu            " don't show popup menu
set incsearch         " jump to first match when searching
set nofoldenable
set ignorecase
set backspace=2
set tags=tags  " look for a tags file all the way up till the root
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set autoread          " automatically read files when changed by another editor
set hidden            " just hide the buffer till I come back to it
set shellslash        " use forward slashes in paths on windows
set encoding=utf-8
set formatoptions+=l  " dont ever wrap lines
set formatoptions+=j  " Delete comment character when joining commented lines
set signcolumn=yes:1
set linespace=1
set noswapfile
set showtabline=2
" set scrolloff=4
set path+=**
" Disable wildmenu to use the popup menu instead
" set completeopt=menuone,noinsert,noselect
set wildmenu
set wildignore+=*.pyc
set wildoptions+=pum,fuzzy
" set wildmode=longest:full,full
" set wildmode=list:longest,list:full
" set complete=.,w,b,u ",t,i
" set completeopt=
" set nowildmenu
" set wildmode=longest:full,full
set laststatus=2
set list
" set diffopt+=iwhite " DANGEROUS

" copilot config
" let g:copilot_filetypes = {'*': v:true}
" imap <c-space> <Plug>(copilot-complete)

" mercurial
autocmd FileType hgcommit setlocal spell

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
autocmd BufWritePre * :call TrimWhitespace()

fun! Blame_()
    " new tab based on this file
    exec 'tabnew +' . (line('.') + 1) . ' %'
    exec 'redraw!'
    exec 'echo "Please wait while blaming..."'
    exec 'Hgannotate'
    exec 'wincmd w'
endfun

function! GetVisSel()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

fun! Zkill()
    " kill the hilighted text
    let vissel = GetVisSel()
    let query = vissel
    let query = substitute(query, '\\', '\\\\', 'g')
    let query = substitute(query, '\[', '\\[', 'g')
    let query = substitute(query, '\]', '\\]', 'g')
    let query = substitute(query, '\n', '\\n', 'g')
    let query = substitute(query, '/', '\\/', 'g')
    let query = substitute(query, '*', '\\*', 'g')
    let query = substitute(query, '[0-9]\+', '[0-9]\\+', 'g')
    let query = substitute(query, 'ALVIN2', '.*', 'g')
    call feedkeys(':%s/' . query . '//gc')
endfunction

command Blame call Blame_()

augroup autoquickfix
    autocmd!
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost    l* lwindow
augroup END

" turn on spelling for commit messages
autocmd FileType hgcommit setlocal spell

" python specific
au FileType python setlocal cc=79
au FileType python setlocal iskeyword+=\-
au FileType python match Error /\t/
au FileType python setlocal shiftwidth=4
au FileType python setlocal tabstop=4
au FileType python setlocal expandtab

" autocmd FileType python set equalprg=autopep8\ -
" au FileType python setlocal equalprg=yapf
au FileType python vnoremap <leader>= :call FormatWithYapf()<cr>
au FileType python vnoremap <leader>wc <esc>:set textwidth=79<cr>gvgq<esc>:set textwidth=0<cr>gv
au FileType python vnoremap <leader>wt <esc>:set textwidth=72<cr>gvgq<esc>:set textwidth=0<cr>gv
au FileType python nmap <leader>; Obreakpoint();<esc>

let $PYTHONUNBUFFERED = 1
let $PYTHONPATH = 'c:/Python'

" json specific
au FileType json nnoremap <leader>= :%!python -m json.tool<cr>

" javascript specific
au BufNewFile,BufRead *.js setlocal iskeyword+=\-

" css specific
au BufNewFile,BufRead *.css setlocal iskeyword+=\-

" python indent
let python_pep8_indent_hang_closing = 1
let g:python_pep8_indent_multiline_string = -2

" grep
set grepprg=rg\ --vimgrep\ --follow
set grepformat=%f:%l:%c:%m

" netrw
let g:netrw_banner = 0
let g:netrw_browse_split = 4
" let g:netrw_preview =
let g:netrw_preview   = 1
let g:netrw_liststyle = 3
" let g:netrw_winsize   = 30

" disable things I hit sometimes...
vnoremap <s-down> <nop>
vnoremap <s-up> <nop>
inoremap <s-down> <nop>
inoremap <s-up> <nop>
nmap Q <nop>
nnoremap ]d <NOP>
nnoremap [d <NOP>
" some remaps for those
xnoremap <s-down> :m '>+1<CR>gv=gv
xnoremap <s-up> :m '<-2<CR>gv=gv

" Move selected lines up
xnoremap <A-k> :m '<-2<CR>gv=gv

function! Resize()
    " 2. Count the windows
    let wcount = winnr('$')
    " 3. Move to the top-left window
    wincmd t
    " 4. Resize all but the last window to 80 columns
    " range(1, wcount) goes from 1 to wcount-1, because the last number
    " is exclusive
    for i in range(1, wcount)
        vertical resize 90
        if i < wcount - 1
            " Move to the next window
            wincmd w
        endif
    endfor
endfunction

function! KillCurrentWindow()
    close
    call Resize()
endfunction

function! VerticalSplitAndResize()
    "0. remember current window number
    let l:current_window = winnr()
    " 1. Perform a vertical split
    vsplit
    " call Resize
    call Resize()
    " 5. Move cursor to the far right window
    " Go to top-left window first
    wincmd t
    " move to the window remembered
    exe l:current_window . "wincmd w"
    " Move right one window
    wincmd l
endfunction

" remaps
" nmap <leader>e :e **/
nmap <leader>G :grep <Space>
nmap <leader>g yiw:grep "<Space>
nmap <leader>r :vimgrep // **<left><left><left><left>
nmap [q :cprev<cr>
nmap ]q :cnext<cr>
nmap <leader>! :Excursion<cr>
nmap <leader>xe :execute getline(".")<cr>
nmap <leader>f :vimgrep /\s*\<\(def\\|class\)\>/ %<cr>
nmap <leader>h :set hlsearch! hlsearch?<CR>
nmap <leader>n :set number!<cr>
nmap <leader>N :set rnu!<cr>
nmap <leader>r yiw:,$s/"//gc<left><left><left>
vmap <leader>r y:,$s/"//gc<left><left><left>
nmap <leader>R yiw:,$s/\<"\>//gc<left><left><left>
vmap <leader>R y:,$s/\<"\>//gc<left><left><left>
" nmap <leader>v <c-w>v<c-w>w
nmap <leader>v :call VerticalSplitAndResize()<cr>
nmap <leader>q :call KillCurrentWindow()<cr>
nmap <leader>i :e $MYVIMRC<cr>
nmap <leader>l :set list! list?<cr>
nmap <leader>xi :so $MYVIMRC<cr>
nmap <leader>xt :!ctags -R --tag-relative=always<cr>
nmap <leader>si (V):EasyAlign /\<import\>/<cr>gvk:sort i<cr>}
nmap <leader>zz :call Zinit()<cr>
nmap <leader>zc :call Zdiff()<cr>
nmap <leader>zr :tabnew w:/cg/regression-output<cr>
" nmap <leader>zr :tabnew \\regr3.ztaustin.local\home\cg\regression-output<cr>
" nmap <leader>gc :CopilotChatToggle<cr>
" nmap <leader>gC :CopilotChatToggle<cr>
" nmap <leader>m mA
" nmap <leader>M `A
nmap <leader>c :TSContextToggle<cr>

function! s:MyBTagsSink(line)
    echo a:line
    let firstPart = split(a:line, ';"')[0]
    let parts = split(firstPart)
    let lino = parts[len(parts) - 1]
    execute lino
endfunc

function! s:MyBTags()
    let currentBufferFilePath = expand('%:p')
    let cmd = 'ctags -f- --excmd=number c\nar.py ' .
                \currentBufferFilePath
    call fzf#run({'source': cmd, 'sink': function('s:MyBTagsSink'), 'down': '10', 'options': '--color=bw'})
endfunc

command! MyBTags call s:MyBTags()

function! s:MyTagsSink(line)
    echo a:line
    " Split the line at ';"' and take the first part
    let firstPart = split(a:line, ';"')[0]
    " Split the first part by whitespace
    let parts = split(firstPart)
    " Extract the file name and line number
    let filename = parts[1]
    let lineno = parts[2]
    " Open the file
    execute 'edit' filename
    " Go to the specific line number
    execute lineno
endfunction

function! s:MyTags()
    let cmd = 'ctags -Rf- --exclude=*.min.js --exclude=3p --excmd=number . 2>nul'
    call fzf#run({'source': cmd, 'sink': function('s:MyTagsSink'), 'down': '10', 'options': '--color=bw'})
endfunc

command! MyTags call s:MyTags()

let g:my_files_cmd = 'rg --path-separator / .'

function! s:MyFiles()
    call fzf#run({'source': g:my_files_cmd, 'sink': 'edit', 'down': '10'})
endfunc

command! MyFiles call s:MyFiles()

nmap <silent><leader>t <C-w><C-]><C-w><S-t>
nmap [<tab> :tabp<cr>
nmap ]<tab> :tabn<cr>
nmap <leader><tab> :tabcl<cr>
vmap <leader>zk call Zkill()<cr>
" nmap <leader>e :Telescope find_files<cr>
" nmap <leader>b :Telescope buffers<cr>
" nmap <leader>o :Telescope oldfiles<cr>
nmap <leader>e :MyFiles<cr>
nmap <leader>b :MyBTags<cr>
nmap <leader>t :MyTags<cr>
" nmap <leader>m :Marks<cr>
" shortcut to get back to mark
nmap M '
nmap <leader>Q :on<cr>
nmap <leader>o :History<cr>
nnoremap <s-up> O
nnoremap <s-down> o
nmap <leader>T :TagbarToggle<cr>


function! Killit() range
    " get the original list of lines to process
    let _lines = getline(a:firstline, a:lastline)
    " prompt for a sitename to ignore
    let site_name = input('Enter the site name: ', 'ALVIN2')
    " create a list of processed lines
    let lines = []
    " process each line
    for line in _lines
        " escape all the chars that might be interpereted at regexps
        let line = escape(line, '\/.*$^~[]')
        " ignore sitename
        let line = substitute(line, site_name, '.*', 'g')
        " ignore numbers
        let line = substitute(line, '[0-9]\+', '.*', 'g')
        " add to list of processed lines
        call add(lines, line)
    endfor
    " join all back together with newlines
    let selected_text = join(lines, '\n')
    " echo '%s/' . selected_text . '//gc'
    " run the sub command
    execute '%s/' . selected_text . '//gc'
endfunction

command! -range -nargs=0 Killit :<line1>,<line2>call Killit()

function! Popqf_()
  " Prompt the user for the shell command to run
  let user_command = input('Enter the command to run: ')

  " Set the local errorformat and makeprg options
  setlocal errorformat=%f:%l:%c:%m
  let &l:makeprg = user_command

  " Execute the command and populate the quickfix list
  silent make!

  " Open the quickfix window
  copen
endfunction

command! Popqf call Popqf_()

set t_ve=
set t_vi=

" yapf stuff
function! FormatWithYapf() range
    execute a:firstline . "," . a:lastline . "!pyyapf.py"
endfunction

" emacs stuff
function! _OpenEmacs()
    let l:filename = expand('%:p')  " Get full path to the current file
    let l:linenumber = line('.')   " Get current line number

    " Construct the command to open the file in Emacs at the given line number
    let l:cmd = 'start /B emacs' . ' +' . l:linenumber . ' ' . l:filename

    " Execute the command
    silent! execute '!' . l:cmd
endfunction

command! OpenEmacs call _OpenEmacs()

" excursion
function! _Excursion()
    " Get the current file path
    let current_file = expand('%:p')
    " Get the current cursor line and column
    let line = line('.')
    let col = col('.')
    " Open the current file in a new gvim instance at the same line and column
    " Adjusting the command for Windows Command Prompt's syntax
    let command = 'start nvim ' . current_file . ' +"call cursor(' . line . ', ' . col . ')"' . ' +"call Zinit()"'
    exec "!" . command
endfunction

command! Excursion call _Excursion()

function! OpenFileUnderCursorAtLine()
    " Get the current line
    let line = getline('.')

    " Use a regular expression to extract the file path and line number
    if match(line, '\v\w\:\\') >= 0 " Check if the line matches the Windows path format
        let parts = matchlist(line, '\v^(\S+):(\d+):')
    else
        echo "Not a valid file path"
        return
    endif

    " Check if we successfully extracted the file path and line number
    if len(parts) >= 3
        let filepath = parts[1]
        let linenumber = parts[2]
        " Open the file
        execute 'edit +' . linenumber . ' ' . fnameescape(filepath)
    else
        echo "Failed to parse the file path and line number"
    endif
endfunction

" Map gf to call the custom function
" nnoremap <leader>gf :call OpenFileUnderCursorAtLine()<CR>

" vs code
function! _OpenVSCode()
    let l:filename = expand('%:p')   " Get full path to the current file
    let l:linenumber = line('.')     " Get current line number
    let l:columNumber = col('.')     " Get current column number

    " Construct the command to open the file in VSCode at the given line and column
    let l:cmd = 'start /B code -g ' . l:filename . ':' . l:linenumber . ':' . l:columNumber

    " Execute the command
    silent! execute '!' . l:cmd
endfunction

command! OpenVSCode call _OpenVSCode()

" set ft=hgcommit when opening a file called commit
autocmd BufNewFile,BufRead commit set ft=hgcommit

" neovide
if exists("g:neovide")
    set guifont=Comic\ Code:h11
    let g:neovide_cursor_animation_length = 0
    let g:neovide_floating_shadow = v:false
endif

" lua config below
lua << EOF
require("nvim-treesitter.configs").setup({
highlight = {
    enable = true, -- Enable syntax highlighting
},
indent = {
    enable = true, -- Enable tree-sitter indent
    disable = {"python"}, -- Disable tree-sitter indent for python
},
})
require'treesitter-context'.setup{
enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
multiwindow = false, -- Enable multiwindow support.
max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
line_numbers = true,
multiline_threshold = 20, -- Maximum number of lines to show for a single context
trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
mode = 'topline',  -- Line used to calculate context. Choices: 'cursor', 'topline'
-- Separator between context and content. Should be a single character string, like '-'.
-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
separator = nil,
zindex = 20, -- The Z-index of the context window
on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
}
-- LLM Setup
require("CopilotChat").setup {
    model = 'claude-3.7-sonnet',
}
EOF
