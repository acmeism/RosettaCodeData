#! /usr/bin/gforth

cell 8 <> [if] s" 64-bit system required" exception throw [then]

\ In the stack comments below,
\ "h" stands for the hole position (0..15),
\ "s" for a 64-bit integer representing a board state,
\ "t" a tile value (0..15, 0 is the hole),
\ "b" for a bit offset of a position within a state,
\ "m" for a masked value (4 bits selected out of a 64-bit state),
\ "w" for a weight of a current path,
\ "d" for a direction constant (0..3)

\ Utility
: 3dup   2 pick 2 pick 2 pick ;
: 4dup   2over 2over ;
: shift   dup 0 > if lshift else negate rshift then ;

hex 123456789abcdef0 decimal constant solution
: row   2 rshift ;   : col   3 and ;

: up-valid?    ( h -- f ) row 0 > ;
: down-valid?  ( h -- f ) row 3 < ;
: left-valid?  ( h -- f ) col 0 > ;
: right-valid? ( h -- f ) col 3 < ;

: up-cost    ( h t -- 0|1 ) 1 - row swap row < 1 and ;
: down-cost  ( h t -- 0|1 ) 1 - row swap row > 1 and ;
: left-cost  ( h t -- 0|1 ) 1 - col swap col < 1 and ;
: right-cost ( h t -- 0|1 ) 1 - col swap col > 1 and ;

\ To iterate over all possible directions, put direction-related functions into arrays:
: ith ( u addr -- w ) swap cells + @ ;
create valid? ' up-valid? , ' left-valid? , ' right-valid? , ' down-valid? , does> ith execute ;
create cost ' up-cost , ' left-cost , ' right-cost , ' down-cost , does> ith execute ;
create step -4 , -1 , 1 , 4 , does> ith ;

\ Advance from a single state to another:
: bits ( h -- b ) 15 swap - 4 * ;
: tile ( s b -- t ) rshift 15 and ;
: new-state ( s h d -- s' ) step dup >r + bits 2dup tile ( s b t ) swap lshift tuck - swap r> 4 * shift + ;
: new-weight ( w s h d -- w' ) >r tuck r@ step + bits tile r> cost + ;
: advance ( w s h d -- w s h w' s' h' ) 4dup new-weight >r  3dup new-state >r  step over + 2r> rot ;

\ Print a solution:
: rollback   2drop drop ;
: .dir ( u -- ) s" d..r.l..u" drop 4 + swap + c@ emit ;
: .dirs ( .. -- ) 0 begin >r 3 pick -1 <> while 3 pick over - .dir rollback r> 1+ repeat r> ;
: win   cr ." solved (read right-to-left!): " .dirs ."  - " . ." moves" bye ;

\ The main recursive function for depth-first search:
create limit 1 ,   : deeper  1 limit +! ;
: u-turn ( .. h2 w1 s1 h1 ) 4 pick 2 pick - ;
: search ( .. h2 w1 s1 h1 )
	over solution = if win then
	2 pick limit @ > if exit then
	4 0 do dup i valid? if i step u-turn <> if i advance recurse rollback then then loop ;

\ Iterative-deepening search:
: solve   1 limit !  begin search deeper again ;

\ -1 0 hex 0c9dfbae37254861 decimal 0 solve    \ uhm.
 -1 0 hex fe169b4c0a73d852 decimal 8 solve     \ the 52 moves case
\ -1 0 hex 123456789afbde0c decimal 14 solve   \ some trivial case, 3 moves
bye
