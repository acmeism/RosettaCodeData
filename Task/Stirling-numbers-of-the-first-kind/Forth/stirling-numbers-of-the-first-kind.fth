: s1 ( n k -- u )
  dup 0= if
    drop 0> if 0 else 1 then exit
  then
  2dup < if 2drop 0 exit then
  swap 1- swap
  2dup 1- recurse >r
  over swap recurse
  * r> + ;

: main ( -- )
  ." Unsigned Stirling numbers of the first kind:" cr
  ." n/k"
  13 1 do
    i 10 .r
  loop cr
  13 1 do
    i 3 .r
    i 1+ 1 do
      j i s1 10 .r
    loop cr
  loop ;

main
bye
