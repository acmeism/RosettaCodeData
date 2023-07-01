: is_prime? ( n -- flag )
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

: next_prime_digit_number ( n -- n )
  dup 0= if drop 2 exit then
  dup 10 mod
  dup 2 = if drop 1+ exit then
  dup 3 = if drop 2 + exit then
  5 = if 2 + exit then
  10 / recurse 10 * 2 + ;

: spds_next ( n -- n )
  begin
    next_prime_digit_number
    dup is_prime?
  until ;

: spds_print ( n -- )
  0 swap 0 do
    spds_next dup .
  loop
  drop cr ;

: spds_nth ( n -- n )
  0 swap 0 do spds_next loop ;

." First 25 SPDS primes:" cr
25 spds_print

." 100th SPDS prime: "
100 spds_nth . cr

." 1000th SPDS prime: "
1000 spds_nth . cr

bye
