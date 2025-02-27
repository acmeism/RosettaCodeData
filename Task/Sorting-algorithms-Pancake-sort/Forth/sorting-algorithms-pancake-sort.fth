\ swap the values stored at two memory locations
: exchange ( addr1 addr2 -- )
  2dup @ >r @ swap ! r> swap ! ;

\ reverse an array of cells in place
: reverse ( addr u -- )
  1- cells over +
  begin
    2dup <
  while
    2dup exchange
    swap cell+ swap
    1 cells -
  repeat 2drop ;

\ index of the largest value in an array of cells
: max-index ( addr u -- u )
  0 -rot 0 ?do
    2dup swap cells + @
    over i cells + @
    < if nip i swap then
  loop drop ;

\ sorts an array of cells in place
: pancake-sort ( addr u -- )
  begin
    dup 1 >
  while
    2dup max-index 1+
    2dup <> if
      dup 1 > if
        >r over r> reverse
      else
        drop
      then
      2dup reverse
    else
      drop
    then
    1-
  repeat 2drop ;

\ print an array of cells
: print-array ( addr u -- )
  ." [" 0 ?do
    i 0> if ." , " then
    dup i cells + @ 1 .r
  loop drop ." ]" ;

create test-array 6 , 7 , 2 , 1 , 8 , 9 , 5 , 3 , 4 ,
." Before sorting: "
test-array 9 print-array cr
test-array 9 pancake-sort
." After sorting: "
test-array 9 print-array cr
bye
