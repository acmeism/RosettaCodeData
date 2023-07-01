USING: kernel math sequences sequences.extras ;

: select ( m n seq -- )
    [ dup ] 2dip [ <slice> [ ] infimum-by* drop over + ]
    [ exchange ] bi ;

: selection-sort! ( seq -- seq' )
    [ ] [ length dup ] [ ] tri [ select ] 2curry each-integer ;
