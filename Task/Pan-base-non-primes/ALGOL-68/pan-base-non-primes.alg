BEGIN # pan-base non-primes - translated from the Wren sample               #
    PR read "primes.incl.a68" PR                  # include prime utilities #
    INT    limit = 2500;

    # iterative Greatest Common Divisor routine, returns the gcd of m and n #
    PROC gcd = ( INT m, n )INT:
         BEGIN
            INT a := ABS m, b := ABS n;
            WHILE b /= 0 DO
                INT new a = b;
                b        := a MOD b;
                a        := new a
            OD;
            a
         END # gcd # ;

    # table of digit-digit Greatest Common Divisors                        #
    [ 0 : 9, 0 : 9 ]INT dd gcd;
    FOR i FROM 0 TO 9 DO FOR j FROM 0 TO 9 DO dd gcd[ i, j ] := gcd( i, j ) OD OD;

    # returns the gcd of the digits of n                                   #
    PROC gcd digits = ( INT n )INT:
         BEGIN
             STRING s  = whole( n, 0 );
             INT    g := 0;
             FOR c FROM LWB s TO UPB s DO
                 g := dd gcd[ g, ABS s[ c ] - ABS "0" ]
             OD;
             g
         END # gcd digits # ;

    # returns the number represented by s in base b                        #
    #         note s will only contain the digits 0 .. 9                   #
    PROC str to dec = ( STRING s, INT base )LONG INT:
         BEGIN
            LONG INT res := 0;
            FOR c pos FROM LWB s TO UPB s DO
                res *:= base +:= ( ABS s[ c pos ] - ABS "0" )
            OD;
            res
         END # str to dec # ;

    [ 1 : limit ]INT pbnp;
    INT pbnp count := 0;

    FOR n FROM 3 TO limit DO
       IF n MOD 10 = 0 AND n > 10 THEN
           pbnp[ pbnp count +:= 1 ] := n
       ELIF n > 9 AND gcd digits( n ) > 1 THEN
           pbnp[ pbnp count +:= 1 ] := n
       ELSE
           BOOL   comp := TRUE;
           STRING s     = whole( n, 0 );
           FOR base FROM 2 TO n WHILE comp := NOT is probably prime( str to dec( s, base ) ) DO SKIP OD;
           IF comp THEN pbnp[ pbnp count +:= 1 ] := n FI
       FI
    OD;

    print( ( "First 50 pan-base composites:", newline ) );
    FOR i TO IF pbnp count < 50 THEN pbnp count ELSE 50 FI DO
        print( ( " ", whole( pbnp[ i ], -3 ) ) );
        IF i MOD 10 = 0 THEN print( ( newline ) ) FI
    OD;
    print( ( newline, "First 20 odd pan-base composites:", newline ) );
    INT odd count := 0;
    FOR i TO pbnp count DO
        INT n = pbnp[ i ];
        IF ODD n THEN
            odd count +:= 1;
            IF odd count <= 20 THEN
                print( ( " ", whole( n, -3 ) ) );
                IF odd count MOD 10 = 0 THEN print( ( newline ) ) FI
            FI
        FI
    OD;

    print( ( newline
           , "Count of pan-base composites up to and including "
           , whole( limit, 0 )
           , ": "
           , whole( pbnp count, 0 )
           )
         );
    print( ( newline
           , "Number odd  = "
           , whole( odd count, 0 )
           , " or ", fixed( 100 * ( odd count / pbnp count ), -9, 6 )
           , "%"
           )
         );
    print( ( newline
           , "Number even = "
           , whole( pbnp count - odd count, 0 )
           , " or ", fixed( 100 * ( ( pbnp count - odd count ) / pbnp count ), -9, 6 )
           , "%"
           )
         )
END
