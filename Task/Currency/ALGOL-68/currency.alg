BEGIN
    # currency calculations                                              #
    # simple fixed point type, LONG INT is 64-bit in Algol 68G           #
    MODE FIXED    = STRUCT( LONG INT value
                          , INT      decimals
                          , INT      fraction modulus
                          );
    # make CURRENCY a synonym for FIXED                                  #
    MODE CURRENCY = FIXED;
    # dyadic operator so we can write e.g. 5 DOLLARS 50 to construct     #
    # a CURRENCY value with 2 decimal places                             #
    PRIO DOLLARS = 9;
    OP DOLLARS = ( LONG INT v, INT dp )CURRENCY: ( ( v * 100 ) + dp, 2, 100 );
    OP DOLLARS = (      INT v, INT dp )CURRENCY: LENG v DOLLARS dp;
    # issues an error message and stops the program if a has a different #
    # number of decimal places to b                                      #
    PROC check compatible = ( CURRENCY a, b )VOID:
         IF decimals OF a /= decimals OF b THEN print( ( "Incompatible CURRENCY values", newline ) ); stop FI;
    # operators to multiply CURRENCY values by integers                  #
    OP * = ( CURRENCY v, LONG INT m )CURRENCY: ( value OF v * m, decimals OF v, fraction modulus OF v );
    OP * = ( CURRENCY v,      INT m )CURRENCY: v * LENG m;
    # returns the CURRENCY value a + b                                   #
    OP + = ( CURRENCY a, CURRENCY b )CURRENCY:
         BEGIN
            check compatible( a, b );
            ( value OF a + value OF b, decimals OF a, fraction modulus OF a )
         END # + # ;
    # multiplies the CURRENCY value a by the FIXED value b,              #
    # rounding the result to the decimal places of a                     #
    OP * = ( CURRENCY a, FIXED b )CURRENCY:
         BEGIN
            LONG INT result := ( value OF a * value OF b );
            IF decimals OF b > 0 THEN
                INT d                = fraction modulus OF b;
                LONG INT abs result := ABS result;
                INT extra places     = SHORTEN ( abs result MOD d );
                abs result OVERAB d;
                IF extra places >= d OVER 2 THEN abs result +:= 1 FI;
                IF result < 0 THEN result := - abs result ELSE result := abs result FI
            FI;
            ( result, decimals OF a, fraction modulus OF a )
         END # * # ;
    # converts a FIXED value to a STRING with the appropriate number of  #
    # decimal places                                                     #
    OP TOSTRING = ( FIXED v )STRING:
         IF decimals OF v < 1 THEN
            whole( value OF v, 0 )
         ELSE
            INT    d       = fraction modulus OF v;
            STRING result := whole( value OF v OVER d, 0 );
            STRING dp     := whole( ( ABS value OF v ) MOD d, - decimals OF v );
            FOR i FROM LWB dp TO UPB dp DO IF dp[ i ] = " " THEN dp[ i ] := "0" FI OD;
            result + "." + dp
         FI # TOSTRING # ;
    # Task calculations                                                   #
    CURRENCY hb    = 5 DOLLARS 50 * LONG 4000000000000000;
    CURRENCY ms    = 2 DOLLARS 86 * 2;
    FIXED    rate  = ( 765, 4, 10 000 ); # 0.0765                         #
    CURRENCY net   = hb + ms;
    CURRENCY tax   = net * rate;
    CURRENCY total = net + tax;
    print( ( "before tax: ", TOSTRING net,   newline ) );
    print( ( "tax:        ", TOSTRING tax,   newline ) );
    print( ( "total:      ", TOSTRING total, newline ) )
END
