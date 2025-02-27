: s2 ( n k -- u )
  dup 0= if 2drop 0 exit then
  over 0= if 2drop 0 exit then
  2dup = if 2drop 1 exit then
  swap 1- swap
  2dup 1- recurse >r
  tuck recurse * r> + ;

: main ( -- )
  ." Stirling numbers of the second kind:" cr
  ." n/k"
  13 1 do
    i 8 .r
  loop cr
  13 1 do
    i 3 .r
    i 1+ 1 do
      j i s2 8 .r
    loop cr
  loop ;

main
bye
