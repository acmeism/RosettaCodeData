USING: math.ranges locals ;
IN: rosetta-gray

: gray-encode ( n -- n' ) dup -1 shift bitxor ;

:: gray-decode ( n! -- n' )
   n :> p!
   [ n -1 shift dup n! 0 = not ] [
     p n bitxor p!
   ] while
   p ;

: main ( -- )
  -1 32 [a,b] [ dup [ >bin ] [ gray-encode ] bi [ >bin ] [ gray-decode ] bi 4array . ] each ;

MAIN: main
