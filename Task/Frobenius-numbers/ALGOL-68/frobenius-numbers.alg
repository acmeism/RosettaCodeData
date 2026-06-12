BEGIN # find some Frobenius Numbers:                                         #
      #     Frobenius(n) = ( prime(n) * prime(n+1) ) - prime(n) - prime(n+1) #
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
    # show Frobenius numbers up to 10 000 #
    INT max number = 10 000;
    []INT prime    = prime list( max number );
    FOR i TO max number - 1
    WHILE INT frobenius number = ( ( prime[ i ] * prime[ i + 1 ] ) - prime[ i ] ) - prime[ i + 1 ];
              frobenius number < max number
    DO
        print( ( " ", whole( frobenius number, 0 ) ) )
    OD
END
