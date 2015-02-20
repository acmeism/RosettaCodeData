unpack=:verb define
  mask=. +./' '~:y
  board=. __ 0 1 {~ {.@:>:@:"."0 mask#"1 y
)

ex1=:unpack ];._2]0 :0
  0 0 0
  0   0 0
  0 0 0 0 0 0 0
0 0 0     0   0
0   0     0 0 0
1 0 0 0 0 0 0
    0 0   0
      0 0 0
)

solve1=:verb define
 (1,+/0=,y) solve1 ,:y
:
  for_block._10 <\ y do.
    board=. ;({.x) <@knight"2 ;block
    if. #board do.
      if. =/x do.
        {.board return.
      else.
        board=. (1 0+x) solve1 board
        if. #board do.
          board return.
        end.
      end.
    end.
  end.
  i.0 0
)

kmoves=: ,/(2 1,:1 2)*"1/_1^#:i.4

knight=:dyad define
  pos=. ($y)#:(,y)i.x
  moves=. <"1(#~ 0&<: */"1@:* ($y)&>"1)pos+"1 kmoves
  moves=. (#~ 0={&y) moves
  moves y adverb def (':';'y x} m')"0 x+1
)
