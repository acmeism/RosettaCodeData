BEGIN # find the lowest 1-2 primes with n digits, 1-2 primes contain the     #
      #                                               digits 1 and 2 only    #

    PR read "primes.incl.a68" PR                   # include prime utilities #
    [ 1 : 20 ]CHAR v12;              # will hold the digits of the 1-2 prime #
    FOR i TO UPB v12 DO v12[ i ] := "0" OD;        # in little endian format #
    BOOL v12 overflowed := FALSE;

    # initialises v12 to digit count 1s                                      #
    PROC init v12 = ( INT digit count )VOID:
         BEGIN
            v12 overflowed := FALSE;
            FOR digit TO digit count DO
                v12[ digit ] := "1"
            OD
         END # init v12 # ;
    # sets v12 to value - the digits corresponding to the set bits of value  #
    #                                sre set to 2, the others 1              #
    PROC set v12 = ( INT digit count, INT value )VOID:
         BEGIN
            INT v := value;
            FOR digit TO digit count WHILE v > 0 DO
                v12[ digit ] := IF ODD v THEN "2" ELSE "1" FI;
                v OVERAB 2
            OD;
            v12 overflowed := v /= 0
         END # set v12 # ;

    # converts v12 to a numeric valiue                                       #
    PROC v12 value = ( INT digit count )LONG LONG INT:
         BEGIN
            LONG LONG INT n12 := 0;
            FOR digit FROM digit count BY -1 TO LWB v12 DO
                n12 *:= 10 +:= IF v12[ digit ] = "2" THEN 2 ELSE 1 FI
            OD;
            n12
         END # v12 value # ;

    # returns TRUE if the value in v12 is prime, FALSE otherwise             #
    PROC v12 is prime = ( INT digit count )BOOL: is probably prime( v12 value( digit count ) );

    # show the first 20 1-2 primes                                           #
    FOR digits TO 20 DO
        init v12( digits );
        # 2 can only be the final digit of the 1 digit 1-2 prime             #
        # for all other 1-2 primes, the final digit can't be 2               #
        FOR v FROM IF digits = 1 THEN 1 ELSE 2 FI BY 2 WHILE NOT v12 is prime( digits )
                                                         AND NOT v12 overflowed
        DO
            set v12( digits, v )
        OD;
        print( ( whole( digits, -5 ), ": " ) );
        IF v12 overflowed THEN
            # couldn't find a prime                                          #
            print( ( "-1" ) )
        ELSE
            # found a prime                                                  #
            FOR digit FROM digits BY -1 TO LWB v12 DO
                print( ( v12[ digit ] ) )
            OD
        FI;
        print( ( newline ) )
    OD

END
