BEGIN
    # show the results of exponentiation and unary minus in various combinations #
    FOR x FROM -5 BY 10 TO 5 DO
        FOR p FROM 2 TO 3 DO
            print( ( "x = ", whole( x, -2 ), " p = ", whole( p, 0 ) ) );
            print( ( "     -x**p  ", whole(   -x**p,  -4 ) ) );
            print( ( "   -(x)**p  ", whole( -(x)**p,  -4 ) ) );
            print( ( "   (-x)**p  ", whole( (-x)**p,  -4 ) ) );
            print( ( "    -(x**p) ", whole(  -(x**p), -4 ) ) );
            print( ( newline ) )
        OD
    OD
END
