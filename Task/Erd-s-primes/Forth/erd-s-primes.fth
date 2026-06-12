: prime? ( n -- ? ) here + c@ 0= ;
: notprime! ( n -- ) here + 1 swap c! ;

: prime_sieve { n -- }
  here n erase
  0 notprime!
  1 notprime!
  n 4 > if
    n 4 do i notprime! 2 +loop
  then
  3
  begin
    dup dup * n <
  while
    dup prime? if
      n over dup * do
        i notprime!
      dup 2* +loop
    then
    2 +
  repeat
  drop ;

: erdos_prime? { p -- ? }
  p prime? if
    1 1
    begin
      dup p <
    while
      p over - prime? if 2drop false exit then
      swap 1+ swap
      over *
    repeat
    2drop true
  else
    false
  then ;

: print_erdos_primes { n -- }
  ." Erdos primes < " n 1 .r ." :" cr
  n prime_sieve
  0
  n 0 do
    i erdos_prime? if
      i 5 .r
      1+ dup 10 mod 0= if cr then
    then
  loop
  cr ." Count: " . cr ;

2500 print_erdos_primes
bye
