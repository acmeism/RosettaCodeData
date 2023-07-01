: largest-proper-divisor { n -- n }
  n 1 and 0= if n 2/ exit then
  3
  begin
    dup dup * n <=
  while
    dup n swap /mod swap
    0= if nip exit else drop then
    2 +
  repeat drop 1 ;

: main
  101 1 do
    i largest-proper-divisor 2 .r
    i 10 mod 0= if cr else space then
  loop ;

main
bye
