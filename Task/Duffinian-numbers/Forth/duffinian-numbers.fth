: gcd ( u1 u2 -- u3 )
  dup 0= if drop exit then
  tuck mod recurse ;

: duffinian? ( u -- ? )
  dup 2 = if drop false exit then
  1 >r dup 2
  begin
    over 2 mod 0=
  while
    dup r> + >r 2* swap 2/ swap
  repeat
  drop 3
  begin
    2dup dup * >=
  while
    dup 1 >r
    begin
      2 pick 2 pick mod 0=
    while
      dup r> + >r over * >r tuck / swap r>
    repeat
    2r> * >r drop 2 +
  repeat
  drop
  2dup = if 2drop rdrop false exit then
  dup 1 > if 1+ r> * else drop r> then
  gcd 1 = ;

: main
  ." First 50 Duffinian numbers:" cr
  0 1
  begin
    over 50 <
  while
    dup duffinian? if
      dup 3 .r
      swap 1+ swap
      over 10 mod 0= if cr else space then
    then
    1+
  repeat
  2drop
  cr ." First 30 Duffinian triplets:" cr
  0 >r 0 1
  begin
    r@ 30 <
  while
    dup duffinian? if swap 1+ swap else nip 0 swap then
    over 3 = if
      r> 1+ >r
      dup 2 - 5 .r space
      dup 1- 5 .r space
      dup 5 .r cr
    then
    1+
  repeat
  rdrop 2drop ;

main
bye
