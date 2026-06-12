BEGIN # implement sin, cos and tan using the CORDIC algorithm                #

    REAL pi by 2 = pi / 2;

    # pre-computed table of arctan(10^-n) values:                            #
    []REAL theta = ( 7.85398163397448e-01, 9.96686524911620e-02
                   , 9.99966668666524e-03, 9.99999666666867e-04
                   , 9.99999996666667e-05, 9.99999999966667e-06
                   , 9.99999999999667e-07, 9.99999999999997e-08
                   , 1.00000000000000e-08, 1.00000000000000e-09
                   , 1.00000000000000e-10, 1.00000000000000e-11
                   , 1.00000000000000e-12, 1.00000000000000e-13
                   , 1.00000000000000e-14, 1.00000000000000e-15
                   , 1.00000000000000e-16
                   );
    REAL epsilon = 1e-16;

    # mode to hold the values returned from the CORDIC procedure             #
    MODE CORDICV = STRUCT( REAL y, x );

    # CORDIC algorithm, finds "y" and "x" for alpha radians                  #
    # signs indicates the sign of the results:                               #
    #     signs[ 1 ] = sign for -π : -π/2, signs[ 1 ] = sign for -π/2 : 0    #
    #     signs[ 3 ] = sign for  0 :  π/2, signs[ 4 ] = sign for  π/2 : π    #
    # sign both = TRUE => sign applied to both y and x, FALSE => sign y only #
    PROC cordic = ( REAL alpha in, []INT signs, BOOL sign both )CORDICV:
         BEGIN
            REAL alpha     := alpha in;            # ensure -π <= alpha <= π #
            BOOL flip sign := FALSE;
            WHILE alpha < - pi DO alpha +:= pi; flip sign := NOT flip sign OD;
            WHILE alpha >   pi DO alpha -:= pi; flip sign := NOT flip sign OD;
            INT    sign;
            IF     alpha < - pi by 2 THEN
                alpha +:= pi;
                sign := signs[ 1 ]
            ELIF   alpha < 0         THEN
                alpha := - alpha;
                sign := signs[ 2 ]
            ELIF   alpha < pi by 2   THEN
                sign := signs[ 3 ]
            ELSE # alpha < pi #
                alpha := pi - alpha;
                sign := signs[ 4 ]
            FI;
            IF flip sign AND sign both THEN sign := -sign FI;
            REAL x := 1, y := 0;
            INT  k := 1;
            REAL ten to minus k := 1;     # NB: ten to minus k = 10.0^-(k-1) #
            WHILE epsilon < alpha DO
                WHILE alpha < theta[ k ] DO
                    k              +:=  1;
                    ten to minus k /:= 10
                OD;
                alpha -:= theta[ k ];
                REAL x2 = x - ten to minus k * y;
                REAL y2 = y + ten to minus k * x;
                x      := x2;
                y      := y2
            OD;
            CORDICV( sign * y, IF sign both THEN sign * x ELSE x FI )
         END # cordic # ;

    # find sin(alpha) using the CORDIC algorithm. alpha in radians           #
    PROC cordic cos = ( REAL alpha )REAL:
         BEGIN
            CORDICV c = cordic( alpha, ( -1, 1, 1, -1 ), TRUE );
            x OF c / sqrt( ( x OF c * x OF c ) + ( y OF c * y OF c ) )
         END # cordic cos # ;

    # find sin(alpha) using the CORDIC algorithm. alpha in radians           #
    PROC cordic sin = ( REAL alpha )REAL:
         BEGIN
            CORDICV c = cordic( alpha, ( -1,-1, 1, 1 ), TRUE );
            y OF c / sqrt( ( x OF c * x OF c ) + ( y OF c * y OF c ) )
         END # cordic sin # ;

    # find tan(alpha) using the CORDIC algorithm. alpha in radians           #
    PROC cordic tan = ( REAL alpha )REAL:
         BEGIN
             CORDICV c = cordic( alpha, (  1, -1, 1,-1 ), FALSE );
             IF x OF c = 0 THEN max real ELSE y OF c / x OF c FI
         END # cordic tan # ;

    PROC show cordic = ( REAL angle )VOID:
         BEGIN
            REAL cosine  = cos( angle ), cordic cosine  = cordic cos( angle );
            REAL sine    = sin( angle ), cordic sine    = cordic sin( angle );
            REAL tangent = tan( angle ), cordic tangent = cordic tan( angle );
            REAL c diff  = ABS ( cordic cosine  - cosine  );
            REAL s diff  = ABS ( cordic sine    - sine    );
            REAL t diff  = ABS ( cordic tangent - tangent );
            print( ( fixed(          angle,  -8, 4    ), ":  "
                   , fixed(  cordic cosine,  -9, 6    ), " "
                   , fixed(         cosine,  -9, 6    ), " "
                   , float(         c diff, -14, 8, 2 ), " | "
                   , fixed(    cordic sine,  -9, 6    ), " "
                   , fixed(           sine,  -9, 6    ), " "
                   , float(         s diff, -14, 8, 2 ), " | "
                   , fixed( cordic tangent,  -9, 6    ), " "
                   , fixed(        tangent,  -9, 6    ), " "
                   , float(         t diff, -14, 8, 2 ), newline
                   )
                 )
         END # show cordic # ;

    []REAL tests = ( -9, 0, 1.5, 6 );
    print( ( "    angle cordic cos       cos     difference" ) );
    print( (         "  cordic sin       sin     difference" ) );
    print( (         "  cordic tan       tan     difference" ) );
    print( ( newline ) );
    FOR i FROM LWB tests TO UPB tests DO
        show cordic( tests[ i ] )
    OD;
    print( ( "    angle cordic cos       cos     difference" ) );
    print( (         "  cordic sin       sin     difference" ) );
    print( (         "  cordic tan       tan     difference" ) );
    print( ( newline ) );
    FOR i FROM 7810 BY 9 TO 7898 DO
        show cordic( i / 10 000 )
    OD

END
