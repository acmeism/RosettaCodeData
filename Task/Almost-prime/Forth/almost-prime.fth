: multiplicity ( n1 n2 -- n1 n2 n3 )
  0 >r
  begin
    2dup mod 0=
  while
    r> 1+ >r
    tuck / swap
  repeat
  r> ;

: k-prime? ( n k -- ? )
  >r 0 >r 2
  begin
    2dup dup * >= if 2r@ > else false then
  while
    multiplicity r> + >r 1+
  repeat
  drop
  1 > if 1 else 0 then r> + r> = ;

: next-k-prime ( n k -- n )
  begin
  swap 1+ swap
  2dup k-prime?
  until drop ;

: main
  6 1 do
    ." k = " i 1 .r ." :"
    1 10 0 do
      j next-k-prime
      dup 3 .r space
    loop
    drop cr
  loop ;

main
bye
