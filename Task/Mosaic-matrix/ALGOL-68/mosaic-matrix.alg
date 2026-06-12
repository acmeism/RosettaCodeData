BEGIN # draw a "mosaic matrix" - one with a 1 in the top-left and then  #
      # alternating with another character vertically and horizontally  #

    # draws a mosaic matrix with height and width = n using "1" and "." #
    PROC draw mosaic = ( INT n )VOID:
         FOR i TO n DO
             BOOL one := ODD i;
             TO n DO
                 print( ( " ", IF one THEN "1" ELSE "." FI ) );
                 one := NOT one
             OD;
            print( ( newline ) )
         OD # draw mosaic # ;

    # test the draw mosaic procedure #
    draw mosaic( 10 );
    print( ( newline ) );
    draw mosaic( 11 )
END
