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

: deceptive? ( n -- ? )
  dup 2 mod 0= if drop false exit then
  dup 3 mod 0= if drop false exit then
  dup 5 mod 0= if drop false exit then
  dup dup 1- 10 modpow 1 <> if drop false exit then
  7 begin
    2dup dup * >
  while
    2dup mod 0= if 2drop true exit then
    4 +
    2dup mod 0= if 2drop true exit then
    2 +
  repeat
  2drop false ;

: main ( -- )
  0 7 begin
    over 100 <
  while
    dup deceptive? if
      dup 6 .r
      swap 1+ swap
      over 10 mod 0= if cr else space then
    then
    1+
  repeat
  2drop ;

main
bye
