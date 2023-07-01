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
INT max number = 10 000;
[ 1 : max number ]BOOL is prime;
sieve( is prime );

# returns the sum of the digits of n                                         #
OP DIGITSUM = ( INT n )INT:
   BEGIN
       INT sum  := 0;
       INT rest := ABS n;
       WHILE rest > 0 DO
           sum +:= rest MOD 10;
           rest OVERAB 10
       OD;
       sum
   END # DIGITSUM # ;

# returns TRUE if n is a Smith number, FALSE otherwise                       #
# n must be between 1 and max number                                         #
PROC is smith = ( INT n )BOOL:
     IF is prime[ ABS n ] THEN
         # primes are not Smith numbers                                      #
         FALSE
     ELSE
         # find the factors of n and sum the digits of the factors           #
         INT rest             := ABS n;
         INT factor digit sum := 0;
         INT factor           := 2;
         WHILE factor < max number AND rest > 1 DO
             IF NOT is prime[ factor ] THEN
                 # factor isn't a prime                                      #
                 factor +:= 1
             ELSE
                 # factor is a prime                                         #
                 IF rest MOD factor /= 0 THEN
                     # factor isn't a factor of n                            #
                     factor +:= 1
                 ELSE
                     # factor is a factor of n                               #
                     rest OVERAB factor;
                     factor digit sum +:= DIGITSUM factor
                 FI
             FI
         OD;
         ( factor digit sum = DIGITSUM n )
     FI # is smith # ;

# print all the Smith numbers below the maximum required                     #
INT smith count := 0;
FOR n TO max number - 1 DO
    IF is smith( n ) THEN
        # have a smith number #
        print( ( whole( n, -7 ) ) );
        smith count +:= 1;
        IF smith count MOD 10 = 0 THEN
            print( ( newline ) )
        FI
    FI
OD;
print( ( newline, "THere are ", whole( smith count, -7 ), " Smith numbers below ", whole( max number, -7 ), newline ) )
