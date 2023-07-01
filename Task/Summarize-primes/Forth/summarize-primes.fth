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
  0 0 { count sum }
  ." count  prime      sum" cr
  1000 2 do
    i prime? if
      count 1+ to count
      sum i + to sum
      sum prime? if
        ."   " count 3 .r ."     " i 3 .r ."     " sum 5 .r cr
      then
    then
  loop ;

main
bye
