: reverse ( n -- n )
  0 >r
  begin
    dup 0 >
  while
    10 /mod swap
    r> 10 * + >r
  repeat
  drop r> ;

: special? ( n -- ? )
  dup reverse >r
  2
  begin
    2dup dup * >=
  while
    2dup mod 0= if
      dup reverse r@ swap mod 0 <> if
        rdrop 2drop false exit
      then
      2dup / dup 2 pick <> if
        reverse r@ swap mod 0 <> if
          rdrop 2drop false exit
        then
      else
        drop
      then
    then
    1+
  repeat
  rdrop 2drop true ;

: main
  0
  200 1 do
    i special? if
      i 3 .r
      1+
      dup 10 mod 0= if cr else space then
    then
  loop cr
  . ." numbers found." cr ;

main
bye
