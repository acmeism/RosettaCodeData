BEGIN # draw some cuboids using ASCII art                                    #

    # draws a cuboid standing on one edge using ASCII art                    #
    PROC aa cuboid = ( INT h, w, l )VOID:
         BEGIN
             # top line                                                      #
             TO l     DO print( ( " " ) ) OD;
             TO w + 1 DO print( ( "_" ) ) OD;
             print( ( newline ) );
             # rest of the top face and part of the visible side             #
             INT face width := 0;
             INT edge pos   := 0;
             FOR i TO l DO
                 TO l - i DO print( ( " " ) ) OD;
                 print( ( "/" ) );
                 TO w DO print( ( IF i = l THEN "_" ELSE " " FI ) ) OD;
                 print( ( "/" ) );
                 edge pos +:= 1;
                 IF edge pos <= h THEN
                     # drsw the back edge                                    #
                     face width := 2 * ( edge pos - 1 );
                     TO face width DO print( ( " " ) ) OD;
                     print( ( "\" ) )
                 ELSE
                     # draw the bottom edge                                  #
                     TO face width + 1 DO print( ( " " ) ) OD;
                     print( ( "/" ) )
                 FI;
                 print( ( newline ) )
             OD;
             # other vidible face                                            #
             FOR i TO h DO
                 TO i - 1 DO print( ( " " ) ) OD;
                 print( ( "\" ) );
                 TO w DO print( ( IF i = h THEN "_" ELSE " " FI ) ) OD;
                 print( ( "\" ) );
                 edge pos +:= 1;
                 IF edge pos <= h THEN
                     # drsw the back edge                                    #
                     TO face width + 1 DO print( ( " " ) ) OD;
                     print( ( "\" ) )
                 ELSE
                     # draw the bottom edge                                  #
                     TO face width DO print( ( " " ) ) OD;
                     face width -:= 2;
                     print( ( "/" ) )
                 FI;
                 print( ( newline ) )
             OD

         END # aa cuboid # ;

    aa cuboid( 3, 2, 4 );
    aa cuboid( 4, 3, 2 );
    aa cuboid( 2, 4, 3 );
    aa cuboid( 2, 3, 4 )

END
