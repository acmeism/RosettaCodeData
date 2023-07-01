\ Increments a2 until it no longer points to the same value as a1
\ a3 is the address beyond the data a2 is traversing.
: skip-dups ( a1 a2 a3 -- a1 a2+n )
    dup rot ?do
      over @ i @ <> if drop i leave then
    cell +loop ;

\ Compress an array of cells by removing adjacent duplicates
\ Returns the new count
: uniq ( a n -- n2 )
   over >r             \ Original addr to return stack
   cells over + >r     \ "to" addr now on return stack, available as r@
   dup begin           ( write read )
      dup r@ <
   while
      2dup @ swap !    \ copy one cell
      cell+ r@ skip-dups
      cell 0 d+        \ increment write ptr only
   repeat  r> 2drop  r> - cell / ;
