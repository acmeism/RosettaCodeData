BEGIN # find even numbers that are not the sum of two twin primes           #

    # prints the non-twin prime sum numbers                                 #
    PROC show non twin prime sums = ( STRING legend, []BOOL p2sums )VOID:
         BEGIN
            print( ( legend, ":", newline ) );
            INT count   := 0;
            INT per line = 10;
            FOR i FROM 2 BY 2 TO max number DO
                IF NOT p2sum[ i ] THEN
                    print( ( whole( i, - 6 ) ) );
                    IF ( count +:= 1 ) MOD per line = 0 THEN print( ( newline ) ) FI
                FI
            OD;
            IF count MOD per line /= 0 THEN print( ( newline ) ) FI;
            print( ( "Found ", whole( count, 0 ), newline, newline ) )
         END # print non twin primes sums # ;

    INT max number = 100 000;             # maximum number we will consider #
    [ 0 : max number ]BOOL prime;          # sieve the primes to max number #
    prime[ 0 ] := prime[ 1 ] := FALSE;
    prime[ 2 ] := TRUE;
    FOR i FROM 3 BY 2 TO UPB prime DO prime[ i ] := TRUE  OD;
    FOR i FROM 4 BY 2 TO UPB prime DO prime[ i ] := FALSE OD;
    FOR i FROM 3 BY 2 TO ENTIER sqrt( UPB prime ) DO
        IF prime[ i ] THEN
            FOR s FROM i * i BY i + i TO UPB prime DO prime[ s ] := FALSE OD
        FI
    OD;
    prime[ 2 ] := FALSE;           # restrict the sieve to twin primes only #
    FOR i FROM 3 BY 2 TO max number - 2 DO
        IF prime[ i ] AND NOT prime[ i - 2 ] AND NOT prime[ i + 2 ] THEN
            prime[ i ] := FALSE
        FI
    OD;
    # construct a table of the even numbers that can be formed by summing   #
    # two twin primes                                                       #
    [ 1 : max number ]BOOL p2sum; FOR i TO UPB p2sum DO p2sum[ i ] := FALSE OD;
    FOR i FROM 3 BY 2 TO max number DO
        IF prime[ i ] THEN
            FOR j FROM i TO ( max number + 1 ) - i DO
                IF prime[ j ] THEN p2sum[ i + j ] := TRUE FI
            OD
        FI
    OD;

    # print the even numbers which aren't the sum of 2 twin primes          #
    show non twin prime sums( "Non twin prime sums", p2sum );

    # adjust the table as if 1 was a twin prime                             #
    p2sum[ 2 ] := TRUE;
    FOR i FROM 3 BY 2 TO max number DO
        IF prime[ i ] THEN p2sum[ i + 1 ] := TRUE FI
    OD;

    # print the revised even numbers which aren't the sum of 2 twin primes  #
    show non twin prime sums( "Non twin prime sums (including 1)", p2sum )

END
