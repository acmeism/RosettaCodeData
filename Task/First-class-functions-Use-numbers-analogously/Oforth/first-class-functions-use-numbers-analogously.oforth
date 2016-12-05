: multiplier(n1, n2)  #[ n1 n2 * * ] ;

: firstClassNum
| x xi y yi z zi |
   2.0 ->x
   0.5 ->xi
   4.0 ->y
   0.25 ->yi
   x y + ->z
   x y + inv ->zi
   [ x, y, z ] [ xi, yi, zi ] zipWith(#multiplier) map(#[ 0.5 swap perform ] ) . ;
