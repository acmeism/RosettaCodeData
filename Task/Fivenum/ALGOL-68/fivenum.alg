BEGIN # construct an R-style fivenum function #
    PR read "rows.incl.a68" PR
    PR read "sort.incl.a68" PR

    PROC fivenum = ( []REAL array )[]REAL:
         BEGIN
            INT n = ( UPB array + 1 ) - LWB array;
            [ 1 : n ]REAL x := array[ AT 1 ];
            QUICKSORT x;
            REAL   n4 = ( ( ( n + IF ODD n THEN 3 ELSE 2 FI ) / 2 ) / 2 ) ;
            []REAL d  = ( 1, n4, ( n + 1 ) / 2, n + 1 - n4, n );
            [ 1 : 5 ]REAL sum_array;
            FOR e TO 5 DO
                INT fl = ENTIER d[ e ];
                INT ce = IF fl < d[ e ] THEN 1 + fl ELSE fl FI;
                sum_array[ e ] := 0.5 * ( x[ fl ] + x[ ce ] )
            OD;
            sum_array
         END # five num # ;

    SHOW fivenum( ( 36, 40, 7, 39, 41, 15 ) );
    print( ( newline ) );
    SHOW fivenum( ( 15, 6, 42, 41, 7, 36, 49, 40, 39, 47, 43 ) );
    print( ( newline ) );
    SHOW fivenum( (  0.14082834,  0.09748790,  1.73131507, 0.87636009
                  , -1.95059594,  0.73438555, -0.03035726, 1.46675970
                  , -0.74621349, -0.72588772,  0.63905160, 0.61501527
                  , -0.98983780, -1.00447874, -0.62759469, 0.66206163
                  ,  1.04312009, -0.10305385,  0.75775634, 0.32566578
                  )
                )
END
