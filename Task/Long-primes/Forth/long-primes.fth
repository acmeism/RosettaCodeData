: prime? ( n -- ? ) here + c@ 0= ;
: notprime! ( n -- ) here + 1 swap c! ;

: sieve ( n -- )
  here over erase
  0 notprime!
  1 notprime!
  2
  begin
    2dup dup * >
  while
    dup prime? if
      2dup dup * do
        i notprime!
      dup +loop
    then
    1+
  repeat
  2drop ;

: modpow { c b a -- a^b mod c }
  c 1 = if 0 exit then
  1
  a c mod to a
  begin
    b 0>
  while
    b 1 and 1 = if
      a * c mod
    then
    a a * c mod to a
    b 2/ to b
  repeat ;

: divide_out ( n1 n2 -- n )
  begin
    2dup mod 0=
  while
    tuck / swap
  repeat drop ;

: long_prime? ( n -- ? )
  dup prime? invert if drop false exit then
  10 over mod 0= if drop false exit then
  dup 1-
  2 >r
  begin
    over r@ dup * >
  while
    r@ prime? if
      dup r@ mod 0= if
        over dup 1- r@ / 10 modpow 1 = if
          2drop rdrop false exit
        then
        r@ divide_out
      then
    then
    r> 1+ >r
  repeat
  rdrop
  dup 1 = if 2drop true exit then
  over 1- swap / 10 modpow 1 <> ;

: next_long_prime ( n -- n )
  begin 2 + dup long_prime? until ;

500    constant limit1
512000 constant limit2

: main
  limit2 1+ sieve
  limit2 limit1 3
  0 >r
  ." Long primes up to " over 1 .r ." :" cr
  begin
    2 pick over >
  while
    next_long_prime
    dup limit1 < if dup . then
    dup 2 pick > if
      over limit1 = if cr then
      ." Number of long primes up to " over 6 .r ." : " r@ 5 .r cr
      swap 2* swap
    then
    r> 1+ >r
  repeat
  2drop drop rdrop ;

main
bye
