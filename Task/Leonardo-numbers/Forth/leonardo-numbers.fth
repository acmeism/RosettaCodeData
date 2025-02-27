: leonardo-next ( n1 n2 n3 -- n1 n1+n2+n3 n2 )
  swap dup >r + over + r> ;

: leonardo-print ( n1 n2 n3 u -- )
  0 do
    dup .
    leonardo-next
  loop
  drop 2drop ;

: main ( -- )
  ." First 25 Leonardo numbers:" cr
  1 1 1 25 leonardo-print cr
  ." First 25 Fibonacci numbers:" cr
  0 1 0 25 leonardo-print cr ;

main
bye
