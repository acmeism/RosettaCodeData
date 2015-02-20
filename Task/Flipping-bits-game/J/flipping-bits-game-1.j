start=:3 :0
  Moves=:0
  N=:i.y
  Board=: ?2$~,~y
  'fr fc'=. (2,y)$}.#:(+?&.<:@<:)2x^2*y
  End=: fr~:fc~:"1 Board
  Board;End
)

abc=:'abcdefghij'
move=:3 :0
  fc=. N e.abc i. y ([-.-.)abc
  fr=. N e._-.~_ "."0 abc-.~":y
  Board=: fr~:fc~:"1 Board
  smoutput (":Moves=:Moves++/fr,fc),' moves'
  if. Board-:End do.
    'yes'
  else.
    Board;End
  end.
)
