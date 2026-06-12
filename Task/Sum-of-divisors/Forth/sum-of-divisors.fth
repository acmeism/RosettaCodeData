: divisor_sum ( n -- n )
  1 >r
  2
  begin
    over 2 mod 0=
  while
    dup r> + >r
    2*
    swap 2/ swap
  repeat
  drop
  3
  begin
    2dup dup * >=
  while
    dup
    1 >r
    begin
      2 pick 2 pick mod 0=
    while
      dup r> + >r
      over * >r
      tuck / swap
      r>
    repeat
    2r> * >r
    drop
    2 +
  repeat
  drop
  dup 1 > if 1+ r> * else drop r> then ;

: print_divisor_sums ( n -- )
  ." Sum of divisors for the first " dup . ." positive integers:" cr
  1+ 1 do
    i divisor_sum 4 .r
    i 10 mod 0= if cr else space then
  loop ;

100 print_divisor_sums
bye
