BEGIN # find some Orimiston pairs - pairs of primes where the first and next  #
      # prime are anagrams                                                    #
    PR read "primes.incl.A68" PR                    # include prime utilities #
    INT max prime  = 10 000 000;            # maximum number we will consider #
    INT max digits = BEGIN                    # count the digits of max prime #
                        INT v := 1;
                        INT d := 1;
                        WHILE ( v *:= 10 ) < max prime DO d +:= 1 OD;
                        d
                     END;
    [ 0 : 9 ]LONG INT dp;  # table of max digit powers for signature creation #
    dp[ 0 ] := 1; FOR i TO UPB dp DO dp[ i ] := max digits * dp[ i - 1 ] OD;
    []BOOL prime      = PRIMESIEVE max prime;
    # construct a list of the primes up to the maximum prime to consider      #
    []INT  prime list = EXTRACTPRIMESUPTO max prime FROMPRIMESIEVE prime;
    # splits n into its digits, returning the sum of their counts, each       #
    # scaled by the digit power of max digits                                 #
    PROC get digits = ( INT n )LONG INT:
         BEGIN
            INT      v      := n;
            LONG INT result := dp[ v MOD 10 ];
            WHILE ( v OVERAB 10 ) > 0 DO
                result +:= dp[ v MOD 10 ]
            OD;
            result
         END # get digits # ;
    # count the Ormiston pairs                                                #
    INT o count := 0;
    INT n count := 0;
    INT p10     := 100 000;
    FOR i TO UPB prime list - 1 DO
        INT p1 = prime list[ i     ];
        INT p2 = prime list[ i + 1 ];
        IF ( p2 - p1 ) MOD 18 = 0 THEN
            # p2 and p1 might be anagrams                                     #
            IF get digits( p1 ) /= get digits( p2 ) THEN
                # not an Ormiston pair afterall                               #
                n count +:= 1
            ELSE
                # p1 and p2 are an Ormiston pair                              #
                o count +:= 1;
                IF o count <= 30 THEN
                    print( ( " (", whole( p1, -5 ), ", ", whole( p2, -5 ), ")"
                           , IF o count MOD 3 = 0 THEN newline ELSE " " FI
                           )
                         )
                ELIF p1 >= p10 THEN
                    print( ( whole( o count - 1, -9 )
                           , " Ormiston pairs below "
                           , whole( p10, 0 )
                           , newline
                           )
                         );
                    p10 *:= 10
                FI
            FI
        FI
    OD;
    print( ( whole( o count, -9 ), " Ormiston pairs below ", whole( max prime, 0 ), newline ) );
    print( ( whole( n count, -9 ), " non-Ormiston ""0 MOD 18"" pairs bwlow ", whole( max prime, 0 ) ) )
END
