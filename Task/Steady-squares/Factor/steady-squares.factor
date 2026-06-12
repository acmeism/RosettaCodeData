USING: formatting kernel math math.functions
math.functions.integer-logs prettyprint sequences
tools.memory.private ;

: steady? ( n -- ? )
    [ sq ] [ integer-log10 1 + 10^ mod ] [ = ] tri ;

1000 <iota> { 1 5 6 } [
    [ 10 * ] dip + dup steady?
    [ dup sq commas "%4d^2 = %s\n" printf ] [ drop ] if
] cartesian-each
