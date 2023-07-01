USING: fry kernel math math.ranges namespaces sequences ;

SYMBOL: swapped?

: dupd+ ( m obj -- m n obj ) [ dup 1 + ] dip ;

: 2nth ( n seq -- elt1 elt2 ) dupd+ [ nth ] curry bi@ ;

: ?exchange ( n seq -- )
    2dup 2nth > [ dupd+ exchange swapped? on ] [ 2drop ] if ;

: cocktail-pass ( seq forward? -- )
    '[ length 2 - 0 _ [ swap ] when [a,b] ] [ ] bi
    [ ?exchange ] curry each ;

: (cocktail-sort!) ( seq -- seq' )
    swapped? off dup t cocktail-pass
    swapped? get [ dup f cocktail-pass ] when ;

: cocktail-sort! ( seq -- seq' )
    [ swapped? get ] [ (cocktail-sort!) ] do while ;
