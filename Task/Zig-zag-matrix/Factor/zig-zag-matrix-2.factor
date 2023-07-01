USING: assocs assocs.extras grouping io kernel math
math.combinatorics math.matrices prettyprint sequences ;

: <zig-zag-matrix> ( n -- matrix )
    [
        dup [ + ] <matrix-by-indices> concat zip-index
        expand-keys-push-at values [ even? [ reverse ] when ]
        map-index concat inverse-permutation
    ] [ group ] bi ;

5 <zig-zag-matrix> simple-table.
