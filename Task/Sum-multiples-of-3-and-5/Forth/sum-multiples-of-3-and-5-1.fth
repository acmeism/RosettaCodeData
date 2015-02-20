: main ( n -- )
  0 swap
  3 do
    i 3 mod 0= if
      i +
    else i 5 mod 0= if
      i +
    then then
  loop
  . ;

1000 main    \ 233168  ok
