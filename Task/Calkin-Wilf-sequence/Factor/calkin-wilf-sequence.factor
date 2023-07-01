USING: formatting io kernel lists lists.lazy math
math.continued-fractions math.functions math.parser prettyprint
sequences strings vectors ;

: next-cw ( x -- y ) [ floor dup + ] [ 1 swap - + recip ] bi ;

: calkin-wilf ( -- list ) 1 [ next-cw ] lfrom-by ;

: >continued-fraction ( x -- seq )
    1vector [ dup last integer? ] [ dup next-approx ] until
    dup length even? [ unclip-last 1 - suffix! 1 suffix! ] when ;

: cw-index ( x -- n )
    >continued-fraction <reversed>
    [ even? CHAR: 1 CHAR: 0 ? <string> ] map-index concat bin> ;

! Task
"First 20 terms of the Calkin-Wilf sequence:" print
20 calkin-wilf ltake [ pprint bl ] leach nl nl

83116/51639 cw-index "83116/51639 is at index %d.\n" printf
