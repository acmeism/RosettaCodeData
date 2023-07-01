USING: assocs combinators formatting kernel math math.functions
math.ranges math.statistics namespaces pair-rocket sequences ;
IN: rosetta-code.fibonacci-word

SYMBOL: 37th-fib-word

: fib ( n -- m )
    {
        1 => [ 1 ]
        2 => [ 1 ]
        [ [ 1 - fib ] [ 2 - fib ] bi + ]
    } case ;

: fib-word ( n -- seq )
    {
        1 => [ "1" ]
        2 => [ "0" ]
        [ [ 1 - fib-word ] [ 2 - fib-word ] bi append ]
    } case ;

: nth-fib-word ( n -- seq )
    dup 1 =
    [ drop "1" ] [ 37th-fib-word get swap fib head ] if ;

: entropy ( seq -- entropy )
    [ length ] [ histogram >alist [ second ] map ] bi
    [ swap / ] with map
    [ dup log 2 log / * ] map-sum
    dup 0. = [ neg ] unless ;

37 fib-word 37th-fib-word set
"N" "Length" "Entropy" "%2s  %8s  %10s\n" printf
37 [1,b] [
   dup nth-fib-word [ length ] [ entropy ] bi
   "%2d  %8d  %.8f\n" printf
] each
