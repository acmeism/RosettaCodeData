: init ( n -- )
  here swap cells erase  1 here ! ;
: .line ( n -- )
  cr here swap 0 do dup @ . cell+ loop drop ;
: next ( n -- )
  here swap 1- cells here + do
    i @ i cell+ +!
  -1 cells +loop ;
: pascal ( n -- )
      dup init   1  .line
  1 ?do i next i 1+ .line loop ;
