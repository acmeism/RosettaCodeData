: odd-prime? ( n -- ? ) 2/ here + c@ 0= ;
: notprime! ( n -- ) 2/ here + 1 swap c! ;

\ odds-only prime sieve
: prime-sieve { n -- }
  here n 2/ erase
  1 notprime! 3
  begin
    dup dup * n <
  while
    dup odd-prime? if
      n over dup * do
        i notprime!
      dup 2* +loop
    then
    2 +
  repeat
  drop ;

: main { n -- }
  n prime-sieve
  0 2 n 3 do
    i odd-prime? if
      i swap - 2dup < if
        swap
      then
      drop i
    then
  2 +loop
  drop
  ." Largest difference between adjacent primes under " n . ." is " . cr ;

1000000 main
bye
