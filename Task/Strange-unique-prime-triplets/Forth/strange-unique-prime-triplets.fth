: prime? ( n -- ? ) here + c@ 0= ;
: notprime! ( n -- ) here + 1 swap c! ;

: prime_sieve ( n -- )
  here over erase
  0 notprime!
  1 notprime!
  dup 4 > if
    dup 4 do i notprime! 2 +loop
  then
  3
  begin
    2dup dup * >
  while
    dup prime? if
      2dup dup * do
        i notprime!
      dup 2* +loop
    then
    2 +
  repeat
  2drop ;

: print_strange_unique_prime_triplets ( n -- )
  dup 8 < if drop exit then
  dup 3 * prime_sieve
  dup 4 - 3 do
    i prime? if
      dup 2 - i 2 + do
        i prime? if
          dup i 2 + do
            i prime? if
              i j k + + dup prime? if
                k 2 .r ."  + " j 2 .r ."  + " i 2 .r ."  = " 2 .r cr
              else
                drop
              then
            then
          2 +loop
        then
      2 +loop
    then
  2 +loop drop ;

: count_strange_unique_prime_triplets ( n -- n )
  dup 8 < if drop 0 exit then
  dup 3 * prime_sieve
  0 swap
  dup 4 - 3 do
    i prime? if
      dup 2 - i 2 + do
        i prime? if
          dup i 2 + do
            i prime? if
              i j k + + prime? if
                swap 1+ swap
              then
            then
          2 +loop
        then
      2 +loop
    then
  2 +loop drop ;

." Strange unique prime triplets < 30:" cr
30 print_strange_unique_prime_triplets

." Count of strange unique prime triplets < 1000: "
1000 count_strange_unique_prime_triplets . cr
bye
