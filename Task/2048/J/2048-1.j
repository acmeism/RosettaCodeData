NB. 2048.ijs script
NB. =========================================================
NB. 2048 game engine

require 'guid'
([ 9!:1) _2 (3!:4) , guids 1            NB. randomly set initial random seed

coclass 'g2048'
Target=: 2048

new2048=: verb define
  Gridsz=: 4 4
  Points=: Score=: 0
  Grid=: newnum^:2 ] Gridsz $ 0
)

newnum=: verb define
  num=. 2 4 {~ 0.1 > ?0   NB. 10% chance of 4
  idx=. 4 $. $. 0 = y        NB. indicies of 0s
  if. #idx do.               NB. handle full grid
    idx=. ,/ ({~ 1 ? #) idx  NB. choose an index
    num (<idx)} y
  else. return. y
  end.
)

mskmerge=: [: >/\.&.|. 2 =/\ ,&_1
mergerow=: ((* >:) #~ _1 |. -.@]) mskmerge
scorerow=: +/@(+: #~ mskmerge)

compress=: -.&0
toLeft=: 1 :'4&{.@(u@compress)"1'
toRight=: 1 : '_4&{.@(u@compress&.|.)"1'
toUp=: 1 : '(4&{.@(u@compress)"1)&.|:'
toDown=: 1 : '(_4&{.@(u@compress&.|.)"1)&.|:'

move=: conjunction define
  Points=: +/@, v Grid
  update newnum^:(Grid -.@-: ]) u Grid
)

noMoves=: (0 -.@e. ,)@(mergerow toRight , mergerow toLeft , mergerow toUp ,: mergerow toDown)
hasWon=: Target e. ,

eval=: verb define
  Score=: Score + Points
  isend=. (noMoves , hasWon) y
  msg=. isend # 'You lost!!';'You Won!!'
  if. -. isend=. +./ isend do.
    Points=: 0
    msg=. 'Score is ',(": Score)
  end.
  isend;msg
)

showGrid=: echo

NB. =========================================================
NB. Console user interface

g2048Con_z_=: conew&'g2048con'

coclass 'g2048con'
coinsert 'g2048'

create=: verb define
  echo Instructions
  startnew y
)

destroy=: codestroy
quit=: destroy

startnew=: update@new2048

left=: 3 :'mergerow toLeft move (scorerow toLeft)'
right=: 3 :'mergerow toRight move (scorerow toRight)'
up=: 3 :'mergerow toUp move (scorerow toUp)'
down=: 3 :'mergerow toDown move (scorerow toDown)'

update=: verb define
  Grid=: y       NB. update global Grid
  'isend msg'=. eval y
  echo msg
  showGrid y
  if. isend do. destroy '' end.
  empty''
)

Instructions=: noun define
=== 2048 ===
Object:
   Create the number 2048 by merging numbers.

How to play:
  When 2 numbers the same touch, they merge.
  - move numbers using the commands below:
       right__grd ''
       left__grd ''
       up__grd ''
       down__grd ''
  - quit a game:
       quit__grd ''
  - start a new game:
       grd=: g2048Con ''
)
