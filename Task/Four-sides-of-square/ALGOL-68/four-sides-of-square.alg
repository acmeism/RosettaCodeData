BEGIN # draw a matrix with 1s on the edges and 0s elsewhere             #
    # draws a matrix with height and width = n with 1s on the edges     #
    PROC draw square = ( INT n )VOID:
         FOR i TO n DO
             FOR j TO n DO
                 print( ( " ", whole( ABS ( i = 1 OR i = n OR j = 1 OR j = n ), 0 ) ) )
             OD;
             print( ( newline ) )
         OD # draw square # ;
    # test the draw square procedure #
    draw square( 6 );
    print( ( newline ) );
    draw square( 7 )
END
