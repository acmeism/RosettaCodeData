FOR n FROM -99 TO 100 DO
    INT l := 0, f := 3, z := ABS n;
    WHILE z >= 2 DO
        WHILE z MOD 2 = 0 DO     l +:= n OVER 2; z OVERAB 2 OD;
        IF f <= z THEN
            WHILE z MOD f = 0 DO l +:= n OVER f; z OVERAB f OD;
            f +:= 2
        FI
    OD;
    print( ( whole( l, -8 ) ) );
    IF ( n + 100 ) MOD 10 = 0 THEN print( ( newline ) ) FI
OD
