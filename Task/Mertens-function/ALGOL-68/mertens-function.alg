BEGIN # compute values of the Mertens function                      #
    # Generate Mertens numbers                                      #
    [ 1 : 1000 ]INT m;
    m[ 1 ] := 1;
    FOR n FROM 2 TO UPB m DO
        m[ n ] := 1;
        FOR k FROM 2 TO n DO m[ n ] -:= m[ n OVER k ] OD
    OD;
    # Print table                                                   #
    print( ( "The first 99 Mertens numbers are:", newline ) );
    print( ( "   " ) );
    INT left := 9;
    FOR n TO 99 DO
        print( ( whole( m[ n ], -3 ) ) );
        IF ( left -:= 1 ) = 0 THEN
            left := 10;
            print( ( newline ) )
        FI
    OD;
    # Calculate zeroes and crossings                                #
    INT zero  := 0;
    INT cross := 0;
    FOR n FROM 2 TO UPB m DO
        IF m[ n ] = 0 THEN
            zero +:= 1;
            IF m[ n - 1 ] /= 0 THEN cross +:= 1 FI
        FI
    OD;
    print( ( newline ) );
    print( ( "M(N) is zero      ", whole( zero,  -4 ), " times.", newline ) );
    print( ( "M(N) crosses zero ", whole( cross, -4 ), " times.", newline ) )
END
