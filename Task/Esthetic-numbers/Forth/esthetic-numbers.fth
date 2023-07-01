\ Returns the next esthetic number in the given base after n, where n is an
\ esthetic number in that base or one less than a power of base.
: next_esthetic_number { n base -- n }
  n 1+ base < if n 1+ exit then
  n base / dup base mod
  dup n base mod 1+ = if dup 1+ base < if 2drop n 2 + exit then then
  drop base recurse
  dup base mod
  dup 0= if 1+ else 1- then
  swap base * + ;

: print_esthetic_numbers { min max per_line -- }
  ." Esthetic numbers in base 10 between " min 1 .r ."  and " max 1 .r ." :" cr
  0
  min 1- 10 next_esthetic_number
  begin
    dup max <=
  while
    dup 4 .r
    swap 1+ dup per_line mod 0= if cr else space then swap
    10 next_esthetic_number
  repeat
  drop
  cr ." count: " . cr ;

: main
  17 2 do
    i 4 * i 6 * { min max }
    ." Esthetic numbers in base " i 1 .r ."  from index " min 1 .r ."  through index " max 1 .r ." :" cr
    0
    max 1+ 1 do
      j next_esthetic_number
      i min >= if dup ['] . j base-execute then
    loop
    drop
    cr cr
  loop
  1000 9999 16 print_esthetic_numbers cr
  100000000 130000000 8 print_esthetic_numbers ;

main
bye
