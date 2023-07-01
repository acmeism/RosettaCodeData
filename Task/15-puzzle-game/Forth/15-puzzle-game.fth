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

\ To iterate over all possible directions, put direction-related functions into arrays:
: ith ( u addr -- w ) swap cells + @ ;
create valid? ' up-valid? , ' left-valid? , ' right-valid? , ' down-valid? , does> ith execute ;
create step -4 , -1 , 1 , 4 , does> ith ;

\ Advance from a single state to another:
: bits ( h -- b ) 15 swap - 4 * ;
: tile ( s b -- t ) rshift 15 and ;
: new-state ( s h d -- s' ) step dup >r + bits 2dup tile ( s b t ) swap lshift tuck - swap r> 4 * shift + ;

: hole? ( s u -- f ) bits tile 0= ;
: hole ( s -- h ) 16 0 do dup i hole? if drop i unloop exit then loop drop ;

0 constant up 1 constant left 2 constant right 3 constant down

\ Print a board:
: .hole   space space space ;
: .tile ( u -- ) ?dup-0=-if .hole else dup 10 < if space then . then ;
: .board ( s -- ) 4 0 do cr 4 0 do dup j 4 * i + bits tile .tile loop loop drop ;
: .help   cr ." ijkl move, q quit" ;

\ Pseudorandom number generator:
create (rnd)   utime drop ,
: rnd   (rnd) @ dup 13 lshift xor dup 17 rshift xor dup dup 5 lshift xor (rnd) ! ;

: move ( s u -- s' ) >r dup hole r> new-state ;
: ?move ( s u -- s' ) >r dup hole r@ valid? if r> move else rdrop then ;
: shuffle ( s u -- s' ) 0 do rnd 3 and ?move loop ;

: win   cr ." you won!" bye ;
: turn ( s -- )
	page dup .board .help
	key case
		[char] q of bye endof
		[char] i of down ?move endof
		[char] j of right ?move endof
		[char] k of up ?move endof
		[char] l of left ?move endof
	endcase ;

: play  begin dup solution <> while turn repeat win ;

solution 1000 shuffle play
