USING: fry kernel math.combinatorics math.matrices sequences ;

: permanent ( matrix -- x )
    dup square-matrix? [ "Matrix must be square." throw ] unless
    [ dim first <iota> ] keep
    '[ [ _ nth nth ] map-index product ] map-permutations sum ;
