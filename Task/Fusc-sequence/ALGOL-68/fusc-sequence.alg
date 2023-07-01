BEGIN
    # calculate some members of the fusc sequence              #
    #    f0 = 0, f1 = 1, fn = f(n/2)                 if n even #
    #                       = f(n-1)/2) + f((n+1)/2) if n odd  #

    # constructs an array of the first n elements of the fusc sequence #
    PROC fusc sequence = ( INT n )[]INT:
         BEGIN
            [ 0 : n ]INT a;
            IF n > 0 THEN
                a[ 0 ] := 0;
                IF n > 1 THEN
                    a[ 1 ] := 1;
                    INT i2 := 1;
                    FOR i FROM 2 BY 2 TO n - 1 DO
                        a[ i     ] := a[ i2 ];
                        a[ i + 1 ] := a[ # j - i # i2 ] + a[ # ( j + 1 ) OVER 2 # i2 + 1 ];
                        i2 +:= 1
                    OD
                FI
            FI;
            a[ 0 : n - 1 AT 0 ]
         END ; # fusc #

    []INT f = fusc sequence( 800 000 );
    FOR i FROM 0 TO 60 DO print( ( " ", whole( f[ i ], 0 ) ) ) OD;
    print( ( newline ) );
    # find the lowest elements of the sequence that have 1, 2, 3, etc. digits #
    print( ( "Sequence elements where number of digits of the value increase:", newline ) );
    print( ( "       n    fusc(n)", newline ) );
    INT digit power := 0;
    FOR i FROM LWB f TO UPB f DO
        IF f[ i ] >= digit power THEN
            # found the first number with this many digits #
            print( ( whole( i, -8 ), " ", whole( f[ i ], -10 ), newline ) );
            IF digit power = 0 THEN digit power := 1 FI;
            digit power *:= 10
        FI
    OD
END
