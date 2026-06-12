: divisible? { n -- ? }
  1 { p }
  n
  begin
    dup 0 >
  while
    10 /mod swap
    dup 0= if
      2drop false exit
    then
    dup n swap mod 0<> if
      2drop false exit
    then
    p * to p
  repeat
  drop n p mod 0<> ;

: main
  0 { count }
  1000 1 do
    i divisible? if
      i 4 .r
      count 1+ to count
      count 10 mod 0= if cr else space then
    then
  loop cr ;

main
bye
