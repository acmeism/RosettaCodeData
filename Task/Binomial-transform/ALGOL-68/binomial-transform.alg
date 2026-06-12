BEGIN # binomial transform - translation of the C sample                     #
    # returns factorial n, n must be at most 20                              #
    PROC factorial = ( INT n )LONG INT:
         IF n > 20 THEN 0 # too big for LONG INT                             #
         ELSE
            LONG INT factorial n := 1;
            FOR i FROM 2 TO n DO factorial n *:= i OD;
            factorial n
         FI # factorial # ;
    # returns the binomial coefficient ( n k )                               #
    PROC binomial = ( INT n, k )LONG INT:
         factorial( n ) OVER factorial( n - k ) OVER factorial( k );
    # sets n to the forward transform of a                                   #
    PROC bt forward = ( REF[]LONG INT b, []LONG INT a )VOID:
         BEGIN
            REF[]LONG INT b0 = b[ AT 0 ];
            []LONG INT    a0 = a[ AT 0 ];
            FOR n FROM 0 TO UPB b0 DO
               b0[ n ] := 0;
               FOR k FROM 0 TO n DO b0[ n ] +:= binomial( n, k ) * a0[ k ] OD
            OD
         END # bt forward # ;
    # sets a to the inverse transform of b                                   #
    PROC bt inverse = ( REF[]LONG INT a, []LONG INT b )VOID:
         BEGIN
            REF[]LONG INT a0 = a[ AT 0 ];
            []LONG INT    b0 = b[ AT 0 ];
            FOR n FROM 0 TO UPB a0 DO
                a0[ n ] := 0;
                FOR k FROM 0 TO n DO
                    a0[ n ] +:= binomial( n, k ) * b0[ k ] * IF ODD ( n - k ) THEN -1 ELSE 1 FI
                OD
             OD
         END # bt inverse # ;
    # sets b to the self inverse of a                                        #
    PROC bt self inverting = ( REF[]LONG INT b, []LONG INT a )VOID:
         BEGIN
            REF[]LONG INT b0 = b[ AT 0 ];
            []LONG INT    a0 = a[ AT 0 ];
            FOR n FROM 0 TO UPB b0 DO
                b0[ n ] := 0;
                FOR k FROM 0 TO n DO
                    b0[ n ] +:= binomial( n, k ) * a0[ k ] * IF ODD k THEN -1 ELSE 1 FI
                OD
            OD
         END # bt self inverse # ;

    # task test cases                                                        #
    [][]LONG INT seqs = ( ( 1, 1, 2, 5, 14, 42, 132, 429, 1430, 4862
                          , 16796, 58786, 208012, 742900, 2674440, 9694845
                          , 35357670, 129644790, 477638700, 1767263190
                          )
                        , ( 0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0 )
                        , ( 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144
                          , 233, 377, 610, 987, 1597, 2584, 4181
                          )
                        , ( 1, 0, 0, 1, 0, 1, 1, 1, 2, 2, 3, 4, 5, 7, 9, 12, 16, 21, 28, 37 )
                        );
    [ 1 : UPB seqs[ LWB seqs ] ]LONG INT fwd, res;
    []STRING names = ( "Catalan number sequence:"
                     , "Prime flip-flop sequence:"
                     , "Fibonacci number sequence:"
                     , "Padovan number sequence:"
                     );
    FOR i TO UPB seqs DO
        print( ( names[ i ], newline ) );
        FOR j TO UPB seqs[ i ] DO print( ( whole( seqs[ i ][ j ], 0 ), " " ) ) OD;
        print( ( newline, "Forward binomial transform:", newline ) );
        bt forward( fwd, seqs[ i ] );
        FOR j TO UPB fwd DO print( ( whole( fwd[ j ], 0 ), " " ) ) OD;
        print( ( newline, "Inverse binomial transform:", newline ) );
        bt inverse( res, seqs[ i ] );
        FOR j TO UPB res DO print( ( whole( res[ j ], 0 ), " " ) ) OD;
        print( ( newline, "Round trip:", newline ) );
        bt inverse( res, fwd );
        FOR j TO UPB res DO print( ( whole( res[ j ], 0 ), " " ) ) OD;
        print( ( newline, "Self-inverting:", newline ) );
        bt self inverting( fwd, seqs[ i ] );
        FOR j TO UPB fwd DO print( ( whole( fwd[ j ], 0 ), " " ) ) OD;
        print( ( newline, "Re-inverted:", newline ) );
        bt self inverting( res, fwd );
        FOR j TO UPB res DO print( ( whole( res[ j ], 0 ), " " ) ) OD;
        IF i < UPB seqs THEN print( ( newline, newline ) ) ELSE print( ( newline ) ) FI
    OD
END
