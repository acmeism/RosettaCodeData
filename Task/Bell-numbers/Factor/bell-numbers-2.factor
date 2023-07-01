USING: formatting kernel math math.combinatorics sequences ;

: next-bell ( seq -- n )
    dup length 1 - [ swap nCk * ] curry map-index sum ;

: bells ( n -- seq )
    V{ 1 } clone swap 1 - [ dup next-bell suffix! ] times ;

50 bells [ 15 head ] [ last ] bi
"First 15 Bell numbers:\n%[%d, %]\n\n50th: %d\n" printf
