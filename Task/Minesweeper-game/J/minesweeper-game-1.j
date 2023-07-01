NB. minefield.ijs script
NB. =========================================================
NB. Game engine

NB.require 'guid'
NB.([ 9!:1) _2 (3!:4) , guids 1            NB. randomly set initial random seed

coclass 'mineswpeng'

newMinefield=: 3 : 0
  if. 0=#y do. y=. 9 9 end.
  Marked=: Cleared=: y$0
  NMines=: <. */(0.01*10+?20),y            NB. 10..20% of tiles are mines
  mines=. (i. e. NMines ? */) y            NB. place mines
  Map=: (9*mines) >. y{. (1,:3 3) +/@,;.3 (-1+y){.mines
)

markTiles=: 3 : 0
  Marked=: (<"1 <:y) (-.@{)`[`]} Marked    NB. toggle marked state of cell(s)
)

clearTiles=: clearcell@:<:                 NB. decrement coords - J arrays are 0-based

clearcell=: verb define
  if. #y do.
    free=. (#~ (Cleared < 0 = Map) {~ <"1) y
    Cleared=: 1 (<"1 y)} Cleared           NB. set cell(s) as cleared
    if. #free do.
      clearcell (#~ Cleared -.@{~ <"1) ~. (<:$Map) (<."1) 0 >. getNbrs free
    end.
  end.
)

getNbrs=: [: ,/^:(3=#@$) +"1/&(<: 3 3#: i.9)

eval=: verb define
  if. 9 e. Cleared #&, Map do.            NB. cleared mine(s)?
    1; 'KABOOM!!'
  elseif. *./ 9 = (-.Cleared) #&, Map do. NB. all cleared except mines?
    1; 'Minefield cleared.'
  elseif. do.                             NB. else...
    0; (": +/, Marked>Cleared),' of ',(":NMines),' mines marked.'
  end.                                    NB. result: isEnd; message
)

showField=: 4 : 0
  idx=. y{ (2 <. Marked + +:Cleared) ,: 2
  |: idx} (11&{ , 12&{ ,: Map&{) x  NB. transpose result - J arrays are row,column
)

NB. =========================================================
NB. User interface

Minesweeper_z_=: conew&'mineswp'

coclass 'mineswp'
coinsert 'mineswpeng'        NB. insert game engine locale in copath

Tiles=: ' 12345678**.?'

create=: verb define
  smoutput Instructions
  startgame y
)
destroy=: codestroy
quit=: destroy

startgame=: update@newMinefield
clear=: update@clearTiles
mark=: update@markTiles

update=: 3 : 0
  'isend msg'=. eval ''
  smoutput msg
  smoutput < Tiles showField isend
  if. isend do.
    msg=. ('K'={.msg) {:: 'won';'lost'
    smoutput 'You ',msg,'! Try again?'
    destroy ''
  end.
  empty''
)

Instructions=: 0 : 0
=== MineSweeper ===
Object:
   Uncover (clear) all the tiles that are not mines.

How to play:
 - the left, top tile is: 1 1
 - clear an uncleared tile (.) using the command:
      clear__fld <column index> <row index>
 - mark and uncleared tile (?) as a suspected mine using the command:
      mark__fld <column index> <row index>
 - if you uncover a number, that is the number of mines adjacent
   to the tile
 - if you uncover a mine (*) the game ends (you lose)
 - if you uncover all tiles that are not mines the game ends (you win).
 - quit a game before winning or losing using the command:
      quit__fld ''
 - start a new game using the command:
      fld=: MineSweeper <num columns> <num rows>
)
