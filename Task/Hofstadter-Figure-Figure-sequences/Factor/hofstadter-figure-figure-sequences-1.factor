SYMBOL: S  V{ 2 } S set
SYMBOL: R  V{ 1 } R set

: next ( s r -- news newr )
2dup [ last ] bi@ + suffix
dup [
  [ dup last 1 + dup ] dip member? [ 1 + ] when suffix
] dip ;

: inc-SR ( n -- )
dup 0 <=
[ drop ]
[ [ S get R get ] dip  [ next ] times  R set S set ]
if ;

: ffs ( n -- S(n) )
dup S get length - inc-SR
1 - S get nth ;
: ffr ( n -- R(n) )
dup R get length - inc-SR
1 - R get nth ;
