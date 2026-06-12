USING: kernel lists lists.lazy math.primes prettyprint sequences ;

: prime-fib ( -- list )
    { 0 1 } [ [ rest ] [ sum suffix ] bi ] lfrom-by
    [ second ] lmap-lazy [ prime? ] lfilter ;

9 prime-fib ltake [ . ] leach
