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

: print_divisor_counts ( n -- )
  ." Count of divisors for the first " dup . ." positive integers:" cr
  1+ 1 do
    i divisor_count 2 .r
    i 20 mod 0= if cr else space then
  loop ;

100 print_divisor_counts
bye
