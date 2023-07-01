USING: grouping io kernel math math.combinatorics math.ranges
prettyprint sequences ;

: possible-dice ( n -- seq )
    [ [1,b] ] [ selections ] bi [ [ <= ] monotonic? ] filter ;

: cmp ( seq seq -- n ) [ - sgn ] cartesian-map concat sum ;

: non-transitive? ( seq -- ? )
   [ 2 clump [ first2 cmp neg? ] all? ]
   [ [ last ] [ first ] bi cmp neg? and ] bi ;

: find-non-transitive ( #sides #dice -- seq )
    [ possible-dice ] [ <k-permutations> ] bi*
    [ non-transitive? ] filter ;

! Task
"Number of eligible 4-sided dice: " write
4 possible-dice length . nl

"All ordered lists of 3 non-transitive dice with 4 sides:" print
4 3 find-non-transitive . nl

"All ordered lists of 4 non-transitive dice with 4 sides:" print
4 4 find-non-transitive .
