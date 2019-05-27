"-----Vim-Plug start -----
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')
" Make sure you use single quotes

Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'vim-scripts/winmanager'

Plug 'vim-scripts/taglist.vim'
Plug 'vim-scripts/a.vim'
Plug 'kien/ctrlp.vim'
Plug 'vim-scripts/OmniCppComplete'
Plug 'moll/vim-bbye'

Plug 'ludovicchabant/vim-gutentags'
Plug 'skywind3000/asyncrun.vim'
Plug 'w0rp/ale'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'octol/vim-cpp-enhanced-highlight'
" Initialize plugin system
call plug#end()
" --------------------------------------

" === Plug Setting ===
" --- octol/vim-cpp-enhanced-highlight
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_simple_template_highlight = 1
let g:cpp_experimental_template_highlight = 1
let g:cpp_concepts_highlight = 1
let g:cpp_no_function_highlight = 1

" --- ale setting ---
let g:ale_sign_column_always = 1
let g:ale_linters = {
\   'c': ['clang'],
\   'cpp': ['clang'],
\}
let g:ale_statusline_format = ['E:%d', 'W:%d', 'ok']
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_lint_on_enter = 1
let g:ale_set_signs = 1
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚡'
autocmd VimEnter,Colorscheme * :hi ALEErrorSign     cterm=bold ctermfg=160
autocmd VimEnter,Colorscheme * :hi ALEWarningSign   cterm=bold ctermfg=166
autocmd VimEnter,Colorscheme * :hi ALEErrorLine     cterm=NONE ctermfg=251 ctermbg=160
autocmd VimEnter,Colorscheme * :hi ALEError         cterm=NONE ctermfg=251 ctermbg=160
autocmd VimEnter,Colorscheme * :hi ALEWarning       cterm=NONE ctermfg=251 ctermbg=166i
let g:airline#extensions#ale#enabled = 1
let airline#extensions#ale#error_symbol = 'E'
let airline#extensions#ale#warning_symbol = 'W'
let g:ale_c_build_dir = "./build"
let g:ale_c_parse_makefile = 1
let g:ale_cpp_gcc_options = '-std=c++11 -I/usr/local/net-snmp/include -I/usr/local/include -I/usr/include -I/usr/include/x86_64-linux-gnu'
let g:ale_cpp_clang_options = '-std=c++11 -I/usr/local/net-snmp/include -I/usr/local/include -I/usr/include -I/usr/include/x86_64-linux-gnu'
let g:ale_c_clang_options = '-I/usr/local/net-snmp/include -I/usr/local/include -I/usr/include -I/usr/include/x86_64-linux-gnu'
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" --- gutentas ---
set tags=./.tags;,.tags;~/.cache/tags

" gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']

" 所生成的数据文件的名称
let g:gutentags_ctags_tagfile = '.tags'

" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags

" 配置 ctags 的参数
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q /usr/local/net-snmp/include']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

" 检测 ~/.cache/tags 不存在就新建
if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
endif

" --- AsyncRun ----
" F4：使用 cmake 生成 Makefile
" F5：单文件：运行
" F6：项目：测试
" F7：项目：编译
" F8：项目：运行
" F9：单文件：编译
" F10：打开/关闭底部的 quickfix 窗口
" nnoremap <silent> <F4> :AsyncRun -cwd=<root> cmake . <cr>
"nnoremap <silent> <F5> :AsyncRun -cwd=$(VIM_FILEDIR) -mode=4 "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" <cr>
"nnoremap <silent> <F6> :AsyncRun -cwd=<root> -raw make test <cr>
nnoremap <silent> <F6> :AsyncRun -cwd=<root> -mode make tags <cr>
nnoremap <silent> <F7> :AsyncRun -cwd=<root> make <cr>
nnoremap <silent> <F8> :AsyncRun -cwd=<root> -mode=4 make run <cr>
nnoremap <silent> <F9> :AsyncRun gcc -Wall -O2 "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" <cr>
nnoremap <F10> :call asyncrun#quickfix_toggle(6)<cr>

" 自动打开 quickfix window ，高度为 6
let g:asyncrun_open = 6

" 任务结束时候响铃提醒
let g:asyncrun_bell = 1

" --- WinManager --- 
" NERD_Tree集成到WinManager
let g:NERDTree_title="[NERDTree]" 
function! NERDTree_Start()
    exec 'NERDTree'
endfunction
 
function! NERDTree_IsValid()
    return 1
endfunction
 
" 键盘映射，同时加入防止因winmanager和nerdtree冲突而导致空白页的语句
nmap wm :if IsWinManagerVisible() <BAR> WMToggle<CR> <BAR> else <BAR> WMToggle<CR>:q<CR> endif <CR><CR>
" 设置winmanager的宽度，默认为25
let g:winManagerWidth=30 
" 窗口布局
let g:winManagerWindowLayout='NERDTree|TagList'
" 如果所有编辑文件都关闭了，退出vim
let g:persistentBehaviour=0
let g:AutoOpenWinManager=1

" === Vim Normal Setting ===
"--------------
"" Color Scheme
"--------------
syntax enable
"set background=dark
"let g:solarized_termcolors=256
"colorscheme twilight-bright
 
 
"----------------
"" 編輯器基本設定
"----------------
 
" 默認顯示行號
set nu
 
" 設置（軟）製表符寬度為4：
set tabstop=4
set softtabstop=4
 
" 設置自動縮進：即每行的縮進值與上一行相等；使用 noautoindent 取消設置：
set autoindent
 
" 設置（自動）縮進的空格數為4
set shiftwidth=4
 
" 設置 使用 C/C++ 語言的自動縮進方式：
set cindent
 
" 智能縮進
set smartindent
 
"在狀態欄顯示正在輸入的命令
set showcmd
 
"為方便複製，用<F2>開啟/關閉行號顯示:
nnoremap <F2> :set nonumber!<CR>
map <F3> :NERDTreeMirror<CR>
map <F3> :NERDTreeToggle<CR>
nnoremap <C-F11> :10winc < <CR>
nnoremap <C-F12> :10winc > <CR>

"搜索的時候即時顯示結果
set incsearch
 
" 高亮搜索結果
set hlsearch
 
" 禁止循環查找
set nowrapscan
 
"  設置匹配模式，顯示匹配的括號
set showmatch
 
" 智能補全
set completeopt=longest,menu
 
" 設置歷史記錄為100條
set history=100
 
" 標尺，用於顯示光標位置的行號和列號，逗號分隔。每個窗口都有自己的標尺。如果窗口有狀態行，標尺在那裡顯示。否則，它顯示在屏幕的最後一行上。
set ruler
 
" 摺疊設置
set foldmethod=syntax " 用語法高亮來定義摺疊
set foldlevel=100     " 啟動vim時不要自動摺疊代碼
 
