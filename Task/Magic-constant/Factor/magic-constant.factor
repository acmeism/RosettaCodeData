USING: formatting io kernel math math.functions.integer-logs
math.ranges prettyprint sequences ;

: magic ( m -- n ) dup sq 1 + 2 / * ;

"First 20 magic constants:" print
3 22 [a,b] [ bl ] [ magic pprint ] interleave nl
nl
"1000th magic constant: " write 1002 magic .
nl
"Smallest order magic square with a constant greater than:" print
1 0 20 [
    [ 10 * ] dip
    [ dup magic pick < ] [ 1 + ] while
    over integer-log10 over "10^%02d: %d\n" printf
    dup + 1 -
] times 2drop
