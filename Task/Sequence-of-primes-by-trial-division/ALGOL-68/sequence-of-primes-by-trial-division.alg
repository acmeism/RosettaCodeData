# is prime PROC from the primality by trial division task #
MODE ISPRIMEINT = INT;
PROC is prime = ( ISPRIMEINT p )BOOL:
  IF p <= 1 OR ( NOT ODD p AND p/= 2) THEN
    FALSE
  ELSE
    BOOL prime := TRUE;
    FOR i FROM 3 BY 2 TO ENTIER sqrt(p)
      WHILE prime := p MOD i /= 0 DO SKIP OD;
    prime
  FI;
# end of code from the primality by trial division task #

# returns an array of n primes >= start #
PROC prime sequence = ( INT start, INT n )[]INT:
     BEGIN
        [ n ]INT seq;
        INT      prime count := 0;
        FOR p FROM start WHILE prime count < n DO
            IF is prime( p ) THEN
                prime count +:= 1;
                seq[ prime count ] := p
            FI
        OD;
        seq
     END; # prime sequence #

# find 20 primes >= 30 #
[]INT primes = prime sequence( 30, 20 );
print( ( "20 primes starting at 30: " ) );
FOR p FROM LWB primes TO UPB primes DO
    print( ( " ", whole( primes[ p ], 0 ) ) )
OD;
print( ( newline ) )
