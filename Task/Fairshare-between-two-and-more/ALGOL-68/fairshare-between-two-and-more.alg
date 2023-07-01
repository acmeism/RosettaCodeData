BEGIN # Use the generalised Thue-Morse sequence to generate Fairshare        #
      # sequences for various numbers of people                              #
    # returns the digit sum of n in the specified base                       #
    PROC digit sum = ( INT n, base )INT:
         IF n = 0 THEN 0
         ELSE
             INT result := 0;
             INT v      := ABS n;
             WHILE v > 0 DO
                 result +:= v MOD base;
                 v   OVERAB base
             OD;
             result
         FI # digit sum # ;
    # show the first n terms of the fairshare sequence in the specified base #
    PROC show fairshare = ( INT n, base )VOID:
         BEGIN
             print( ( whole( base, -2 ), ":" ) );
             FOR i FROM 0 TO n - 1 DO
                 print( ( " ", whole( digit sum( i, base ) MOD base, -2 ) ) )
             OD;
             print( ( newline ) )
         END # show fairshare # ;

    show fairshare( 25,  2 );
    show fairshare( 25,  3 );
    show fairshare( 25,  5 );
    show fairshare( 25, 11 )
END
