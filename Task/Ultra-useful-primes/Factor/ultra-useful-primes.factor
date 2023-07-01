USING: io kernel lists lists.lazy math math.primes prettyprint ;

: useful ( -- list )
    1 lfrom
    [ 2^ 2^ 1 lfrom [ - prime? ] with lfilter car ] lmap-lazy ;

10 useful ltake [ pprint bl ] leach nl
