BEGIN # Sturmian word - based on the Python sample                    #

    PROC sturmian word = ( INT m, n )STRING:
         IF m > n THEN
            STRING sturmian := sturmian word( n, m );
            FOR s pos FROM LWB sturmian TO UPB sturmian DO
                CHAR c = sturmian[ s pos ];
                sturmian[ s pos ] := IF c = "0" THEN "1" ELIF c = "1" THEN "0" ELSE c FI
            OD;
            sturmian
         ELSE
            STRING sturmian := "";
            INT current floor := 0;
            FOR k WHILE ( k * m ) MOD n /= 0 DO
                INT previous floor = current floor;
                current floor := ( k * m ) OVER n;
                IF previous floor = current floor THEN
                    sturmian +:= "0"
                ELSE
                    sturmian +:= "10"
                FI
            OD;
            sturmian
         FI # sturmian word # ;

    # Checking that it works on the finite Fibonacci word:            #

    PROC fibonacci word = ( INT n )STRING:
         BEGIN
            STRING sn1 := "0", sn := "01";
            FROM 2 TO n DO
                STRING tmp = sn;
                sn +:= sn1;
                sn1 := tmp
            OD;
            sn
         END # fibonacci word # ;

    BEGIN
        STRING f word   = fibonacci word( 10 );
        STRING sturmian = sturmian word( 13, 21 );
        IF f word[ : UPB sturmian[ AT 1 ] AT 1 ] = sturmian THEN
            print( ( sturmian ))
        ELSE
            print( ( "*** unexpected result: (", sturmian, ") (", f word, ")" ) )
        FI;
        print( ( newline ) )
    END

END
