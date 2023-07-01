PROC revn = ( LONG INT na, nda )LONG INT:
BEGIN
    LONG INT n := na, nd := nda, r := 0, i := 0;
    WHILE i +:= 1;
          i <= nd
    DO
        r *:= 10 +:= ( n MOD 10 );
        n OVERAB 10
    OD;
    r
END # revn # ;

LONG INT nd := 2, count := 0, lim := 90, n := 20;

DO
    n +:= 1;
    LONG INT r = revn( n, nd );
    IF  r < n THEN
        LONG INT s = n + r, d = n - r;
        IF  IF   ODD nd
            THEN d MOD 1089 = 0
            ELSE s MOD  121 = 0
            FI
        THEN
            IF  LONG REAL root s = long sqrt( s );
                root s = ENTIER root s
            THEN
                IF  LONG REAL root d = long sqrt( d );
                    root d = ENTIER root d
                THEN
                    count +:= 1;
                    print( (  whole( count, 0 ), ": ", whole( n, 0 ), newline ) );
                    IF count >= 5 THEN stop FI
                FI
            FI
        FI;
        IF  n = lim
        THEN
            lim *:= 10;
            nd  +:=  1;
            n    := ( lim OVER 9 ) * 2
        FI
    FI
OD
