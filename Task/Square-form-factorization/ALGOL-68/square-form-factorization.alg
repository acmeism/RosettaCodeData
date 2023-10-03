BEGIN # Daniel Shanks's Square Form Factorization (SquFoF) - based on the Wren sample #

    MODE INTEGER = LONG INT;                                  # large enough INT type #
    PROC(LONG REAL)LONG REAL size sqrt = long sqrt;         # sqrt for INTEGER values #

    []INTEGER multipliers = ( 1, 3, 5, 7, 11, 3 * 5, 3 * 7, 3 * 11
                            , 5 * 7, 5 * 11, 7 * 11, 3 * 5 * 7, 3 * 5 * 11
                            , 3 * 7 * 11, 5 * 7 * 11, 3 * 5 * 7 * 11
                            );
    PROC gcd = ( INTEGER x, y )INTEGER:                               # iterative gcd #
         BEGIN
            INTEGER a := x, b := y;
            WHILE b /= 0 DO
               INTEGER next a = b;
               b := a MOD b;
               a := next a
            OD;
            ABS a
         END # gcd # ;

    PROC squfof = ( INTEGER n )INTEGER:
         IF  INTEGER s = ENTIER ( size sqrt( n ) + 0.5 );
             s * s = n
         THEN s
         ELSE INTEGER result := 0;
              FOR multiplier FROM LWB multipliers TO UPB multipliers WHILE result = 0 DO
                  INTEGER d       = n * multipliers[ multiplier ];
                  INTEGER pp     := ENTIER size sqrt( d );
                  INTEGER p prev := pp;
                  INTEGER po      = p prev;
                  INTEGER q prev := 1;
                  INTEGER qq     := d - ( po * po );
                  INTEGER l       = ENTIER size sqrt( s * 8 );
                  INTEGER bb      = 3 * l;
                  INTEGER i      := 2;
                  INTEGER b      := 0;
                  INTEGER q      := 0;
                  INTEGER r      := 0;
                  BOOL    again  := TRUE;
                  WHILE i < bb AND again DO
                      b  := ( po + pp ) OVER qq;
                      pp := ( b * qq ) - pp;
                      q  := qq;
                      qq := q prev + ( b * ( p prev - pp ) );
                      r  := ENTIER ( size sqrt( qq ) + 0.5 );
                      IF i MOD 2 = 0 THEN again := r * r /= qq FI;
                      IF again THEN
                          q prev := q;
                          p prev := pp;
                          i     +:= 1
                      FI
                  OD;
                  IF i < bb THEN
                      b      := ( po - pp ) OVER r;
                      p prev := pp := ( b * r ) + pp;
                      q prev := r;
                      qq     := ( d - ( p prev * p prev ) ) OVER q prev;
                      i      := 0;
                      WHILE
                          b      := ( po + pp ) OVER qq;
                          p prev := pp;
                          pp     := ( b * qq ) - pp;
                          q      := qq;
                          qq     := q prev + ( b * ( p prev - pp ) );
                          q prev := q;
                          i     +:= 1;
                          pp /= p prev
                      DO SKIP OD
                  FI;
                  r := gcd( n, q prev );
                  IF r /= 1 AND r /=n THEN result := r FI
              OD;
              result
         FI # squfof # ;

    []INTEGER examples = (                2501,               12851
                         ,               13289,               75301
                         ,              120787,              967009
                         ,              997417,             7091569
                         ,            13290059,            42854447
                         ,           223553581,          2027651281
                         ,         11111111111,        100895598169
                         ,       1002742628021,      60012462237239
                         ,     287129523414791,    9007199254740931
                         ,   11111111111111111,  314159265358979323
                         ,  384307168202281507,  419244183493398773
                         ,  658812288346769681,  922337203685477563
                         , 1000000000000000127, 1152921505680588799
                         , 1537228672809128917, 4611686018427387877
                     );

    print( ( "Integer                  Factor Quotient",   newline ) );
    print( ( "----------------------------------------", newline ) );
    FOR example FROM LWB examples TO UPB examples DO
        INTEGER n    = examples[ example ];
        INTEGER fact = squfof( n );
        STRING  quot = IF fact = 0 THEN "fail" ELSE whole( n OVER fact, 0 ) FI;
        print( ( whole( n, -20 ), " ", whole( fact, -10 ), " ", quot, newline ) )
    OD
END
