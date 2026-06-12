BEGIN # draw a matrix with 1s on the diagonals and 0s elsewhere         #
    # draws a matrix with height and width = n with 1s on the diagonals #
    PROC draw 2 diagonals = ( INT n )VOID:
         BEGIN
            INT l pos := 1;
            INT r pos := n;
            TO n DO
                FOR j TO n DO
                    print( ( " ", whole( ABS ( j = l pos OR j = rpos ), 0 ) ) )
                OD;
                print( ( newline ) );
                l pos +:= 1;
                r pos -:= 1
            OD
         END # draw 2 diagonals # ;
    # test the draw 2 diagonals procedure #
    draw 2 diagonals( 10 );
    print( ( newline ) );
    draw 2 diagonals( 11 )
END
