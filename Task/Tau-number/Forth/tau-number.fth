: divisor_count ( n -- n )
  1 >r
  begin
    dup 2 mod 0=
  while
    r> 1+ >r
    2/
  repeat
  3
  begin
    2dup dup * >=
  while
    1 >r
    begin
      2dup mod 0=
    while
      r> 1+ >r
      tuck / swap
    repeat
    2r> * >r
    2 +
  repeat
  drop 1 > if r> 2* else r> then ;

: print_tau_numbers ( n -- )
  ." The first " dup . ." tau numbers are:" cr
  0 >r
  1
  begin
    over r@ >
  while
    dup dup divisor_count mod 0= if
      dup 6 .r
      r> 1+
      dup 10 mod 0= if cr else space then
      >r
    then
    1+
  repeat
  2drop rdrop ;

100 print_tau_numbers
bye
