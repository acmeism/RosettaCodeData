USING: combinators kernel locals math prettyprint ;

:: sudan ( n x y -- z )
    {
        { [ n zero? ] [ x y + ] }
        { [ y zero? ] [ x ] }
        [ n 1 - n x y 1 - sudan dup y + sudan ]
    } cond ;
