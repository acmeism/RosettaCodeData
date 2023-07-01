# find some Kaprekar numbers                              #

# returns TRUE if n is a Kaprekar number, FALSE otherwise #
PROC is kaprekar = ( INT n )BOOL:
     IF n < 1 THEN
         # 0 and -ve numbers are not Kaprekar numbers     #
         FALSE
     ELIF n = 1 THEN
         # 1 is defined to be a Kaprekar number           #
         TRUE
     ELSE
         # n is a Kaprekar number if the digits of its    #
         # square can be partitioned into two numbers     #
         # that sum to n                                  #
         LONG INT  n squared     = LENG n * n;
         LONG INT  power of ten := 10;
         BOOL result            := FALSE;
         WHILE n squared > power of ten AND NOT result DO
             LONG INT left  = n squared OVER power of ten;
             LONG INT right = n squared  MOD power of ten;
             result := ( ( left + right ) = n AND right /= 0 );
             power of ten *:= 10
         OD;
         result
     FI # is kaprekar # ;


# count the number of Kaprekar numbers up to 1 000 000    #
# printing all those below 10 000                         #
INT max number           = 1 000 000;
INT k count             := 0;
[ 1 : 2 ]LONG INT split := ( 0, 0 );
print( ( "Kaprekar numbers below 10 000: ", newline ) );
FOR n TO max number DO
    IF is kaprekar( n ) THEN
        k count +:= 1;
        IF n < 10 000 THEN
            print( ( " ", whole( n, -4 ) ) )
        FI
    FI
OD;
print( ( newline ) );
print( ( "There are ", whole( k count, 0 ), " Kaprekar numbers below ", whole( max number, 0 ), newline ) )
