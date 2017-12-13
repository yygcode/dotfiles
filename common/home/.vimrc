" vimrc file
"
" Maintainer:	yanyg, <cppgp@qq.com>
" Date:		12/13, 2012
"

set nocompatible

" enable syn and keep current color settings
syntax enable
" enable ft plugin & indent
filetype plugin indent on

set nu
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ 
set statusline+=[ASCII=\%03.3b,0x\%02.2B]\ [POS=%l,%v]\ [%p%%]

function s:SetColorsByHours()
  let h = strftime("%H")
  if h < 6
    let cs = "darkblue"
  elseif h < 12
    let cs = "morning"
  elseif h < 18
    let cs = "shine"
  else
    let cs = "evening"
  endif
  execute "colorscheme " . cs
endfunction
call s:SetColorsByHours()
delfunction s:SetColorsByHours
colorscheme evening

set laststatus=2 history=100
set backspace=indent,eol,start
set whichwrap=b,s,h,l,~,<,>,[,]

" exec "source " . $HOME . "/.vim/ftplugin/c.vim"

" right margin
set colorcolumn=81
hi ColorColumn ctermbg=Brown ctermfg=black
