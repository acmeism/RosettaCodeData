BEGIN # Moser's circle problem                                               #

    # returns the binomial coefficient ( n k )                               #
    PROC binomial = ( INT n, k )INT:
         IF k > n OR k < 0 THEN 0
         ELSE
            INT bc := 1;
            FOR i TO k DO bc := ( bc * ( n - i + 1 ) ) OVER i OD;
            bc
         FI # binomial # ;

    # returns the first n numbers using the quartic equation                 #
    PROC moser q values = ( INT n )[]INT:
         BEGIN
            [ 1 : n ]INT values;
            FOR i TO n DO
                values[ i ] := ( i * ( i * ( i * ( i - 6 ) + 23 ) - 18 ) + 24 ) OVER 24
            OD;
            values
         END # moser q values # ;

    # returns the first n numbers, using the 5th element of the rows of      #
    #         Bernoulli's triangle                                           #
    PROC moser btriangle values = ( INT n )[]INT:
         BEGIN
            [ 1 : n ]INT row, values;
            INT p2 := 1;
            FOR line TO n DO
                FOR j FROM line - 1 BY -1 TO 2 DO
                    row[ j ] +:= row[ j - 1 ]
                OD;
                row[ line ] := p2;
                values[ line ] := row[ IF line < 5 THEN line ELSE 5 FI ];
                p2 +:= p2
            OD;
            values
         END # moser btriangle values # ;

    # returns the first n numbers, using the sum of the first 5 elements of  #
    #         the rows of Pascal's triangle                                  #
    PROC moser ptriangle values = ( INT n )[]INT:
         BEGIN
            [ 1 : n ]INT row, values;
            FOR line TO n DO
                FOR i FROM line - 1 BY - 1 TO 2 DO row[ i ] +:= row[ i - 1 ] OD;
                row[ line ] := 1;
                values[ line ] := row[ 1 ];
                FOR i FROM 2 TO IF line < 5 THEN line ELSE 5 FI DO values[ line ] +:= row[ i ] OD
            OD;
            values
         END # moser ptriangle values # ;

    # returns the first n numbers, using binomial coefficients               #
    PROC moser bc values = ( INT n )[]INT:
         BEGIN
            [ 1 : n ]INT values;
            FOR i TO n DO values[ i ] := binomial( i, 4 ) + binomial( i, 2 ) + 1 OD;
            values
         END # moser bc values # ;

    # returns the first n numbers, using the Binomial transform of           #
    #         1, 1, 1, 1, 1, 0, 0, ...                                       #
    PROC moser bt values = ( INT n )[]INT:
         BEGIN
            [ 1 : n ]INT values;
            FOR i TO n DO
                values[ i ] := 0;
                FOR k FROM 0 TO IF i < 5 THEN i ELSE 4 FI DO values[ i ] +:= binomial( i - 1, k ) OD
            OD;
            values
         END # moser bt values # ;

    BEGIN # show the first 20 values by various methods                      #

        # shows the first nv Moser values                                    #
        PROC show moser values = ( STRING label, PROC(INT)[]INT mf, INT nv )VOID:
             BEGIN
                 print( ( newline, "... calculated by the ", label, " method:", newline, "   " ) );
                 []INT values = mf( nv );
                 FOR i TO nv DO print( ( " ", whole( values[ i ], 0 ) ) ) OD;
                 print( ( newline ) )
             END # show moser values # ;

        print( ( "The first 20 values of Moser's circle problem...", newline ) );

        show moser values( "quartic equation",      moser q values,         20 );
        show moser values( "Bernoulli's triangle",  moser btriangle values, 20 );
        show moser values( "Pascal's triangle",     moser ptriangle values, 20 );
        show moser values( "Binomial coefficients", moser bc values,        20 );
        show moser values( "Binomial transform",    moser bt values,        20 )
    END
END
