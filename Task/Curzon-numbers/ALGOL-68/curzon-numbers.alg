BEGIN # find some generalised Curzon numbers - translation of the C++ sample #
    PROC modpow = ( LONG INT rqd base, rqd exp, mod )LONG INT:
         IF   mod = 1
         THEN 0
         ELSE
              LONG INT result := 1;
              LONG INT base   := rqd base MOD mod;
              LONG INT exp    := rqd exp;
              WHILE exp > 0 DO
                  IF ODD exp THEN
                      result TIMESAB base MODAB mod
                  FI;
                  base TIMESAB base MODAB mod;
                  exp  OVERAB 2
              OD;
              result
         FI # modpow # ;

    PROC is curzon = ( LONG INT n, k )BOOL:
         BEGIN
             LONG INT m = k * n + 1;
             modpow( k, n, m ) + 1 = m
         END # is curon # ;

    FOR k FROM 2 BY 2 TO 10 DO
        print( ( "Curzon numbers with base ", whole( k, 0 ), ":", newline ) );
        INT count := 0, n := 0;
        WHILE n +:= 1;
              count < 50
        DO
            IF is curzon( n, k ) THEN
                print( ( whole( n, -4 )
                       , IF ( count +:= 1 ) MOD 10 = 0 THEN newline ELSE " " FI
                       )
                     )
            FI
        OD;
        WHILE IF is curzon( n, k ) THEN count +:= 1 FI;
              count < 1000
        DO
            n +:= 1
        OD;
        print( ( "1000th Curzon number with base ", whole( k, 0 ), ": ", whole( n, 0 ) ) );
        print( ( newline, newline ) )
    OD
END
