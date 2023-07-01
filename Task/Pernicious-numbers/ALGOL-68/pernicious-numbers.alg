# calculate various pernicious numbers                          #

# returns the population (number of bits on) of the non-negative integer n    #
PROC population = ( INT n )INT:
     BEGIN
        INT    number := n;
        INT    result := 0;
        WHILE number > 0 DO
            IF ODD number THEN result +:= 1 FI;
            number OVERAB 2
        OD;
        result
     END # population # ;

# as we are dealing with 32 bit numbers, the maximum possible population is 32 #
# so we only need a table of whether the integers 0 : 32 are prime or not      #
# we use the sieve of Eratosthenes...                                          #
INT max number = 32;
[ 0 : max number ]BOOL is prime;
is prime[ 0 ] := FALSE;
is prime[ 1 ] := FALSE;
FOR i FROM 2 TO max number DO is prime[ i ] := TRUE OD;
FOR i FROM 2 TO ENTIER sqrt( max number ) DO
    IF is prime[ i ] THEN FOR p FROM i * i BY i TO max number DO is prime[ p ] := FALSE OD FI
OD;

# returns TRUE if n is pernicious, FALSE otherwise                             #
PROC is pernicious = ( INT n )BOOL: is prime[ population( n ) ];

# find the first 25 pernicious numbers, 0 and 1 are not pernicious             #
INT pernicious count := 0;
FOR i FROM 2 WHILE pernicious count < 25 DO
    IF is pernicious( i ) THEN
        # found a pernicious number #
        print( ( whole( i, 0 ), " " ) );
        pernicious count +:= 1
    FI
OD;
print( ( newline ) );

# find the pernicious numbers between 888 888 877 and 888 888 888              #
FOR i FROM 888 888 877 TO 888 888 888 DO
    IF is pernicious( i ) THEN
        print( ( whole( i, 0 ), " " ) )
    FI
OD;
print( ( newline ) )
