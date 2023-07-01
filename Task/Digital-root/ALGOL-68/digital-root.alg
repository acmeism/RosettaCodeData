# calculates the digital root and persistance of n #
PROC digital root = ( LONG LONG INT n, REF INT root, persistance )VOID:
     BEGIN
         LONG LONG INT number := ABS n;
         persistance := 0;
         WHILE persistance PLUSAB 1;
               LONG LONG INT digit sum := 0;
               WHILE number > 0
               DO
                   digit sum PLUSAB number MOD 10;
                   number    OVERAB 10
               OD;
               number := digit sum;
               number > 9
         DO
               SKIP
         OD;
         root := SHORTEN SHORTEN number
     END; # digital root #

# calculates and prints the digital root and persistace of number #
PROC print digital root and persistance = ( LONG LONG INT number )VOID:
     BEGIN
         INT    root, persistance;
         digital root( number, root, persistance );
         print( ( whole( number, -15 ), " root: ", whole( root, 0 ), " persistance: ", whole( persistance, -3 ), newline ) )
     END; # print digital root and persistance #

# test the digital root proc #
BEGIN print digital root and persistance(       627615 )
    ; print digital root and persistance(        39390 )
    ; print digital root and persistance(       588225 )
    ; print digital root and persistance( 393900588225 )
END
