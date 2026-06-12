BEGIN # Goodstein sequence - translation of Phix via EasyLang #

    MODE INTEGER = LONG INT;

    PROC bump = ( INTEGER v, b )INTEGER:
         BEGIN
            INTEGER n := v, res := 0;
            FOR i FROM 0 WHILE n > 0 DO
                INTEGER d = n MOD b;
                IF d > 0 THEN
                    res +:= d * ENTIER ( ( ( b + 1 ) ^ bump( i, b ) ) + 0.5 )
                FI;
                n OVERAB b
            OD;
            res
         END # bump # ;

    PROC goodstein = ( INTEGER n, INT maxterms )[]INTEGER:
         BEGIN
            [ 1 : maxterms ]INTEGER res;
            INT len res := 0;
            IF maxterms > 0 THEN
                res[ len res +:= 1 ] := n;
                WHILE len res < maxterms AND res[ len res ] /= 0 DO
                    INT cur len := len res;
                    res[ len res +:= 1 ] := bump( res[ cur len ], cur len + 1 ) - 1
                OD
            FI;
            res[ 1 : len res ]
         END # goodstein # ;

    BEGIN
        FOR i FROM 0 TO 7 DO
            []INTEGER gs = goodstein( i, 10 );
            print( ( "[" ) );
            FOR spos FROM LWB gs TO UPB gs DO print( ( " ", whole( gs[ spos ], 0 ) ) ) OD;
            print( ( " ]", newline ) )
        OD;
        print( ( newline ) );
        FOR i FROM 0 TO 10 DO
            []INTEGER h = goodstein( i, ( i + 1 ) );
            print( ( whole( h[ UPB h ], 0 ), newline ) )
        OD
    END
END
