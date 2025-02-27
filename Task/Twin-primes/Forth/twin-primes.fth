variable sieve-addr

: sieve-free ( -- )
  sieve-addr @ free abort" free failed"
  0 sieve-addr ! ;

: sieve-allocate ( n -- )
  sieve-free
  dup allocate abort" out of memory"
  tuck sieve-addr ! erase ;

: odd-prime? ( n -- ? ) 2/ sieve-addr @ + c@ 0= ;
: notprime! ( n -- ) 2/ sieve-addr @ + 1 swap c! ;

\ odds-only prime sieve
: sieve { n -- }
  n 2/ sieve-allocate
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

: twin-prime-count ( n -- n )
  dup sieve 5 0 >r
  begin
    2dup >
  while
    dup odd-prime? if
      dup 2 - odd-prime? if
        r> 1+ >r
      then
    then
    2 +
  repeat
  sieve-free 2drop r> ;

10000000 dup twin-prime-count swap
." Number of twin prime pairs less than " . ." is " . cr
bye
