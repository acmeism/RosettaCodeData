require random.fs

0 value board-size
variable target
variable board
variable moves

: moves-reset 0 moves ! ;
: moves+ 1 moves +! ;
: .moves ." You have made " moves @ . ." moves." ;

: target-gen ( -- )  rnd target ! ;

: row-flip ( n -- )
  8 * 255 swap lshift
  board @ xor board ! ;

: column-flip ( n -- )
  1 swap lshift
  8 0 do dup 8 lshift or loop
  board @ xor board ! ;

: target>board ( -- )  target @ board ! ;

: board-shuffle ( -- )
  board-size dup * 0 do
    board-size random 2 random if row-flip else column-flip then
  loop ;

: ask-move ( -- char )
  cr ." choose row [0-"  board-size [char] 0 + 1- emit
     ." ] or column [a-" board-size [char] a + 1- emit
     ." ]: "
  key ;

: do-move ( char -- )
  dup emit
  dup [char] a dup board-size + within
  if dup [char] a - column-flip
  else
    dup [char] 0 dup board-size + within
    if dup [char] 0 - row-flip
    else ." - this move is not permitted!"
  then then
  cr drop
;

: .header ( -- )  cr ." Target: " board-size 2 * spaces ." Board:" ;
: .column-header ( -- )  board-size 0 do i [char] a + emit space loop ;
: .row-header ( n -- )  . ." - " ;
: .row ( board@ n -- )  dup .row-header 8 * rshift board-size 0 do dup 1 and . 2/ loop drop ;
: .boards
  .header cr
  4 spaces .column-header  8 spaces  .column-header cr
  board-size 0 do
    target @ i .row  4 spaces  board @ i .row cr
  loop
;

: ?win ( -- f )
  0  board-size 0 do 2* 1+ loop
     board-size 1 do dup 8 lshift or loop
  dup target @ and
  swap board @ and =
;

: game-loop
  begin
    .boards .moves
    ask-move do-move moves+
    ?win until
  ." You win after " moves @ . ." moves!"
;

: flip-bit-game ( n -- )
  to board-size
  target-gen  target>board  board-shuffle
  moves-reset
  game-loop
;
