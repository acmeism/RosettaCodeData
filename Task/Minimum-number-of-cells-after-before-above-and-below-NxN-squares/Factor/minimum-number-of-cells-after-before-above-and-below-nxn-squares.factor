USING: io kernel math math.matrices math.vectors prettyprint
sequences ;

: square ( n -- matrix )
    [ <cartesian-square-indices> ] keep 1 - dup
    '[ dup sum _ > [ _ v-n vabs ] when infimum ] matrix-map ;

{ 10 9 2 1 } [ square simple-table. nl ] each
