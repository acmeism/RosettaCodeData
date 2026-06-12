\ Returns true if the hexadecimal representation of n contains at least one
\ non-decimal digit.
: non-decimal ( u -- ? )
  begin
    dup 0 >
  while
    dup 15 and 9 > if
      drop true exit
    then
    4 rshift
  repeat
  drop false ;

: main
  0
  501 0 do
    i non-decimal if
      1+
      i 3 .r
      dup 15 mod 0= if cr else space then
    then
  loop
  cr cr . ." such numbers found." cr ;

main
bye
