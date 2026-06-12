BEGIN # find some odd square free semi-primes                    #
      # numbers of the form p*q where p =/= q and p, q are prime #
    # reurns a list of primes up to n #
    PROC prime list = ( INT n )[]INT:
         BEGIN
            # sieve the primes to n #
            INT no = 0, yes = 1;
            [ 1 : n ]INT p;
            p[ 1 ] := no; p[ 2 ] := yes;
            FOR i FROM 3 BY 2 TO n DO p[ i ] := yes OD;
            FOR i FROM 4 BY 2 TO n DO p[ i ] := no  OD;
            FOR i FROM 3 BY 2 TO ENTIER sqrt( n ) DO
                IF p[ i ] = yes THEN FOR s FROM i * i BY i + i TO n DO p[ s ] := no OD FI
            OD;
            # replace the sieve with a list #
            INT p pos := 0;
            FOR i TO n DO IF p[ i ] = yes THEN p[ p pos +:= 1 ] := i FI OD;
            p[ 1 : p pos ]
         END # prime list # ;
    # show odd square free semi-primes up to 1000 #
    INT max number = 1000;
    INT max prime  = 1 + ( max number OVER 3 ); # the smallest odd prime is 3, so this shuld be enough primes #
    []INT prime    = prime list( max prime );
    [ 1 : max number ]BOOL numbers; FOR i TO max number DO numbers[ i ] := FALSE OD;
    FOR i FROM 2 TO UPB prime - 1 DO
        FOR j FROM i + 1 TO UPB prime
        WHILE INT pq = prime[ i ] * prime[ j ];
              pq < max number
        DO
            numbers[ pq ] := TRUE
        OD
    OD;
    INT n count   := 0;
    FOR i TO max number DO
        IF numbers[ i ] THEN
            print( ( " ", whole( i, -4 ) ) );
            n count +:= 1;
            IF n count MOD 20 = 0 THEN print( ( newline ) ) FI
        FI
    OD
END
