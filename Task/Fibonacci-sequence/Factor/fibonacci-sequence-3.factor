: fib2 ( x y n -- a )
  dup 1 <
    [ 2drop ]
    [ [ swap [ + ] keep ] dip 1 - fib2 ]
  if ;
: fib ( n -- m ) [ 0 1 ] dip fib2 ;
