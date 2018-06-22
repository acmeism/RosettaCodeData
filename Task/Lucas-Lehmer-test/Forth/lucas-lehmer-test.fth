: lucas-lehmer
  1+ 2 do
    4 i 2 <> * abs swap 1+ dup + 1- swap
    i 1- 1 ?do dup * 2 - over mod loop 0= if ." M" i . then
  loop cr
;

1 15 lucas-lehmer
