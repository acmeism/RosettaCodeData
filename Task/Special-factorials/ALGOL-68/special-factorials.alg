BEGIN # show the values of some "special factorials"                         #

    # super factorial: returns the product of the factorials up to to n      #
    PROC sf = ( INT n )LONG LONG INT:
         BEGIN
            LONG LONG INT f := 1, p := 1;
            FOR i TO n DO
                f *:= i;
                p *:= f
            OD;
            p
         END # sf # ;
    # hyper factorial: returns the product of k^k for k up to n              #
    PROC hf = ( INT n )LONG LONG INT:
         BEGIN
            LONG LONG INT p := 1;
            FOR i TO n DO
                TO i DO p *:= i OD
            OD;
            p
         END # hf # ;
    # alternating factorial: returns the sum of (-1)^(i-1)*i! for i up to n  #
    PROC af = ( INT n )LONG LONG INT:
         BEGIN
            LONG LONG INT s := 0;
            LONG LONG INT f := 1;
            INT sign        := IF ODD n THEN 1 ELSE - 1 FI;
            FOR i TO n DO
                f   *:= i;
                s   +:= sign * f;
                sign := - sign
            OD;
            s
         END # hf # ;
    # exponential factorial: returns n^(n-1)^(n-2)...                        #
    PROC xf = ( INT n )LONG LONG INT:
         BEGIN
            LONG LONG INT x := 1;
            FOR i TO n DO
                LONG LONG INT ix := 1;
                TO SHORTEN SHORTEN x DO ix *:= i OD;
                x := ix
            OD;
            x
         END # hf # ;
    # reverse factorial: returns k if n = k! for some integer k              #
    #                           "undefined" otherwise                        #
    PROC rf = ( LONG LONG INT n )UNION( INT, STRING ):
         IF n < 2
         THEN 0
         ELSE
            LONG LONG INT f := 1;
            INT           i := 1;
            WHILE f < n DO
                f *:= i;
                i +:= 1
            OD;
            IF f = n THEN i - 1 ELSE "undefined" FI
         FI # rf # ;

    print( ( "super factorials 0..9:", newline, "   " ) );
    FOR i FROM 0 TO 9 DO print( ( " ", whole( sf( i ), 0 ) ) ) OD;
    print( ( newline, "hyper factorials 0..9:", newline, "   " ) );
    FOR i FROM 0 TO 9 DO print( ( " ", whole( hf( i ), 0 ) ) ) OD;
    print( ( newline, "alternating factorials 0..9:", newline, "   " ) );
    FOR i FROM 0 TO 9 DO print( ( " ", whole( af( i ), 0 ) ) ) OD;
    print( ( newline, "exponential factorials 0..4:", newline, "   " ) );
    FOR i FROM 0 TO 4 DO print( ( " ", whole( xf( i ), 0 ) ) ) OD;

    []INT rf test = ( 1, 2, 6, 24, 119, 120, 720, 5040, 40320, 362880, 3628800 );
    print( ( newline, "reverse factorials:", newline ) );
    FOR i FROM LWB rf test TO UPB rf test DO
        INT tv = rf test[ i ];
        print( ( whole( tv, -8 )
               , " -> "
               , CASE rf( tv )
                   IN ( INT    iv ): whole( iv, 0 )
                    , ( STRING sv ): sv
                  OUT "Unexpected value returned by rf( " + whole( tv, 0 ) + " )"
                 ESAC
               , newline
               )
             )
    OD

END
