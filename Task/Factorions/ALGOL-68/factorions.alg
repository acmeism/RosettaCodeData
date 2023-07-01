BEGIN
    # cache factorials from 0 to 11 #
    [ 0 : 11 ]INT fact;
    fact[0] := 1;
    FOR n TO 11 DO
        fact[n] := fact[n-1] * n
    OD;
    FOR b FROM 9 TO 12 DO
        print( ( "The factorions for base ", whole( b, 0 ), " are:", newline ) );
        FOR i TO 1500000 - 1 DO
            INT sum := 0;
            INT j := i;
            WHILE j > 0 DO
                sum +:= fact[ j MOD b ];
                j OVERAB b
            OD;
            IF sum = i THEN print( ( whole( i, 0 ), " " ) ) FI
        OD;
        print( ( newline ) )
    OD
END
