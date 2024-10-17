BEGIN
    REAL c real, c imaginary;
    STRING real and imaginary := IF argc < 3 THEN "-0.8"  ELSE argv( 3 ) FI
                               + " "
                               + IF argc < 4 THEN "0.156" ELSE argv( 4 ) FI
                               + " "
                               ;
    FILE numbers;
    associate( numbers, real and imaginary );
    get( numbers, ( c real, c imaginary ) );
    print( ( fixed( c real, -8, 4 ), fixed( c imaginary, -8, 4 ), newline ) );
    FOR v FROM -100 BY 10 TO 100 DO
        FOR h FROM -280 BY 10 TO 280 DO
            REAL x := h / 200;
            REAL y := v / 100;
            CHAR plot char := "#";
            TO 50 WHILE
                    REAL z real      = ( x * x ) - ( y * y ) + c real;
                    REAL z imaginary = ( x * y * 2 ) + c imaginary;
                    IF z real * z real <= 10000
                    THEN TRUE
                    ELSE plot char := " ";
                         FALSE
                    FI
            DO
                x := z real;
                y := z imaginary
            OD;
            print( ( plot char ) )
        OD;
        print( ( newline ) )
    OD
END
