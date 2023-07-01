BEGIN # calculate values of the Goldbach function G where G(n) is the number #
      # of prime pairs that sum to n, n even and > 2                         #
      # generates an ASCII scatter plot of G(n) up to G(2000)                #
      # (Goldbach's Comet)                                                   #
    PR read "primes.incl.a68" PR          # include prime utilities          #
    INT max prime = 1 000 000;            # maximum number we will consider  #
    INT max plot  =     2 000;            # maximum G value for the comet    #
    []BOOL prime = PRIMESIEVE max prime;  # sieve of primes to max prime     #
    [ 0 : max plot ]INT g2;               # table of G values: g2[n] = G(2n) #
    # construct the table of G values #
    FOR n FROM LWB g2 TO UPB g2 DO g2[ n ] := 0 OD;
    g2[ 4 ] := 1;                     # 4 is the only sum of two even primes #
    FOR p FROM 3 BY 2 TO max plot OVER 2 DO
        IF prime[ p ] THEN
            g2[ p + p ] +:= 1;
            FOR q FROM p + 2 BY 2 TO max plot - p DO
                IF prime[ q ] THEN
                    g2[ p + q ] +:= 1
                FI
            OD
        FI
    OD;
    # show the first hundred G values #
    INT c := 0;
    FOR n FROM 4 BY 2 TO 202 DO
        print( ( whole( g2[ n ], -4 ) ) );
        IF ( c +:= 1 ) = 10 THEN print( ( newline ) ); c := 0 FI
    OD;
    # show G( 1 000 000 ) #
    INT gm := 0;
    FOR p FROM 3 TO max prime OVER 2 DO
        IF prime[ p ] THEN
            IF prime[ max prime - p ] THEN
                gm +:= 1
            FI
        FI
    OD;
    print( ( "G(", whole( max prime, 0 ), "): ", whole( gm, 0 ), newline ) );
    # find the maximum value of G up to the maximum plot size #
    INT max g := 0;
    FOR n FROM 2 BY 2 TO max plot DO
        IF g2[ n ] > max g THEN max g := g2[ n ] FI
    OD;
    # draw an ASCII scatter plot of G, each position represents 5 G values #
    # the vertical axis is n/10, the horizontal axis is G(n) #
    INT plot step = 10;
    STRING plot value = " .-+=*%$&#@";
    FOR g FROM 0 BY plot step TO max plot - plot step DO
        [ 0 : max g ]INT values;
        FOR v pos FROM LWB values TO UPB values DO values[ v pos ] := 0 OD;
        INT max v := 0;
        FOR g element FROM g BY 2 TO g + ( plot step - 1 ) DO
            INT g2 value = g2[ g element ];
            values[ g2 value ] +:= 1;
            IF g2 value > max v THEN max v := g2 value FI
        OD;
        print( ( IF g MOD 100 = 90 THEN "+" ELSE "|" FI ) );
        FOR v pos FROM 1 TO max v DO # exclude 0 values from the plot #
            print( ( plot value[ values[ v pos ] + 1 ] ) )
        OD;
        print( ( newline ) )
    OD
END
