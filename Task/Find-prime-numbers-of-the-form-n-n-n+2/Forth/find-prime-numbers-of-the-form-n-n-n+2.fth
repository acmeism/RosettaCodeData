: prime? ( n -- flag )
  dup 2 < if drop false exit then
  dup 2 mod 0= if 2 = exit then
  dup 3 mod 0= if 3 = exit then
  5
  begin
    2dup dup * >=
  while
    2dup mod 0= if 2drop false exit then
    2 +
    2dup mod 0= if 2drop false exit then
    4 +
  repeat
  2drop true ;

: main
  200 1 do
    i i i * * 2 + dup prime? if
      i 3 .r 9 .r cr
    else
      drop
    then
  2 +loop ;

main
bye
