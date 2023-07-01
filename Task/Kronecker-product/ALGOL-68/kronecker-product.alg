BEGIN
    # multiplies in-place the elements of the matrix a by the scaler b #
    OP *:= = ( REF[,]INT a, INT b )REF[,]INT:
    BEGIN
        FOR i FROM 1 LWB a TO 1 UPB a DO
            FOR j FROM 2 LWB a TO 2 UPB a DO
                a[ i, j ] *:= b
            OD
        OD;
        a
    END # *:= # ;
    # returns the Kronecker Product of the two matrices a and b #
    # the result will have lower bounds of 1                    #
    PRIO X = 6;
    OP   X = ( [,]INT a, b )[,]INT:
    BEGIN
        # normalise the matrices to have lower bounds of 1 #
        [,]INT l = a[ AT 1, AT 1 ];
        [,]INT r = b[ AT 1, AT 1 ];
        # construct the result #
        INT r 1 size = 1 UPB r;
        INT r 2 size = 2 UPB r;
        [ 1 : 1 UPB l * 1 UPB r, 1 : 2 UPB l * 2 UPB r ]INT k;
        FOR i FROM 1 LWB l TO 1 UPB l DO
            FOR j FROM 2 LWB l TO 2 UPB l DO
                ( k[ 1 + ( ( i - 1 ) * r 1 size ) : i * r 1 size
                   , 1 + ( ( j - 1 ) * r 2 size ) : j * r 2 size
                   ] := r
                ) *:= l[ i, j ]
            OD
        OD;
        k
    END # X # ;
    # prints matrix a with the specified field width #
    PROC print matrix = ( [,]INT a, INT field width )VOID:
    FOR i FROM 1 LWB a TO 1 UPB a DO
        FOR j FROM 2 LWB a TO 2 UPB a DO
            print( ( " ", whole( a[ i, j ], field width ) ) )
        OD;
        print( ( newline ) )
    OD # print matrix # ;
    # task test cases #
    print matrix( [,]INT( ( 1, 2 )
                        , ( 3, 4 )
                        )
                X [,]INT( ( 0, 5 )
                        , ( 6, 7 )
                        )
                , -2
                );
    print( ( newline ) );
    print matrix( [,]INT( ( 0, 1, 0 )
                        , ( 1, 1, 1 )
                        , ( 0, 1, 0 )
                        )
                X [,]INT( ( 1, 1, 1, 1 )
                        , ( 1, 0, 0, 1 )
                        , ( 1, 1, 1, 1 )
                        )
                , -1
                )
END
