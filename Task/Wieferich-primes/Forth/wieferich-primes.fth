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

: wieferich_prime? { p -- ? }
  p prime? if
    p p * p 1- 2 modpow 1 =
  else
    false
  then ;

: wieferich_primes { n -- }
  ." Wieferich primes less than " n 1 .r ." :" cr
  n prime_sieve
  n 0 do
    i wieferich_prime? if
      i 1 .r cr
    then
  loop ;

5000 wieferich_primes
bye
