: odd-square-free-semi-prime? { n -- ? }
  n 1 and 0= if false exit then
  0 { count }
  3
  begin
    dup dup * n <=
  while
    begin
      dup n swap mod 0=
    while
      count 1+ to count
      count 1 > if
        drop false exit
      then
      dup n swap / to n
    repeat
    2 +
  repeat
  drop
  count 1 = ;

: special_odd_numbers ( n -- )
  ." Odd square-free semiprimes < " dup 1 .r ." :" cr
  0 swap
  1 do
    i odd-square-free-semi-prime? if
      1+
      i 4 .r
      dup 20 mod 0= if cr then
    then
  2 +loop
  cr ." Count: " . cr ;

1000 special_odd_numbers
bye
