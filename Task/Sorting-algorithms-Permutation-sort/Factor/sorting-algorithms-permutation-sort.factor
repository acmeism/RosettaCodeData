USING: grouping io math.combinatorics math.order prettyprint ;
IN: rosetta-code.permutation-sort

: permutation-sort ( seq -- seq' )
    [ [ before=? ] monotonic? ] find-permutation ;

{ 10 2 6 8 1 4 3 } permutation-sort .
"apple" permutation-sort print
