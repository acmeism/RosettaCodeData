" return character under cursor
function! CurrChar()
   return matchstr(getline('.'), '\%' . col('.') . 'c.')
endfunction

" draw all-white grid (arguments are characters to use for white and black)
function! LangtonClear(white, black)
  let l:bufname = 'langtons.ant'
  if bufexists(l:bufname)
    let l:winnum = bufwinnr(l:bufname)
    if l:winnum == -1
      execute 'sbuffer ' . bufnr(l:bufname)
    else
      execute l:winnum . 'wincmd w'
    endif
  else
    execute 'new ' . l:bufname
  end
  execute '1,$ delete _'
  call append(0, repeat(a:white,100))
  execute 'normal! 1Gyy99p'
  goto 5100
  let b:directions = [ 'k', 'l', 'j', 'h' ]
  let b:direction = 0
  let b:white = a:white
  let b:black = a:black
endfunction

" move the ant one step
function! LangtonStep()
  let l:ch = CurrChar()
  if l:ch == b:white
    let l:ch = b:black
    let b:direction = (b:direction  + 1) % 4
  elseif l:ch == b:black
    let l:ch = b:white
    let b:direction = (b:direction  + 3) % 4
  endif
  execute 'normal! r'.l:ch.b:directions[b:direction]
endfunction

" run until we hit the edge
" optional arguments specify white and black characters;
" default . and @, respectively.
function! RunLangton(...)
  let l:white='.'
  let l:black='@'
  if a:0 > 0
    let l:white=a:1
    if a:0 > 1
      let l:black=a:2
    endif
  endif
  call LangtonClear(l:white, l:black)
  while 1
    let l:before = getpos('.')
    call LangtonStep()
    let l:after = getpos('.')
    if l:before == l:after
      break
    endif
  endwhile
endfunction
