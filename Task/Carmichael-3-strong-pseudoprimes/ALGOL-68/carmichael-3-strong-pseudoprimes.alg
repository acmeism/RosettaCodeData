# sieve of Eratosthene: sets s[i] to TRUE if i is prime, FALSE otherwise #
PROC sieve = ( REF[]BOOL s )VOID:
     BEGIN
        # start with everything flagged as prime                             #
        FOR i TO UPB s DO s[ i ] := TRUE OD;
        # sieve out the non-primes                                           #
        s[ 1 ] := FALSE;
        FOR i FROM 2 TO ENTIER sqrt( UPB s ) DO
            IF s[ i ] THEN FOR p FROM i * i BY i TO UPB s DO s[ p ] := FALSE OD FI
        OD
     END # sieve # ;

# construct a sieve of primes up to the maximum number required for the task #
# For Prime1, we need to check numbers up to around 120 000                  #
INT max number = 200 000;
[ 1 : max number ]BOOL is prime;
sieve( is prime );

# Find the Carmichael 3 Stromg Pseudoprimes for Prime1 up to 61              #

FOR prime1 FROM 2 TO 61 DO
    IF is prime[ prime 1 ] THEN
        FOR h3 TO prime1 - 1 DO
            FOR d TO ( h3 + prime1 ) - 1 DO
                IF   ( h3 + prime1 ) * ( prime1 - 1 ) MOD d = 0
                AND ( - ( prime1 * prime1 ) ) MOD h3 = d MOD h3
                THEN
                    INT prime2 = 1 + ( ( prime1 - 1 ) * ( h3 + prime1 ) OVER d );
                    IF is prime[ prime2 ] THEN
                        INT prime3 = 1 + ( prime1 * prime2 OVER h3 );
                        IF is prime[ prime3 ] THEN
                            IF ( prime2 * prime3 ) MOD ( prime1 - 1 ) = 1 THEN
                                print( ( whole( prime1, 0 ), " ", whole( prime2, 0 ), " ", whole( prime3, 0 ), newline ) )
                            FI
                        FI
                    FI
                FI
            OD
        OD
    FI
OD
