USING: assocs assocs.extras formatting io kernel math
math.functions math.parser math.primes math.ranges present
sequences ;

: prime?* ( n -- ? ) [ prime? ] [ f ] if* ; inline

: (bases) ( n -- range quot )
    present 2 36 [a,b] [ base> prime?* ] with ; inline

: <digits> ( n -- range ) [ 1 - ] keep [ 10^ ] bi@ [a,b) ;

: multibase ( n -- assoc )
    <digits> [ (bases) count ] zip-with assoc-invert
    expand-keys-push-at >alist [ first ] supremum-by ;

: multibase. ( n -- )
    dup multibase first2
    [ "%d-digit numbers that are prime in the most bases: %d\n" printf ] dip
    [ dup (bases) filter "%d => %[%d, %]\n" printf ] each ;

4 [1,b] [ multibase. nl ] each
