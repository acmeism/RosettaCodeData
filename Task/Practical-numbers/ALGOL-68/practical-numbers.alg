BEGIN # find some practical numbers - positive integers n where subsets of   #
      # their proper divisors can be summed to every positive integer < n    #

    # returns TRUE if n is practical, FALSE otherwise                        #
    PROC is practical = ( INT n )BOOL:
         IF   n < 1 THEN FALSE
         ELIF n = 1 THEN TRUE
         ELIF ODD n THEN FALSE
         ELSE
            # get a list of the proper divisors of n                        #
            [ 1 : 30 ]INT pd;      # should be more than enough for n < 667 #
            INT pd pos := LWB pd - 1;

            # returns TRUE if a subset of pd can be summed to n, FALSE otherwise     #
            PROC can sum to = ( INT x )BOOL:
                 BEGIN
                    BOOL  found sum := FALSE;
                    INT   max v      = ( 2 ^ pd pos ) - 1;
                    FOR i TO max v WHILE NOT found sum DO
                        INT sum := 0;
                        INT v   := i;
                        INT bit := 0;
                        WHILE v > 0 DO
                            bit +:= 1;
                            IF ODD v THEN sum +:= pd[ bit ] FI;
                            v OVERAB 2
                        OD;
                        found sum := sum = x
                    OD;
                    found sum
                 END # can sum to # ;

             pd[ pd pos +:= 1 ] := 1;
             FOR i FROM 2 TO ENTIER sqrt( n ) DO
                 IF n MOD i = 0 THEN
                     pd[ pd pos +:= 1 ] := i;
                     INT j = n OVER i;
                     IF i /= j THEN pd[ pd pos +:= 1 ] := j FI
                 FI
             OD;
             # check that subsets of the divisors can be summed to every     #
             # integer less than n                                           #
             BOOL practical number := TRUE;
             FOR i TO n - 1 WHILE practical number := can sum to( i ) DO SKIP OD;
             practical number
         FI # is practical # ;

    [ 1 : 333 ]BOOL practical;
    FOR i FROM LWB practical TO UPB practical DO practical[ i ] := is practical( i ) OD;
    INT p count := 0;
    FOR i FROM LWB practical TO UPB practical DO IF practical[ i ] THEN p count +:= 1 FI OD;
    print( ( "Found ", whole( p count, 0 ), " practical numbers up to " ) );
    print( ( whole( UPB practical, 0 ), newline ) );
    INT count := 0;
    FOR i FROM LWB practical TO UPB practical WHILE count < 10 DO
        IF practical[ i ] THEN
            count +:= 1;
            print( ( " ", whole( i, 0 ) ) )
        FI
    OD;
    print( ( " ..." ) );
    count := 0;
    FOR i FROM LWB practical TO UPB practical DO
        IF practical[ i ] THEN
            count +:= 1;
            IF count > p count - 10 THEN print( ( " ", whole( i, 0 ) ) ) FI
        FI
    OD;
    print( ( newline ) );
    print( ( "666 is ", IF NOT is practical( 666 ) THEN "not " ELSE "" FI, "a practical number", newline ) )

END
