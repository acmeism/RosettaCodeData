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

: digital_root ( m -- n ) 1 - 9 mod 1 + ;

: print_nice_primes ( m n -- )
  ." Nice primes between " dup . ." and " over 1 .r ." :" cr
  over prime_sieve
  0 -rot
  do
    i prime? if
      i digital_root prime? if
        i 3 .r
        1+ dup 10 mod 0= if cr else space then
      then
    then
  loop
  cr . ." nice primes found." cr ;

1000 500 print_nice_primes
bye
