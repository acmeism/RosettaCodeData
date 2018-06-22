import: mapping

: pascal( n -- [] )
   [ 1 ] n #[ dup [ 0 ] + [ 0 ] rot + zipWith( #+ ) ] times ;

: catalan( n -- m )
   n 2 * pascal at( n 1+ ) n 1+ / ;
