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

: left_truncatable_prime? ( n -- flag )
  dup prime? invert if
    drop false exit
  then
  dup >r
  10
  begin
    2dup >
  while
    2dup mod
    dup r> = if
      2drop drop false exit
    then
    dup prime? invert if
      2drop drop false exit
    then
    >r
    10 *
  repeat
  2drop rdrop true ;

: right_truncatable_prime? ( n -- flag )
  dup prime? invert if
    drop false exit
  then
  begin
    10 / dup 0 >
  while
    dup prime? invert if
      drop false exit
    then
  repeat
  drop true ;

: max_left_truncatable_prime ( n -- )
  begin
    dup 0 >
  while
    dup left_truncatable_prime? if . cr exit then
    1-
  repeat drop ;

: max_right_truncatable_prime ( n -- )
  begin
    dup 0 >
  while
    dup right_truncatable_prime? if . cr exit then
    1-
  repeat drop ;

1000000 constant limit

limit 1+ sieve

." Largest left truncatable prime: "
limit max_left_truncatable_prime

." Largest right truncatable prime: "
limit max_right_truncatable_prime

bye
