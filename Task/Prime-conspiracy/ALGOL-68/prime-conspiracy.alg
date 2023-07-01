# extend SET, CLEAR and ELEM to operate on rows of BITS #
OP   SET   = ( INT n, REF[]BITS b )REF[]BITS:
     BEGIN
         INT w = n OVER bits width;
         b[ w ] := ( ( 1 + ( n MOD bits width ) ) SET b[ w ] );
         b
     END # SET # ;
OP   CLEAR = ( INT n, REF[]BITS b )REF[]BITS:
     BEGIN
         INT w = n OVER bits width;
         b[ w ] := ( ( 1 + ( n MOD bits width ) ) CLEAR b[ w ] );
         b
     END # SET # ;
OP   ELEM  = ( INT n, REF[]BITS b )BOOL: ( 1 + ( n MOD bits width ) ) ELEM b[ n OVER bits width ];

# constructs a bit array long enough to hold n values #
OP   BITARRAY = ( INT n )REF[]BITS: HEAP[ 0 : n OVER bits width ]BITS;

# construct a BITS value of all TRUE #
BITS all true = BEGIN
                    BITS v := 16r0;
                    FOR bit TO bits width DO v := bit SET v OD;
                    v
                END;

# initialises a bit array to all TRUE #
OP   SETALL   = ( REF[]BITS b )REF[]BITS:
     BEGIN
         FOR p FROM LWB b TO UPB b DO b[ p ] := all true OD;
         b
     END # SETALL # ;

# construct a sieve initialised to all TRUE apart from the first bit      #
INT sieve max = 15 500 000; # somewhat larger than the 1 000 000th prime  #
INT prime max =  1 000 000;
REF[]BITS sieve = 1 CLEAR SETALL BITARRAY sieve max;

# sieve the primes #
FOR s FROM 2 TO ENTIER sqrt( sieve max ) DO
    IF s ELEM sieve
    THEN
        FOR p FROM s * s BY s TO sieve max DO p CLEAR sieve OD
    FI
OD;

# count the number of times each combination of                           #
# ( last digit of previous prime, last digit of prime ) occurs            #
[ 0 : 9, 0 : 9 ]INT counts;
FOR p FROM 0 TO 9 DO FOR n FROM 0 TO 9 DO counts[ p, n ] := 0 OD OD;
INT previous prime := 2;
INT primes found   := 1;
FOR p FROM 3 TO sieve max WHILE primes found < prime max DO
    IF p ELEM sieve
    THEN
        primes found +:= 1;
        counts[ previous prime MOD 10, p MOD 10 ] +:= 1;
        previous prime := p
    FI
OD;

# print the counts #
# there are thus 4 possible final digits: 1, 3, 7, 9                      #
STRING labels = "123456789";                   # "labels" for the counts  #
INT total := 0;
FOR p TO 9 DO FOR n TO 9 DO total +:= counts[ p, n ] OD OD;
print( ( whole( primes found, 0 ), " primes, last prime considered: ", previous prime, newline ) );
FOR p TO 9 DO
    FOR n TO 9 DO
        IF counts[ p, n ] /= 0
        THEN
            print( ( labels[ p ], "->", labels[ n ]
                   , whole( counts[ p, n ], -8 )
                   , fixed( ( 100 * counts[ p, n ] ) / total, -8, 2 )
                   , newline
                   )
                 )
        FI
    OD
OD
