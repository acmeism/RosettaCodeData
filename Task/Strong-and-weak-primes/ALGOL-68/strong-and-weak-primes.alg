# find and count strong and weak primes                                       #
PR heap=128M PR # set heap memory size for Algol 68G                          #
# returns a string representation of n with commas                            #
PROC commatise = ( INT n )STRING:
     BEGIN
        STRING result      := "";
        STRING unformatted  = whole( n, 0 );
        INT    ch count    := 0;
        FOR c FROM UPB unformatted BY -1 TO LWB unformatted DO
            IF   ch count <= 2 THEN ch count +:= 1
            ELSE                    ch count  := 1; "," +=: result
            FI;
            unformatted[ c ] +=: result
        OD;
        result
     END # commatise # ;
# sieve values                                                                #
CHAR prime     = "P"; #  unclassified/average prime                           #
CHAR strong    = "S"; #                strong prime                           #
CHAR weak      = "W"; #                  weak prime                           #
CHAR composite = "C"; #                   non-prime                           #
# sieve of Eratosthenes: sets s[i] to prime if i is a prime,                  #
#                                     composite otherwise                     #
PROC sieve = ( REF[]CHAR s )VOID:
     BEGIN
        # start with everything flagged as prime                              #
        FOR i TO UPB s DO s[ i ] := prime OD;
        # sieve out the non-primes                                            #
        s[ 1 ] := composite;
        FOR i FROM 2 TO ENTIER sqrt( UPB s ) DO
            IF s[ i ] = prime THEN FOR p FROM i * i BY i TO UPB s DO s[ p ] := composite OD FI
        OD
     END # sieve # ;

INT max number = 10 000 000;
# construct a sieve of primes up to slightly more than the maximum number     #
# required for the task, as we may need an extra prime for the classification #
[ 1 : max number + 1 000 ]CHAR primes;
sieve( primes );
# classify the primes                                                         #
# find the first three primes                                                 #
INT prev prime := 0;
INT curr prime := 0;
INT next prime := 0;
FOR p FROM 2 WHILE prev prime = 0 DO
    IF primes[ p ] = prime THEN
        prev prime := curr prime;
        curr prime := next prime;
        next prime := p
    FI
OD;
# 2 is the only even prime so the first three primes are the only case where  #
# the average of prev prime and next prime is not an integer                  #
IF   REAL avg = ( prev prime + next prime ) / 2;
     curr prime > avg THEN primes[ curr prime ] := strong
ELIF curr prime < avg THEN primes[ curr prime ] := weak
FI;
# classify the rest of the primes                                             #
FOR p FROM next prime + 1 WHILE curr prime <= max number DO
    IF primes[ p ] = prime THEN
        prev prime := curr prime;
        curr prime := next prime;
        next prime := p;
        IF   INT avg = ( prev prime + next prime ) OVER 2;
             curr prime > avg THEN primes[ curr prime ] := strong
        ELIF curr prime < avg THEN primes[ curr prime ] := weak
        FI
    FI
OD;
INT strong1 := 0, strong10 := 0;
INT weak1   := 0, weak10   := 0;
FOR p WHILE p < 10 000 000 DO
    IF   primes[ p ] = strong THEN
        strong10 +:= 1;
        IF p < 1 000 000 THEN strong1 +:= 1 FI
    ELIF primes[ p ] = weak   THEN
        weak10   +:= 1;
        IF p < 1 000 000 THEN weak1   +:= 1 FI
    FI
OD;
INT strong count  := 0;
print( ( "first 36 strong primes:", newline ) );
FOR p WHILE strong count < 36 DO IF primes[ p ] = strong THEN print( ( " ", whole( p, 0 ) ) ); strong count +:= 1 FI OD;
print( ( newline ) );
print( ( "strong primes below   1,000,000: ", commatise(  strong1 ), newline ) );
print( ( "strong primes below  10,000,000: ", commatise( strong10 ), newline ) );
print( ( "first 37   weak primes:", newline ) );
INT weak count    := 0;
FOR p WHILE weak count   < 37 DO IF primes[ p ] = weak   THEN print( ( " ", whole( p, 0 ) ) );   weak count +:= 1 FI OD;
print( ( newline ) );
print( ( "  weak primes below   1,000,000: ", commatise(    weak1 ), newline ) );
print( ( "  weak primes below  10,000,000: ", commatise(   weak10 ), newline ) )
