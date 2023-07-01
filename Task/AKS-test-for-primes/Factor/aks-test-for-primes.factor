USING: combinators formatting io kernel make math math.parser
math.polynomials prettyprint sequences ;
IN: rosetta-code.aks-test

! Polynomials are represented by the math.polynomials vocabulary
! as sequences with the highest exponent on the right. Hence
! { -1 1 } represents x - 1.
: (x-1)^ ( n -- seq ) { -1 1 } swap p^ ;

: choose-exp ( n -- str )
    { { 0 [ "" ] } { 1 [ "x" ] } [ "x^%d" sprintf ] } case ;

: choose-coeff ( n -- str )
    [ dup neg? [ neg "- " ] [ "+ " ] if % # ] "" make ;

: terms ( coeffs-seq -- terms-seq )
    [ [ choose-coeff ] [ choose-exp append ] bi* ] map-index ;

: (.p) ( n -- str ) (x-1)^ terms <reversed> " " join 3 tail ;

: .p ( n -- ) dup zero? [ drop "1" ] [ (.p) ] if print ;

: show-poly ( n -- ) [ "(x-1)^%d = " printf ] [ .p ] bi ;

: part1 ( -- ) 8 <iota> [ show-poly ] each ;

: (prime?) ( n -- ? )
    (x-1)^ rest but-last dup first [ mod 0 = not ] curry find
    nip not ;

: prime? ( n -- ? ) dup 2 < [ drop f ] [ (prime?) ] if ;

: part2 ( -- )
    "Primes up to 50 via AKS:" print
    50 <iota> [ prime? ] filter . ;

: aks-test ( -- ) part1 nl part2 ;

MAIN: aks-test
