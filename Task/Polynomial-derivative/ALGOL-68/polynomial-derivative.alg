BEGIN # find the derivatives of polynominals, given their coefficients #
    # returns the derivative polynominal of the polynominal defined by #
    #         the array of coeficients, where the coefficients are in  #
    #         order of increasing power of x                          #
    OP DERIVATIVE = ( []INT p )[]INT:
    BEGIN
        [ 1 : UPB p - 1 ]INT result;
        FOR i FROM 2 TO UPB p DO
            result[ i - 1 ] := ( i - 1 ) * p[ i ]
        OD;
        result
    END # DERIVATIVE # ;
    # prints the polynomial defined by the coefficients in p #
    OP SHOW = ( []INT p )VOID:
    BEGIN
        BOOL first := TRUE;
        FOR i FROM UPB p BY -1 TO LWB p DO
            IF p[ i ] /= 0 THEN
                IF first THEN
                    IF   p[ i ] < 0 THEN print( ( "-" ) ) FI
                ELSE
                    IF   p[ i ] < 0
                    THEN print( ( " - " ) )
                    ELSE print( ( " + " ) )
                    FI
                FI;
                first := FALSE;
                IF   i = LWB p
                THEN print( ( whole( ABS p[ i ], 0 ) ) )
                ELSE
                    IF ABS p[ i ] > 1 THEN print( ( whole( ABS p[ i ], 0 ) ) ) FI;
                    print( ( "x" ) );
                    IF i > LWB p + 1 THEN print( ( "^", whole( i - 1, 0 ) ) ) FI
                FI
            FI
        OD;
        IF first THEN
            # all coefficients were 0 #
            print( ( "0" ) )
        FI
    END # SHOW # ;
    # task test cases #
    PROC test = ( []INT p )VOID: BEGIN SHOW p; print( ( " -> " ) ); SHOW DERIVATIVE p; print( ( newline ) ) END;
    test( ( 5 ) ); test( ( 4, -3 ) ); test( ( -1, 6, 5 ) ); test( ( -4, 3, -2, 1 ) ); test( ( 1, 1, 0, -1, -1 ) )
END
