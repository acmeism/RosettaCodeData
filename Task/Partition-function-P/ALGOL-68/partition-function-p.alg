BEGIN # calculate the partition function of some integers                    #
      # translated from the FreeBASIC sample                                 #
    PR precision 128 PR         # set the number of digits for LONG LONG INT #
    MODE PARTINT = LONG LONG INT;
    PROC partitions p = ( INT n )PARTINT:
         BEGIN
            [ 0 : n ]PARTINT p; FOR i FROM LWB p TO UPB p DO p[ i ] := 0 OD;
            p[ 0 ] := 1;
            FOR i TO n DO
                INT k := 0;
                WHILE k +:= 1;
                      INT j := ( k * ( 3 * k - 1 ) ) OVER 2;
                      IF j > i
                      THEN FALSE         # exit the loop #
                      ELSE IF ODD k THEN
                              p[ i ] +:= p[ i - j ]
                           ELSE
                              p[ i ] -:= p[ i - j ]
                           FI;
                           j +:= k;
                           IF j > i
                           THEN FALSE    # exit the loop #
                           ELSE IF ODD k THEN
                                   p[ i ] +:= p[ i - j ]
                                ELSE
                                   p[ i ] -:= p[ i - j ]
                                FI;
                                TRUE  # continue to loop #
                           FI
                      FI
                DO SKIP OD
            OD;
            p[ n ]
         END # partitions p # ;

    BEGIN
        print( ( "P(0..12):" ) );
        FOR x FROM 0 TO 12 DO
            print( ( " ", whole( partitions p( x ), 0 ) ) )
        OD;
        print( ( newline, "P(127):   ", whole( partitions p(  127 ), 0 ) ) );
        print( ( newline, "P(255):   ", whole( partitions p(  255 ), 0 ) ) );
        print( ( newline, "P(6666):  ", whole( partitions p( 6666 ), 0 ) ) );
        print( ( newline ) )
    END
END
