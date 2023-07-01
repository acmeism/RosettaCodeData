USING: combinators kernel math prettyprint ;

: sudan ( n x y -- z )
    {
        { [ pick zero? ] [ nipd + ] }
        { [ dup zero? ] [ drop nip ] }
        [
            [ 2drop 1 - ]
            [ 1 - sudan dup ]
            [ 2nip + sudan ] 3tri
        ]
    } cond ;

3 1 1 sudan .
