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

: main { n -- }
  ."    N    N-1   N+3   N+5" cr
  n prime_sieve
  0
  n 1 do
    i 1- prime? if
      i 3 + prime? if
        i 5 + prime? if
          i 4 .r ." :"
          i 1-  6 .r
          i 3 + 6 .r
          i 5 + 6 .r cr
          1+
        then
      then
    then
  loop
  cr ." Count: " . cr ;

6000 main
bye
