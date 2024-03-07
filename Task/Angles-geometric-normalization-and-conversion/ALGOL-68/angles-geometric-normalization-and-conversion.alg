BEGIN # Angles (geometric), normalization and conversion - translated from the 11l sample #

    []REAL values = ( -2, -1, 0, 1, 2, 6.2831853, 16, 57.2957795, 359, 399, 6399, 1000000 );

    PROC norm = ( REAL x, y )REAL:
         BEGIN
            INT  n  = ENTIER ( ABS x / ABS y );
            REAL r := x - ( n * y );
            r
         END # norm # ;

    PROC normd = ( REAL x )REAL: norm( x,  360 );
    PROC normg = ( REAL x )REAL: norm( x,  400 );
    PROC normm = ( REAL x )REAL: norm( x, 6400 );
    PROC normr = ( REAL x )REAL: norm( x, 2 * pi );

    PROC d2g = ( REAL x )REAL: normd( x ) * 10 / 9;
    PROC d2m = ( REAL x )REAL: normd( x ) * 160 / 9;
    PROC d2r = ( REAL x )REAL: normd( x ) * pi / 180;

    PROC g2d = ( REAL x )REAL: normg( x ) * 9 / 10;
    PROC g2m = ( REAL x )REAL: normg( x ) * 16;
    PROC g2r = ( REAL x )REAL: normg( x ) * pi / 200;

    PROC m2d = ( REAL x )REAL: normm( x ) * 9 / 160;
    PROC m2g = ( REAL x )REAL: normm( x ) / 16;
    PROC m2r = ( REAL x )REAL: normm( x ) * pi / 3200;

    PROC r2d = ( REAL x )REAL: normr( x ) *  180 / pi;
    PROC r2g = ( REAL x )REAL: normr( x ) *  200 / pi;
    PROC r2m = ( REAL x )REAL: normr( x ) * 3200 / pi;

    STRING underline = "----------------------------------------------------------------------------------";
    PROC f7d7 = ( REAL v )STRING: fixed( v, -15, 7 );

    PROC print values = ( STRING heading, []PROC(REAL)REAL f )VOID:
         BEGIN
             print( ( heading, newline ) );
             print( ( underline, newline ) );
             FOR i FROM LWB values TO UPB values DO
                 REAL v = values[ i ];
                 print( ( f7d7( v ) ) );
                 FOR p FROM LWB f TO UPB f DO
                     print( ( "  ", f7d7( f[ p ]( v ) ) ) )
                 OD;
                 print( ( newline ) )
             OD;
             print( ( newline ) )
         END # print values # ;

    print values( "       Degrees        Normalized         Gradians          Mils            Radians"
                , ( normd, d2g, d2m, d2r )
                );
    print values( "      Gradians        Normalized         Degrees           Mils            Radians"
                , ( normg, g2d, g2m, g2r )
                );
    print values( "        Mils          Normalized         Degrees         Gradians          Radians"
                , ( normm, m2d, m2g, m2r )
                );
    print values( "       Radians        Normalized         Degrees         Gradians          Mils"
                , ( normr, r2d, r2g, r2m )
                )

END
