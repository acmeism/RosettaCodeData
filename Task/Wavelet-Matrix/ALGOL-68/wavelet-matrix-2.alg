BEGIN # Wavelet Matrix - translated from the FreeBASIC sample                #

    PR read "bits.incl.a68" PR          # include bit-manipulation utilities #
    PR read "rows.incl.a68" PR       # include row (array) related utilities #
    PR read "sort.incl.a68" PR                      # include sort utilities #

    PR read "wavelet_matrix.incl.a68" PR    # WAVELETMATRIX and related code #

    BEGIN # task                                                             #
        # Define the array and queries                                       #
        []INT a = ( 3374, 956, 2114, 3415, 3437 );
        INT   n = UPB a;

        # Create a sorted copy with unique values                            #

        [ 0 : n - 1 ]INT sorted a := a[ AT 0 ];
        QUICKSORT sorted a;

        INT unique count := 1; # Count unique values                         #
        FOR i FROM LWB sorted a + 1 TO UPB sorted a DO
            IF sorted a[ i ] /= sorted a[ i - 1 ] THEN unique count +:= 1 FI
        OD;

        # Create array with unique values                                    #
        [ 0 : unique count - 1 ]INT unique a;
        unique a[ 0 ] := sorted a[ 0 ];
        INT idx := 0;
        FOR i TO n - 1 DO
            IF sorted a[ i ] /= sorted a[ i - 1 ] THEN
                unique a[ idx +:= 1 ] := sorted a[ i ]
            FI
        OD;

        # Map original values to indices in unique array                     #
        [ 0 : n - 1 ]INT mapped;
        FOR i FROM LWB mapped TO UPB mapped DO
            mapped[ i ] := unique a INDEXOF a[ AT 0 ][ i ]
        OD;

        # Create wavelet matrix                                              #
        WAVELETMATRIX wm := create wavelet matrix( mapped, n, unique count );

        # Process queries                                                    #
        [,]INT queries = ( ( 2, 2, 1 ), ( 3, 4, 1 ), ( 4, 5, 1 ), ( 1, 2, 2 ), ( 4, 4, 1 ) );
             # ^^^^^^^ bounds are [ 1 : 5, 1 : 3 ]                           #

        FOR i FROM LWB queries TO UPB queries DO
            INT l = queries[ i, 1 ] - 1;              # Convert to 0-indexed #
            INT r = queries[ i, 2 ];
            INT k = queries[ i, 3 ];
            print( ( " ", whole( unique a[ quantile( wm, k - 1, l, r ) ], 0 ) ) )
        OD;
        print( ( newline ) )
    END
END
