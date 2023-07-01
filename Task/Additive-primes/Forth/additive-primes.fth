: prime? ( n -- ? ) here + c@ 0= ;
: notprime! ( n -- ) here + 1 swap c! ;

: prime_sieve ( n -- )
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

: digit_sum ( u -- u )
  dup 10 < if exit then
  10 /mod recurse + ;

: print_additive_primes ( n -- )
  ." Additive primes less than " dup 1 .r ." :" cr
  dup prime_sieve
  0 swap
  1 do
    i prime? if
      i digit_sum prime? if
        i 3 .r
        1+ dup 10 mod 0= if cr else space then
      then
    then
  loop
  cr . ." additive primes found." cr ;

500 print_additive_primes
bye
