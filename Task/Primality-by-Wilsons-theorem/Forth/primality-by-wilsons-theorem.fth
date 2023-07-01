: fac-mod ( n m -- r )
    >r 1 swap
    begin dup 0> while
        dup rot * r@ mod  swap 1-
    repeat drop rdrop ;

: ?prime ( n -- f )
    dup 1- tuck swap fac-mod = ;

: .primes ( n -- )
    cr 2 ?do i ?prime if i . then loop ;
