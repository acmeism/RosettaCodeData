: prime? ( n -- flag )
  dup 2 < if drop false exit then
  dup 2 mod 0= if 2 = exit then
  dup 3 mod 0= if 3 = exit then
  5
  begin
    2dup dup * >=
  while
    2dup mod 0= if 2drop false exit then
    2 +
    2dup mod 0= if 2drop false exit then
    4 +
  repeat
  2drop true ;

: same_digits? ( n b -- ? )
  2dup mod >r
  begin
    tuck / swap
    over 0 >
  while
    2dup mod r@ <> if
      2drop rdrop false exit
    then
  repeat
  2drop rdrop true ;

: brazilian? ( n -- ? )
  dup 7 < if drop false exit then
  dup 1 and 0= if drop true exit then
  dup 1- 2 do
    dup i same_digits? if
      unloop drop true exit
    then
  loop
  drop false ;

: next_prime ( n -- n )
  begin 2 + dup prime? until ;

: print_brazilian ( n1 n2 -- )
  >r 7
  begin
    r@ 0 >
  while
    dup brazilian? if
      dup .
      r> 1- >r
    then
    over 0= if
      next_prime
    else
      over +
    then
  repeat
  2drop rdrop cr ;

." First 20 Brazilian numbers:" cr
1 20 print_brazilian
cr

." First 20 odd Brazilian numbers:" cr
2 20 print_brazilian
cr

." First 20 prime Brazilian numbers:" cr
0 20 print_brazilian

bye
