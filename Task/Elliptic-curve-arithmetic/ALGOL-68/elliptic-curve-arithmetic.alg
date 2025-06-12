BEGIN # elliptic curve arithmetic     - translation of the C sample #

    INT  bx0 = 7;
    MODE PT  = STRUCT( REAL x, y );

    # using max real for INIFINTY                                   #
    PROC zero = PT: ( max real, max real );

    OP   ISZERO = ( PT p )BOOL: x OF p > 1e20 OR x OF p < -1e20;
    OP   - = ( PT p )PT: ( x OF p, - y OF p );

    OP   DBL = ( PT p )PT:
         IF   ISZERO p
         THEN p
         ELSE REAL l  = ( 3 * x OF p * x OF p ) / ( 2 * y OF p );
              REAL rx = l * l - 2 * x OF p;
              ( rx, l * ( x OF p - rx ) - y OF p )
         FI # DBL # ;
    OP   = = ( PT p, q )BOOL: x OF p = x OF q AND y OF p = y OF q;
    OP   + = ( PT p, q )PT:
         IF   p = q
         THEN DBL p
         ELIF ISZERO p
         THEN q
         ELIF ISZERO q
         THEN p
         ELIF x OF q = x OF p
         THEN zero
         ELSE REAL l  = ( y OF q - y OF p ) / ( x OF q - x OF p );
              REAL rx = l * l - x OF p - x OF q;
              ( rx, l * ( x OF p - rx ) - y OF p )
         FI # ~ # ;
    OP   +:= = ( REF PT p, PT q )REF PT: p := p + q;
    OP   * = ( PT p in, INT n )PT:
         BEGIN
            PT  p := p in, r := zero;
            INT i := 1;
            WHILE i <= n DO
                IF ABS ( BIN i AND BIN n ) /= 0 THEN r +:= p FI;
                p  := DBL p;
                i *:= 2
            OD;
            r
         END # * # ;

    OP   TOPT = ( REAL y )PT:
         IF   REAL v = y * y - bx0; v = 0
         THEN zero
         ELSE ( SIGN v * ABS v ^ ( 1 / 3 ), y )
         FI # TOPT # ;
    OP   TOPT = ( INT  y )PT: TOPT REAL( y );
    OP   FMT  = ( REAL v )STRING:
         BEGIN
            STRING result := fixed( v, -18, 3 );
            INT    s pos  := 1;
            WHILE result[ s pos ] = " " DO s pos +:= 1 OD;
            result[ s pos : ]
         END # FMT # ;
    PROC show = ( STRING s, PT p )VOID:
         print( ( s
                , IF   ISZERO p
                  THEN "Zero"
                  ELSE ( "(" + FMT x OF p + ", " + FMT y OF p + ")" )
                  FI
                , newline
                )
              ) # show # ;

     BEGIN #  task                                                  #
         PT a = TOPT 1, b = TOPT 2;
         PT c = a + b;
         PT d = -c;
         show( "a = ", a );
         show( "b = ", b );
         show( "c = a + b = ", c );
         show( "d = -c = ", d );
         show( "c + d = ", c + d );
         show( "a + b + d = ", a + ( b + d ) );
         show( "a * 12345 = ", a * 12345 )
    END
END
