500000 constant limit
variable pdc limit cells allot

: main
  limit 0 do
    1 pdc i cells + !
  loop
  7 pdc !
  limit 2 +do
    limit i 2* 1- +do
      1 pdc i cells + +!
    j +loop
  loop
  ." First 50 numbers which are the cube roots" cr
  ." of the products of their proper divisors:" cr
  500 0
  limit 0 do
    pdc i cells + @ 7 = if
      1+
      dup 50 <= if
        i 1+ 3 .r
        dup 10 mod 0= if cr else space then
      else
        2dup = if
          cr over 5 .r ." th: " i 1+ .
          swap 10 * swap
        then
      then
    then
  loop
  2drop cr ;

main
bye
