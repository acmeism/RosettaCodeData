USING: formatting grouping io kernel lists lists.lazy math
math.functions math.ranges math.statistics math.text.english
prettyprint sequences tools.memory.private ;

! Euler-Mascheroni constant
CONSTANT: γ 0.5772156649

: Hn-approx ( n -- ~Hn )
    [ log γ + 1 2 ] [ * /f + 1 ] [ sq 12 * /f - ] tri ;

: lharmonics ( -- list ) 1 lfrom [ Hn-approx ] lmap-lazy ;

: first-gt ( m -- n ) lharmonics swap '[ _ < ] lwhile llength ;

"First twenty harmonic numbers as mixed numbers:" print
100 [1,b] [ recip ] map cum-sum
[ 20 head 5 group simple-table. nl ]
[ "One hundredth:" print last . nl ] bi

"(zero based) Index of first value:" print
10 [1,b] [
    dup first-gt [ commas ] [ 1 + number>text ] bi
    "  greater than %2d: %6s (term number %s)\n" printf
] each
