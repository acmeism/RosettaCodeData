: square_free? ( n -- ? )
  dup 4 mod 0= if drop false exit then
  3
  begin
    2dup dup * >=
  while
    0 >r
    begin
      2dup mod 0=
    while
      r> 1+ dup 1 > if
        2drop drop false exit
      then
      >r
      tuck / swap
    repeat
    rdrop
    2 +
  repeat
  2drop true ;

\ print square-free numbers from n3 to n2, n1 per line
: print_square_free_numbers ( n1 n2 n3 -- )
  2dup
  ." Square-free integers between "
  1 .r ."  and " 1 .r ." :" cr
  0 -rot
  swap 1+ swap do
    i square_free? if
      i 3 .r space
      1+
      dup 2 pick mod 0= if cr then
    then
  loop 2drop cr ;

: count_square_free_numbers ( n1 n2 -- n )
  0 -rot
  swap 1+ swap do
    i square_free? if 1+ then
  loop ;

: main
  20 145 1 print_square_free_numbers cr
  5 1000000000145 1000000000000 print_square_free_numbers cr
  ." Number of square-free integers:" cr
  100
  begin
    dup 1000000 <=
  while
    dup 1
    2dup ."   from " 1 .r ."  to " 7 .r ." : "
    count_square_free_numbers . cr
    10 *
  repeat drop ;

main
bye
