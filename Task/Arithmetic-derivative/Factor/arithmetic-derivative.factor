USING: combinators formatting grouping io kernel math
math.primes.factors prettyprint ranges sequences ;

: n' ( m -- n )
    {
        { [ dup neg? ] [ neg n' neg ] }
        { [ dup 2 < ] [ drop 0 ] }
        { [ factors dup length 1 = ] [ drop 1 ] }
        [ unclip-slice swap product 2dup n' * spin n' * + ]
    } cond ;

-99 100 [a..b] [ n' ] map 10 group
[ [ "%5d" printf ] each nl ] each
