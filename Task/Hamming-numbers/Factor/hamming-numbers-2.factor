USING: combinators fry kernel lists lists.lazy locals math ;
IN: rosetta.hamming-lazy

:: sort-merge ( xs ys -- result )
    xs car :> x
    ys car :> y
    {
        { [ x y < ] [ [ x ] [ xs cdr ys sort-merge ] lazy-cons ] }
        { [ x y > ] [ [ y ] [ ys cdr xs sort-merge ] lazy-cons ] }
        [ [ x ] [ xs cdr ys cdr sort-merge ] lazy-cons ]
    } cond ;

:: hamming ( -- hamming )
    f :> h!
    [ 1 ] [
        h 2 3 5 [ '[ _ * ] lazy-map ] tri-curry@ tri
        sort-merge sort-merge
    ] lazy-cons h! h ;
