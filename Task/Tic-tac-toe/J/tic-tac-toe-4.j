'`turn board'=. {.`}.
Until=. {{u^:(-.@:v)^:_.}}                                                NB. apply u until v is true
full=. {{-. 0 e. board y}}                                                NB. board is full (tie game)
open=. {{0 = x { board y}}                                                NB. given pos is free on board
invalid=. {{-. (y open ::0 x) *. y e.i.9}}                                NB. test for invalid position
cpu=. {{(?#o) { o=.I.0=board y}}                                          NB. cpu's move
pos=. {{cpu`you@.(1 = turn y)y}}                                          NB. get cpu's or user's move
you=. {{y {{you x[echo'no'}}^:(y invalid p) p=.<:0".(1!:1)1[echo'move (1-9):'}} NB. your move
move=. {{(- turn y) , (turn y) (pos y)} board y}}                         NB. apply move to the board
outcome=. {{ 'tie'"_ ` {{('.XO'{~-turn y),' wins'}}@.won y}}              NB. print game outcome
show=. {{y [ echo'','',~([,' ',])/"1 '.XO'{~3 3$board y}}                 NB. display the board
'`diag antid'=. {{(<0 1)|:y}} ` {{(<0 1)|:|.y}}                           NB. get (anti-)diagonal
won=. {{+./3=|+/"1 B,(|:B),(antid B),:diag B=.3 3$board y}}               NB. has game been won?
game=: {{outcome (show@move Until (won+.full)) _1,9#0[y}}
