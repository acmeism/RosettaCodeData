import: mapping

: nextCoef( prev -- [] )
| i |
   Array new 0 over dup
   prev size 1- loop: i [ prev at(i) prev at(i 1+) - over add ]
   0 over add
;

: coefs( n -- [] )
    [ 0, 1, 0 ] #nextCoef times(n) extract(2, n 2 + ) ;

: prime?( n -- b)
    coefs( n ) extract(2, n) conform?( #[n mod 0 == ] ) ;

: aks
| i |
   0 10 for: i [ System.Out "(x-1)^" << i << " = " << coefs( i ) << cr ]
   50 seq filter( #prime? ) apply(#.) printcr
;
