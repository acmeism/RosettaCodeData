# find and count safe and unsafe primes                                       #
# safe primes are primes p such that ( p - 1 ) / 2 is also prime              #
# unsafe primes are primes that are not safe                                  #
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
CHAR prime     = "P"; # unclassified prime                                    #
CHAR safe      = "S"; # safe prime                                            #
CHAR unsafe    = "U"; # unsafe prime                                          #
CHAR composite = "C"; # non-prime                                             #
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
# construct a sieve of primes up to the maximum number                        #
[ 1 : max number ]CHAR primes;
sieve( primes );
# classify the primes                                                         #
# ( p - 1 ) OVER 2 is non-zero for p >= 3, thus we know 2 is unsafe           #
primes[ 2 ] := unsafe;
FOR p FROM 3 TO UPB primes DO
    IF primes[ p ] = prime THEN
        primes[ p ] := IF primes[ ( p - 1 ) OVER 2 ] = composite THEN unsafe ELSE safe FI
    FI
OD;
# count the primes of each type                                               #
INT safe1   := 0, safe10   := 0;
INT unsafe1 := 0, unsafe10 := 0;
FOR p FROM LWB primes TO UPB primes DO
    IF   primes[ p ] = safe  THEN
        safe10   +:= 1;
        IF p < 1 000 000 THEN safe1   +:= 1 FI
    ELIF primes[ p ] = unsafe THEN
        unsafe10 +:= 1;
        IF p < 1 000 000 THEN unsafe1 +:= 1 FI
    FI
OD;
INT safe count    := 0;
print( ( "first 35 safe   primes:", newline ) );
FOR p WHILE safe count   < 35 DO IF primes[ p ] = safe   THEN print( ( " ", whole( p, 0 ) ) ); safe count +:= 1 FI OD;
print( ( newline ) );
print( ( "safe   primes below   1,000,000: ", commatise(    safe1 ), newline ) );
print( ( "safe   primes below  10,000,000: ", commatise(   safe10 ), newline ) );
print( ( "first 40 unsafe primes:", newline ) );
INT unsafe count := 0;
FOR p WHILE unsafe count < 40 DO IF primes[ p ] = unsafe THEN print( ( " ", whole( p, 0 ) ) ); unsafe count +:= 1 FI OD;
print( ( newline ) );
print( ( "unsafe primes below   1,000,000: ", commatise(  unsafe1 ), newline ) );
print( ( "unsafe primes below  10,000,000: ", commatise( unsafe10 ), newline ) )
