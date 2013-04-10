-1 cells constant -cell
: cell-   -cell + ;

defer lessthan ( a@ b@ -- ? )   ' < is lessthan

: mid ( l r -- mid ) over - 2/ -cell and + ;

: exch ( addr1 addr2 -- ) dup @ >r over @ swap ! r> swap ! ;

: part ( l r -- l r r2 l2 )
  2dup mid @ >r ( r: pivot )
  2dup begin
    swap begin dup @  r@ lessthan while cell+ repeat
    swap begin r@ over @ lessthan while cell- repeat
    2dup <= if 2dup exch >r cell+ r> cell- then
  2dup > until  r> drop ;

0 value midpoint

: select ( l r -- )
  begin 2dup < while
    part
    dup  midpoint >= if nip nip ( l l2 ) else
    over midpoint <= if drop rot drop swap ( r2 r ) else
    2drop 2drop exit then then
  repeat 2drop ;

: median ( array len -- m )
  1- cells over +  2dup mid to midpoint
  select           midpoint @ ;
