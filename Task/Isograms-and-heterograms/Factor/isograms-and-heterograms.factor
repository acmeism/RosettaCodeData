USING: assocs combinators.short-circuit.smart grouping io
io.encodings.ascii io.files kernel literals math math.order
math.statistics sequences sets sorting ;

CONSTANT: words $[ "unixdict.txt" ascii file-lines ]

: isogram<=> ( a b -- <=> )
    { [ histogram values first ] [ length ] } compare-with ;

: isogram-sort ( seq -- seq' )
    [ isogram<=> invert-comparison ] sort ;

: isogram? ( seq -- ? )
    histogram values { [ first 1 > ] [ all-eq? ] } && ;

: .words-by ( quot -- )
    words swap filter isogram-sort [ print ] each ; inline

"List of n-isograms where n > 1:" print
[ isogram? ] .words-by nl

"List of heterograms of length > 10:" print
[ { [ length 10 > ] [ all-unique? ] } && ] .words-by
