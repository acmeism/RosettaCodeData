: sum-cubes ( n -- )
  0 swap 0 do
    i i i * * + dup 7 .r
    i 1+ 5 mod 0= if cr else space then
  loop drop ;

50 sum-cubes
bye
