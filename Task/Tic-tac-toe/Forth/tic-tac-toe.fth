create board 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ,

\ board: 0=empty, 1=player X, 2=player O
: player. ( player -- ) C"  XO" 1+ + @ emit ;
: spot ( n -- addr ) cells board + ;
: clean-board ( -- ) 9 0 do 0 i spot ! loop ;

: show-board
  CR ." +---+---+---+  +---+---+---+" CR
  3 0 do
    ." | "
    3 0 do
      i j 3 * + spot @ player. ."  | "
    loop
    ."  | "
    3 0 do
      i j 3 * + . ." | "
    loop
    CR ." +---+---+---+  +---+---+---+" CR
  loop ;

: spots-equal ( n1 n2 n3 -- f )
  over   spot @ swap spot @   = >r   spot @ swap spot @   =   r>   and ;
: spots-win ( n1 n2 n3 -- f )
  dup >r spots-equal r> spot @ 0<> and ;

: winner-check ( -- player )
  0 1 2 spots-win if 0 spot @ exit then
  3 4 5 spots-win if 3 spot @ exit then
  6 7 8 spots-win if 6 spot @ exit then
  0 3 6 spots-win if 0 spot @ exit then
  1 4 7 spots-win if 1 spot @ exit then
  2 5 8 spots-win if 2 spot @ exit then
  0 4 8 spots-win if 0 spot @ exit then
  2 4 6 spots-win if 2 spot @ exit then
  0 ;

: player-move ( player -- )
  begin
    key dup emit [char] 0 - dup
    spot @ 0= if spot ! exit else drop then
  again ;

: game
  clean-board show-board
  9 0 do
    i 2 mod 1+ dup ." Player " player. ." : "
    player-move show-board
    winner-check dup 0<> if player. ."  wins !" unloop exit else drop then
  loop
  ." Draw!" ;

game
