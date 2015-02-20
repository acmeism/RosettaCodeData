9!:21]2^34

unpack=:verb define
  mask=. +./' '~:y
  board=. (255 0 1{a.) {~ {.@:>:@:"."0 mask#"1 y
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

solve=:verb define
  board=.,:y
  for_move.1+i.+/({.a.)=,y do.
    board=. ;move <@knight"2 board
  end.
)

kmoves=: ,/(2 1,:1 2)*"1/_1^#:i.4

knight=:dyad define
  pos=. ($y)#:(,y)i.x{a.
  moves=. <"1(#~ 0&<: */"1@:* ($y)&>"1)pos+"1 kmoves
  moves=. (#~ (0{a.)={&y) moves
  moves y adverb def (':';'y x} m')"0 (x+1){a.
)
