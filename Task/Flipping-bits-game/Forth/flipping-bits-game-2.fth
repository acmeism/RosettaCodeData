require random.fs

0 value board-size
0 value target
0 value board
variable moves

: moves-reset 0 moves ! ;
: moves+ 1 moves +! ;
: .moves ." You have made " moves @ . ." moves." ;

: allot-board ( -- addr ) here board-size dup * cells allot ;

: target-gen ( -- )
  board-size dup * 0 do
    2 random [char] 0 +  target i cells + !
  loop
;

: row-flip ( board n -- )
  board-size * cells +
  dup board-size cells + swap do
    i dup @ 1 xor swap !
  cell +loop
;

: column-flip ( board n -- )
  cells +
  dup board-size dup * cells + swap do
    i dup @ 1 xor swap !
  board-size cells +loop
;

: target>board ( -- )
  board-size dup * cells  0 do
    target i + @  board i + !
  cell +loop
;

: board-shuffle ( -- )
  board-size dup * 0 do
    board board-size random 2 random if row-flip else column-flip then
  loop
;

: ask-move ( -- char )
  cr ." choose row [0-"  board-size [char] 0 + 1- emit
     ." ] or column [a-" board-size [char] a + 1- emit
     ." ]: "
  key ;

: do-move ( char -- )
  dup emit
  dup [char] a dup board-size + within
  if dup board swap [char] a - column-flip
  else
    dup [char] 0 dup board-size + within
    if dup board swap [char] 0 - row-flip
    else ." - this move is not permitted!"
  then then
  cr drop
;

: .header ( -- )  cr ." Target: " board-size 2 * spaces ." Board:" ;
: .column-header ( -- )  board-size 0 do i [char] a + emit space loop ;
: .row-header ( n -- )  . ." - " ;
: .bit ( board row col -- )  board-size * + cells + @ emit space ;
: .row ( board n -- )  dup .row-header  board-size 0 do  2dup i swap .bit  loop 2drop ;
: .boards
  .header cr
  4 spaces .column-header  8 spaces  .column-header cr
  board-size 0 do
    target i .row  4 spaces  board i .row cr
  loop
;

: ?win ( -- f )
  board-size dup * 0 do
    target i cells + @  board i cells + @
    <> if false unloop exit then
  loop true
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
  allot-board to target
  allot-board to board
  target-gen
  target>board
  board-shuffle
  moves-reset
  game-loop
;
