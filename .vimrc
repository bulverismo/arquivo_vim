" Bulver FUNction
fun! Getchar()
  let l:padrao = '\("" \)\|\(\a" \)\|\("">\)\|\(\(\a\|\s\)">\)'
  let l:padrao2 = '\("" \)\|\(\(\a\|\s\)" \)\|\("">\)\|\(\(\a\|\s\)">\)'
  let l:line = getline('.')
  " pegar a primeira letra para usar no super tab
  let l:part = strpart(getline('.'),col('.')-2,1)

  " pegar a posição do cursor atual
  let l:save_pos = getcurpos()

  "let save_pos[2] = get(save_pos, 2) + 1 
  " pegar o char anterior e o proximo e formar
  " uma string com 3 chars contendo:
  "   char anterior <-- char selecionado --> proximo char
  let char = strcharpart(getline('.'),col('.') - 2, 3)

  let encontrou = match(char,l:padrao)
  if encontrou != -1
  let posAtual = save_pos[2]
    
    " variável apenas para controlar a saida do while 
    let portao = 1
     
      " 1) pega o resto da linha dando como argumento para
      " strcharpart a linha atual inteira -> line
      " e a posição atual do cursor
      " isso vai resultar em uma string que contém
      " da posição atual até o final da linha 
      let restoDaLinha = strcharpart(line,posAtual)
       
      " 2) buscar ocorrências ou não dos casos
      " que me interessão que são:
      "
      " as variáveis final e continua receberão o valor da
      " primeira ocorrência respectivamente de '>' e 
      " '\("" \)\|\(\a" \)\|\("">\)\|\(\a">\)'
      " '\("" \)\|\(\(\a\|\s\)" \)\|\("">\)\|\(\a">\)'
      "
      " Caso 1 - não encontra ocorrencia do char '>' e nem 
      " do padrão descrito na variavel padrão de nenhum dos  
      " casos abaixo
      "
      " grupo de casos 1
      "       
      " href="" >
      "       ^
      "
      " href="a" >
      "        ^
      "
      " href="">
      "       ^
      "
      " href="a">
      "        ^ 
      "
      " href=" ">
      "        ^
      "
      " grupo de casos 2 
      "
      " href="" src="a">
      " href="" src="a">
      " href="" src="">
      " href="" src="" >
      " href="" src="">
      "       ^ 
      "
      " grupo casos 3
      "
      " href=""></a><a href=""></a>
      "       ^
      "
      " Caso 2
      " se for um do grupo de casos 1 entao variavel final irá
      " resultar com um numero maior que zero porém a variável 
      " continua não irá encontrar nada e então irá retornar -1
      " então deverá sair do laço e posicionar o cursor apos o >
      "
      " Caso 3
      " 
      " se for algum do grupo de casos 2 então o valor em  
      " final sera maior que o valor em continua e portanto deve posicinar
      " cursor na posição atual e sair da função
      "
      " Caso 4
      "
      " se for algum do grupo de casos 3 então a variavel final
      " terá valor menor que a variável continua devendo então
      " parar o laço e retornar a posição após o > 
      "
      let final = match(restoDaLinha, ">")
      let continua = match(restoDaLinha, l:padrao2)
        
      if final == -1 && continua == -1
        let portao = 1
        call cursor(".",posAtual)
        return ''
      elseif final != -1 && continua == -1
        let porta = 1
        call cursor(".",posAtual+final+2)
        return ''
      elseif final > continua
        let porta = 1
        call cursor(".",posAtual+continua+2)
        return ''
      elseif final < continua
        let porta = 1
        call cursor(".",posAtual+final+2)
        return ''
      endif

  else
    call setpos('.',l:save_pos)
    
    " SuperTab codigo retirado de --> https://devhints.io/vimscript
    if (l:part=~'^\W\?$')
      return "\<Tab>"
    else
      return "\<C-n>"
    endif
     
  endif
endfun
imap <Tab> <C-R>=Getchar()<CR>
 
set nocompatible
set nu
syntax on
set encoding=utf-8
set showcmd
filetype plugin indent on

set tabstop=2 shiftwidth=2
set expandtab
set backspace=indent,eol,start

set hlsearch
set incsearch
set ignorecase
set smartcase

set mouse=a
autocmd vimenter * NERDTree

call plug#begin('~/.vim/plugged')

" colorir a syntax do typescript
Plug 'leafgarland/typescript-vim'
" colorir tsx
Plug 'peitalin/vim-jsx-typescript'
" mostra uma barra inferior com o status atual
Plug 'bling/vim-airline'
" permite ver o menu lateral com pastas com os arquivos
Plug 'scrooloose/nerdtree'
" plugin para colorir os arquivos csv
Plug 'mechatroner/rainbow_csv'
" fecha automaticamente aspas e semelhantes
Plug 'jiangmiao/auto-pairs'
" brilha as tags html que abrem e fecham o mesmo elemento
Plug 'valloric/matchtagalways'
" adiciona funções para tags html >>> https://medium.com/vim-drops/be-a-html-ninja-with-emmet-for-vim-feee15447ef1
Plug 'mattn/emmet-vim'
"linhas verticais para auxiliar a enxergar a identação
Plug 'yggdroot/indentline'
" vimwiki 
Plug 'vimwiki/vimwiki'
" calendario 
Plug 'itchyny/calendar.vim'
" autocomplete
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --tern-completer' }
call plug#end()

" Configurações do plugin de autocomplete
" Start autocompletion after 4 chars
let g:ycm_min_num_of_chars_for_completion = 4
let g:ycm_min_num_identifier_candidate_chars = 4
let g:ycm_enable_diagnostic_highlighting = 0
" Don't show YCM's preview window [ I find it really annoying ]
set completeopt-=preview
let g:ycm_add_preview_to_completeopt = 0

" Conteudo abaixo é o que vem no vimtutor, com algumas melhorias para o vim
" como salvamento de um arquivo de persistencia do undo

" When started as "evim", evim.vim will already have done these settings, bail
" out.
if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set nobackup		" keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
  endif
endif

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
augroup END

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif

" Comando para usar o :Rename para renomear mais facilmente os arquivos

function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>
