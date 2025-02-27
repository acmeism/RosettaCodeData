BEGIN # draw a quadratic curve using Bresenham's line algoritm               #

    PR READ "prelude/Bitmap.a68" PR;
    PR READ "prelude/Bitmap/Bresenhams_line_algorithm.a68" PR;

    PROC quadratic bezier = ( REF IMAGE bm, INT x1, y1, x2, y2, x3, y3, nseg, REAL scale )VOID:
         BEGIN
            INT prevx := 0, prevy := 0;
            FOR i FROM 0 TO nseg DO
                REAL t  = i / nseg;
                REAL t1 = 1 - t;
                REAL a  = t1 * t1;
                REAL b  = 2 * t * t1;
                REAL c  = t * t;
                INT currx = ENTIER ( scale * ( a * x1 + b * x2 + c * x3 + 0.5 ) );
                INT curry = ENTIER ( scale * ( a * y1 + b * y2 + c * y3 + 0.5 ) );
                IF i > 0 THEN
                    ( line OF class image )( bm
                                           , ( prevx, prevy )
                                           , ( currx, curry )
                                           , black OF class image
                                           )
                FI;
                prevx := currx;
                prevy := curry
             OD
         END # quadratic bezier # ;

    BEGIN
        REF IMAGE bm = INIT LOC[ 1 : 60, 1 : 40 ]PIXEL;
        ( fill OF class image )( bm, white OF class image );
        quadratic bezier( bm, 10, 100, 250, 270, 150, 20, 20, 70 / 300 );
        # print in monochrome #
        FOR y FROM 2 UPB bm BY -1 TO 2 LWB bm DO
            FOR x FROM 1 LWB bm TO 1 UPB bm DO
                print( ( IF PIXEL( bm[ x, y ] ) /= white OF class image THEN "##" ELSE "  " FI ) )
            OD;
            print( ( newline ) )
        OD
    END
END
