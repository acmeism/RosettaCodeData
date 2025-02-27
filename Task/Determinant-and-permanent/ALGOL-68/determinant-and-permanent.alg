BEGIN # matrix determinant and permanent #
      # - translated from the Phix sample, via EasyLang #

    MODE NUMBER = REAL; # type of matrix elements to be handled #
                        # adjust to suit, if necessary          #

    PROC minor = ( [,]NUMBER a, INT x, y )[,]NUMBER:
         BEGIN
            [ 1 LWB a : 1 UPB a - 1, 2 LWB a : 2 UPB a - 1 ]NUMBER r;
            FOR i FROM 1 LWB a TO 1 UPB a - 1 DO
                FOR j FROM 2 LWB a TO 2 UPB a - 1 DO
                    r[ i, j ] := a[ i + ABS ( i >= x ), j + ABS ( j >= y ) ]
                OD
            OD;
            r
         END #  minor # ;

    PROC det = ( [,]NUMBER a )NUMBER:
         IF 1 UPB a = 1 LWB a THEN # only one NUMBER #
            a[ 1 LWB a, 2 LWB a ]
         ELSE
            INT    sgn := 1;
            NUMBER res := 0;
            FOR i FROM 2 LWB a TO 2 UPB a DO
               res +:= sgn * a[ 1 LWB a, i ] * det( minor( a, 1 LWB a, i ) );
               sgn := - sgn
            OD;
            res
         FI # det # ;

    PROC perm = ( [,]NUMBER a )NUMBER:
         IF 1 UPB a = 1 LWB a THEN # only one NUMBER #
            a[ 1 LWB a, 2 LWB a ]
         ELSE
            NUMBER res := 0;
            FOR i FROM 2 LWB a TO 2 UPB a DO
               res +:= a[ 1 LWB a, i ] * perm( minor( a, 1 LWB a, i ) )
            OD;
            res
         FI # perm # ;

    BEGIN # test cases #
        PROC test det and perm = ( [,]NUMBER a )VOID:
             print( ( whole( det( a ), -8 ), " ", whole( perm( a ), -8 ), newline ) );

        test det and perm( ( ( 1, 2 )
                           , ( 3, 4 )
                           )
                         );
        test det and perm( ( ( 2, 9, 4 )
                           , ( 7, 5, 3 )
                           , ( 6, 1, 8 )
                         ) );
        test det and perm( ( ( -2, 2, -3 )
                           , ( -1, 1,  3 )
                           , (  2, 0, -1 )
                           )
                         );
        test det and perm( ( (  1,  2,  3,  4 )
                           , (  4,  5,  6,  7 )
                           , (  7,  8,  9, 10 )
                           , ( 10, 11, 12, 13 )
                           )
                         );
        test det and perm( ( (  0,  1,  2,  3,  4 )
                           , (  5,  6,  7,  8,  9 )
                           , ( 10, 11, 12, 13, 14 )
                           , ( 15, 16, 17, 18, 19 )
                           , ( 20, 21, 22, 23, 24 )
                           )
                         );
        test det and perm( ( ( 5 ) ) );
        test det and perm( ( ( 1, 0, 0 )
                           , ( 0, 1, 0 )
                           , ( 0, 0, 1 )
                           )
                         );
        test det and perm( ( ( 0, 0, 1 )
                           , ( 0, 1, 0 )
                           , ( 1, 0, 0 )
                           )
                         )
    END
END
