# returns TRUE if n is semi-prime, FALSE otherwise            #
#         n is semi prime if it has exactly two prime factors #
PROC is semiprime = ( INT n )BOOL:
     BEGIN
         # We only need to consider factors between 2 and     #
         # sqrt( n ) inclusive. If there is only one of these #
         # then it must be a prime factor and so the number   #
         # is semi prime                                      #
         INT factor count := 0;
         FOR factor FROM 2 TO ENTIER sqrt( ABS n )
         WHILE IF n MOD factor = 0 THEN
                   factor count +:= 1;
                   # check the factor isn't a repeated factor #
                   IF n /= factor * factor THEN
                       # the factor isn't the square root     #
                       INT other factor = n OVER factor;
                       IF other factor MOD factor = 0 THEN
                           # have a repeated factor           #
                           factor count +:= 1
                       FI
                   FI
               FI;
               factor count < 2
         DO SKIP OD;
         factor count = 1
     END # is semiprime # ;

# determine the first few semi primes                          #
print( ( "semi primes below 100: " ) );
FOR i TO 99 DO
    IF is semi prime( i ) THEN print( ( whole( i, 0 ), " " ) ) FI
OD;
print( ( newline ) );
print( ( "semi primes below between 1670 and 1690: " ) );
FOR i FROM 1670 TO 1690 DO
    IF is semi prime( i ) THEN print( ( whole( i, 0 ), " " ) ) FI
OD;
print( ( newline ) )
