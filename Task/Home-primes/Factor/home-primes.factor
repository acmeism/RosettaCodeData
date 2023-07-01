USING: formatting kernel make math math.parser math.primes
math.primes.factors math.ranges present prettyprint sequences
sequences.extras ;

: squish ( seq -- n ) [ present ] map-concat dec> ;

: next ( m -- n ) factors squish ; inline

: (chain) ( n -- ) [ dup prime? ] [ dup , next ] until , ;

: chain ( n -- seq ) [ (chain) ] { } make ;

: prime. ( n -- ) dup "HP%d = %d\n" printf ;

: setup ( seq -- n s r ) unclip-last swap dup length 1 [a,b] ;

: multi. ( n -- ) chain setup [ "HP%d(%d) = " printf ] 2each . ;

: chain. ( n -- ) dup prime? [ prime. ] [ multi. ] if ;

2 20 [a,b] [ chain. ] each
