BEGIN
    # count twin primes (where p and p - 2 are prime)                             #
    PR heap=128M PR # set heap memory size for Algol 68G                          #
    # sieve of Eratosthenes: sets s[i] to TRUE if i is a prime, FALSE otherwise   #
    PROC sieve = ( REF[]BOOL s )VOID:
         BEGIN
            FOR i TO UPB s DO s[ i ] := TRUE OD;
            s[ 1 ] := FALSE;
            FOR i FROM 2 TO ENTIER sqrt( UPB s ) DO
                IF s[ i ] THEN FOR p FROM i * i BY i TO UPB s DO s[ p ] := FALSE OD FI
            OD
         END # sieve # ;
    # find the maximum number to search for twin primes                           #
    INT max;
    print( ( "Maximum: " ) );
    read( ( max, newline ) );
    INT max number = max;
    # construct a sieve of primes up to the maximum number                        #
    [ 1 : max number ]BOOL primes;
    sieve( primes );
    # count the twin primes                                                       #
    # note 2 cannot be one of the primes in a twin prime pair, so we start at 3   #
    INT twin count := 0;
    FOR p FROM 3 BY 2 TO max number - 1 DO IF primes[ p ] AND primes[ p - 2 ] THEN twin count +:= 1 FI OD;
    print( ( "twin prime pairs below  ", whole( max number, 0 ), ": ", whole( twin count, 0 ), newline ) )
END
