USING: kernel lists lists.lazy math math.primes prettyprint
sequences ;

: lcousins ( -- list )
    L{ { 3 7 } } 7 11 [ [ 6 + ] lfrom-by ] bi@ lzip lappend-lazy
    [ [ prime? ] all? ] lfilter ;

lcousins [ last 1000 < ] lwhile [ . ] leach
