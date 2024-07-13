for i in range(1, 5)
  call append(line('$'), '')
  for j in range(1, i)
    call setline(line('$'), getline('$') .. '*')
  endfor
endfor
