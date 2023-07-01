USING: formatting io kernel locals math math.functions
math.ranges prettyprint sequences tools.memory.private ;

:: isqrt ( x -- n )
    1 :> q!
    [ q x > ] [ q 4 * q! ] until
    x 0 :> ( z! r! )
    [ q 1 > ] [
        q 4 /i q!
        z r - q - :> t
        r -1 shift r!
        t 0 >= [
            t z!
            r q + r!
        ] when
    ] while
    r ;

"Integer square root for numbers 0 to 65 (inclusive):" print
66 <iota> [ bl ] [ isqrt pprint ] interleave nl nl

: align ( str str str -- ) "%2s%85s%44s\n" printf ;
: show ( n -- ) dup 7 swap ^ dup isqrt [ commas ] tri@ align ;

"x" "7^x" "isqrt(7^x)" align
"-" "---" "----------" align
1 73 2 <range> [ show ] each
