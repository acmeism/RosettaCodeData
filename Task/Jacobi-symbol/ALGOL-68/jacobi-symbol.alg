BEGIN # Jacobi symbol - translation of the Wren sample #

    PROC jacobi = ( INT a in, n in )INT:
         IF n in <= 0 OR NOT ODD n in THEN
            print( ( "The 'n' parameter of jacobi must be an odd positive integer.", newline ) );
            stop
         ELSE
            INT a      := a in MOD n in, n := n in;
            INT result := 1;
            WHILE a /= 0 DO
                WHILE NOT ODD a DO
                    a OVERAB 2;
                    INT nm8 = n MOD 8;
                    IF nm8 = 3 OR nm8 = 5 THEN result := - result FI
                OD;
                INT t = a;
                a    := n;
                n    := t;
                IF a MOD 4 = 3 AND n MOD 4 = 3 THEN result := - result FI;
                a MODAB n
            OD;
            IF n = 1 THEN result ELSE 0 FI
         FI # jacobi # ;

    print( ( "Table of jacobi(a, n):", newline ) );
    print( ( "n/a   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15", newline ) );
    print( ( "---------------------------------------------------------------", newline ) );
    FOR n BY 2 TO 29 DO
        print( ( whole( n, -3 ) ) );
        FOR a TO 15 DO print( ( whole( jacobi( a, n ), -4 ) ) ) OD;
        print( ( newline ) )
    OD

END
