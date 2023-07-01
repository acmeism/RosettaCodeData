: total
  over * over 1- rot 0 ?do
    over over mod if dup xor swap leave else over over / 1+ rot + swap then
  loop drop
;

: sailors
  1+ 2 ?do
    1 begin i over total dup 0= while drop 1+ repeat cr i 0 .r ." : " . .
  loop
;

9 sailors
