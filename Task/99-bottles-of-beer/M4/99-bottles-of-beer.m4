define(`BOTTLES', `bottles of beer')dnl
define(`BOTTLE', `bottle of beer')dnl
define(`WALL', `on the wall')dnl
define(`TAKE', `take one down, pass it around')dnl
define(`NINETEEN', `$1 ifelse(`$1',`1',BOTTLE,BOTTLES) WALL
$1 ifelse(`$1',`1',BOTTLE,BOTTLES)
ifelse(`$1',`0',,`TAKE')
ifelse(`$1',`0',,`NINETEEN(eval($1-1))')')dnl
NINETEEN(99)
