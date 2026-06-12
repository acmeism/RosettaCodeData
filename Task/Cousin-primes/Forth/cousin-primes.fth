: prime? ( n -- ? ) here + c@ 0= ;
: not-prime! ( n -- ) here + 1 swap c! ;

: prime-sieve ( n -- )
  here over erase
  0 not-prime!
  1 not-prime!
  2
  begin
    2dup dup * >
  while
    dup prime? if
      2dup dup * do
        i not-prime!
      dup +loop
    then
    1+
  repeat
  2drop ;

: cousin-primes ( n -- )
  dup prime-sieve
  0
  over 4 - 0 do
    i prime? if i 4 + prime? if
      1+
      ." (" i 3 .r ." , " i 4 + 3 .r ." )"
      dup 5 mod 0= if cr else space then
    then then
  loop
  swap
  cr ." Number of cousin prime pairs < " . ." is " . cr ;

1000 cousin-primes
bye
