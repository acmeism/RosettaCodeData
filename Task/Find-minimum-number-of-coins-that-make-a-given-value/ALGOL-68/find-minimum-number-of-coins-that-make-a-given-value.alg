BEGIN # find the minimum number of coins needed to make a given value         #
      # translated from the Wren sample                                       #

    []INT denoms     = ( 200, 100, 50, 20, 10, 5, 2, 1 );
    INT   coins     := 0;
    INT   amount     = 988;
    INT   remaining := amount;
    print( ( "The minimum number of coins needed to make a value of " ) );
    print( ( whole( amount, 0 ), " is as follows:", newline ) );
    FOR d pos FROM LWB denoms TO UPB denoms
    WHILE INT denom = denoms[ d pos ];
          INT n     = remaining OVER denom;
          IF n > 0 THEN
              coins +:= n;
              print( ("  ", whole( denom, -3 ), " x ", whole( n, 0 ), newline ) );
              remaining MODAB denom
          FI;
          remaining > 0
    DO SKIP OD;
    print( ( newline, "A total of ", whole( coins, 0 ), " coins in all.", newline ) )
END
