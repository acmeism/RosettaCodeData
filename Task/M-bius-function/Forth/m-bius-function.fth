\ Moebius function
: mu ( u -- n )
  \ multiple of 4 so return 0
  dup 3 and 0= if drop 0 exit then
  \ even numbers have 2 as a prime factor
  dup 1 and 0= if 2/ 1 else 0 then >r
  \ look for odd prime factors up to the square root
  3 begin
    2dup dup * >=
  while
    2dup mod 0= if
      tuck / swap
      2dup mod 0= if
        \ repeated prime factor so return 0
        2drop rdrop 0 exit
      then
       \ we have another prime factor
      r> 1+ >r
    then
    2 +
  repeat
  drop
  \ prime factor > square root?
  r> swap 1 > if 1+ then
  1 and 0= if 1 else -1 then ;

: main ( -- )
  ." The first 199 Moebius numbers are:" cr
  ."    "
  200 1 do
    i mu 3 .r
    i 1+ 20 mod 0= if cr else then
  loop ;

main
bye
