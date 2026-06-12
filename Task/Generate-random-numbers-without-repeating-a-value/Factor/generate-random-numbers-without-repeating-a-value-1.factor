USING: kernel math.combinatorics math.ranges prettyprint random
sequences ;

: random-permutation ( seq -- newseq )
    [ length dup nPk random ] keep permutation ;

20 [1,b] random-permutation .
