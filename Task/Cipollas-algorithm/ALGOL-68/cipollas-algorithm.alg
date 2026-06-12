BEGIN # Cipolla's algorithm - translation of the EasyLang sample #
    MODE INTEGER = LONG INT;
    OP   SQRT    = ( INTEGER x )LONG REAL: long sqrt( x );
    PROC mul_mod = ( INTEGER a, b in, m )INTEGER:
         BEGIN
            INTEGER b := b in, x := 0, y := a MOD m;
            WHILE b > 0 DO
                IF ODD b THEN x +:= y MODAB m FI;
                y *:= 2 MODAB m;
                b OVERAB 2
            OD;
            x
         END # mul mod # ;
    PROC pow_mod = ( INTEGER b in, p in, m )INTEGER:
         BEGIN
            INTEGER b := b in, x := 1, p := p in;
            WHILE p > 0 DO
                IF ODD p THEN x := mul_mod( x, b, m ) FI;
                b := mul_mod( b, b, m );
                p OVERAB 2
            OD;
            x
         END # pow_mod # ;
    PROC isprime = ( INTEGER num )BOOL:
         IF   num <= 2 OR NOT ODD num
         THEN num = 2
         ELSE INTEGER sqrt num = ENTIER SQRT num;
              BOOL result := TRUE;
              FOR i FROM 3 BY 2 TO SHORTEN sqrt num WHILE result := num MOD i /= 0 DO SKIP OD;
              result
         FI # isprime # ;
    PROC legendre = ( INTEGER a, p )INTEGER:
         IF   INTEGER x = pow_mod( a, ( ( p - 1 ) OVER 2 ), p );
              p - 1 = x
         THEN x - p
         ELSE x
         FI # legendre # ;
    PROC fp2mul = ( []INTEGER a, b, INTEGER p, w2 )[]INTEGER:
         BEGIN
            [ 1 : 2 ]INTEGER ans;
            INTEGER tmp1 := mul_mod( a[ 1 ], b[ 1 ], p );
            INTEGER tmp2 := mul_mod( a[ 2 ], b[ 2 ], p );
            tmp2     := mul_mod( tmp2, w2, p );
            ans[ 1 ] := ( tmp1 + tmp2 ) MOD p;
            tmp1     := mul_mod( a[ 1 ], b[ 2 ], p );
            tmp2     := mul_mod( a[ 2 ], b[ 1 ], p );
            ans[ 2 ] := ( tmp1 + tmp2 ) MOD p;
            ans
         END # fp2mul # ;
    PROC fp2square = ( []INTEGER a, INTEGER p, w2 )[]INTEGER: fp2mul( a, a, p, w2 );
    PROC fp2pow = ( []INTEGER a, INTEGER n, p, w2 )[]INTEGER:
         IF   n = 0     THEN ( 1, 0 )
         ELIF n = 1     THEN a
         ELIF NOT ODD n THEN fp2square( fp2pow( a, ( n OVER 2 ), p, w2 ), p, w2 )
         ELSE                fp2mul( a, fp2pow( a, ( n - 1 ), p, w2 ), p, w2 )
         FI # fp2pow # ;
    PROC test = ( INTEGER n, p )VOID:
         IF   print( ( "n = ", whole( n, -12 ), " p = ", whole( p, -12 ), " ->" ) );
              p = 2 OR NOT isprime( p ) OR legendre( n, p ) /= 1
         THEN print( ( " no solution", newline ) )
         ELSE WHILE BOOL    finished := FALSE;
                    INTEGER a  := 0, w2 := 0;
                    WHILE   a  := ENTIER ( random * ( p - 2 ) ) + 1;
                          w2 := a * a - n;
                          legendre( w2, p ) /= -1
                    DO SKIP OD;
                    []INTEGER ans = fp2pow( ( a, 1 ), ( ( p + 1 ) OVER 2 ), p, w2 );
                    IF ans[ 2 ] = 0
                    THEN INTEGER x1 = ans[ 1 ];
                         INTEGER x2 = p - x1;
                         IF mul_mod( x1, x1, p ) = n AND mul_mod( x2, x2, p ) = n
                         THEN print( ( " x1 = ", whole( x1, -12 ), " x2 = ", whole( x2, -12 ) ) );
                              finished := TRUE
                         FI
                    FI;
                    NOT finished
              DO SKIP OD;
              print( ( newline ) )
         FI # test # ;
    test(        10,         13 );
    test(        56,        101 );
    test(      8218,      10007 );
    test(      8219,      10007 );
    test(    331575,    1000003 );
    test( 665165880, 1000000007 )
END
