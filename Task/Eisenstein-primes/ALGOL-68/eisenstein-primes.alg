BEGIN # Eisenstein primes - translated from the FreeBASIC and Wren samples   #

    PROC is prime = ( INT n )BOOL:
         BEGIN
            BOOL result := n = 2 OR ( ODD n AND n > 1 );
            FOR k FROM 3 BY 2 WHILE result AND k * k <= n DO result := n MOD k /= 0 OD;
            result
         END # is prime # ;

    MODE  EISENSTEIN = STRUCT( INT a, b, norm, COMPL n );
    REAL  root3      = sqrt( 3 );
    REAL  half root3 = root3 / 2;

    COMPL omega      = ( -0.5, half root3 );

    PRIO NEWEISENSTEIN = 1, =:= = 1;
    OP   NEWEISENSTEIN = ( INT a, b )EISENSTEIN:
         ( a
         , b
         , ( a * a ) - ( a * b ) + ( b * b )
         , a + omega * b
         );

    OP   ISEISENSTEINPRIME = ( EISENSTEIN e )BOOL:
         IF INT a = a OF e, b = b OF e;
            a = 0 OR b = 0 OR a = b
         THEN
             INT c = IF ABS a > ABS b THEN ABS a ELSE ABS b FI;
             is prime( c ) AND ( c MOD 3 ) = 2
         ELSE
             is prime( norm OF e )
         FI;
    OP   < = ( EISENSTEIN a, b )BOOL:
         (      INT norm a = norm OF a, norm b = norm OF b;
                norm a < norm b
         OR (   norm a = norm b AND im OF n OF a < im OF n OF b )
         OR (   norm a = norm b AND im OF n OF a = im OF n OF b AND re OF n OF a < re OF n OF b )
         );
    OP   > = ( EISENSTEIN a, b )BOOL:
         (      INT norm a = norm OF a, norm b = norm OF b;
                norm a > norm b
         OR (   norm a = norm b AND im OF n OF a > im OF n OF b )
         OR (   norm a = norm b AND im OF n OF a = im OF n OF b AND re OF n OF a > re OF n OF b )
         );
    OP   =:= = ( REF EISENSTEIN a, b )VOID: BEGIN EISENSTEIN t = a; a := b; b := t END;

    PROC sort eisenstein = ( REF[]EISENSTEIN primes, INT first, last )VOID:
         BEGIN
             INT        i    := first, j := last;
             EISENSTEIN pivot = primes[ ( first + last ) OVER 2 ];
             WHILE WHILE primes[ i ] < pivot DO i +:= 1 OD;
                   WHILE primes[ j ] > pivot DO j -:= 1 OD;
                   IF i <= j THEN
                       primes[ i ] =:= primes[ j ];
                       i           +:= 1;
                       j           -:= 1
                   FI;
                   i <= j
             DO SKIP OD;
             IF first < j THEN sort eisenstein( primes, first, j    ) FI;
             IF i < last  THEN sort eisenstein( primes, i,     last ) FI
         END # sort eisenstein # ;

    BEGIN
        OP   TOSTRING = ( COMPL n )STRING:
             fixed(     re OF n, -7, 4 ) + IF im OF n < 0 THEN " -" ELSE " +" FI
           + fixed( ABS im OF n, -7, 4 ) + "i"
           ;

        INT max range    = 100;
        INT prime count := 0;
        [ 1 : max range * max range * 4 ]EISENSTEIN primes;
        FOR a FROM - max range TO max range DO
            FOR b FROM - max range TO max range DO
                EISENSTEIN e = a NEWEISENSTEIN b;
                IF ISEISENSTEINPRIME e THEN
                    primes[ prime count +:= 1 ] := e
                FI
            OD
        OD;
        sort eisenstein ( primes, 1, prime count );
        print( ( "First 100 Eisenstein primes nearest zero:", newline ) );
        FOR i TO max range DO
            print( ( TOSTRING n OF primes[ i ], "  " ) );
            IF i MOD 4 = 0 THEN print( ( newline ) ) FI
        OD

    END
END
