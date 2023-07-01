: newdigit ( col row -- u ) 10 * + C" 0317598642709215486342068713591750983426612304597836742095815869720134894536201794386172052581436790" 1+ + c@ 48 - ;
: nextdigit ( addr -- addr+1 u ) dup c@ 48 - swap 1+ swap ;

: damm ( c u -- u )
0 rot rot
0 do
  nextdigit
  rot newdigit swap
loop drop
;

: isdamm? damm 0= if ." yes" else ." no" then ;

: .damm
2dup damm
rot rot type 48 + emit
;
