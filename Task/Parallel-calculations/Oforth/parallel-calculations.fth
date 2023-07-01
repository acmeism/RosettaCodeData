import: parallel

: largeMinFactor  dup mapParallel(#factors) zip maxFor(#[ second first ]) ;
