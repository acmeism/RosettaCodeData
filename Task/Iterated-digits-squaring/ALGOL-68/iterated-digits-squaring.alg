# count the how many numbers up to 100 000 000 have squared digit sums of 89            #

# compute a table of the sum of the squared digits of the numbers 00 to 99              #
[ 0 : 99 ]INT    digit pair square sum;
FOR d1 FROM 0 TO 9 DO
    FOR d2 FROM 0 TO 9 DO
        digit pair square sum[ ( d1 * 10 ) + d2 ] := ( d1 * d1 ) + ( d2 * d2 )
    OD
OD;

# returns the sum of the squared digits of n                                            #
PROC squared digit sum = ( INT n )INT:
     BEGIN
         INT   result := 0;
         INT   rest   := n;
         WHILE rest /= 0 DO
             INT    digit pair = rest MOD 100;
             result PLUSAB digit pair square sum[ digit pair ];
             rest   OVERAB 100
         OD;
         result
     END # squared digit sum # ;

# for values up to 100 000 000, the largest squred digit sum will be that of 99 999 999 #
# i.e. 81 * 8 = 648, we will cache the values of the squared digit sums                 #
INT   cache max = 81 * 8;
[ 1 : cache max ]INT cache;
FOR i TO cache max DO cache[ i ] := 0 OD;

INT count 89 := 0;

# fill in the cache                                                                     #
FOR value FROM 2 TO cache max DO cache[ value ] := squared digit sum( value ) OD;
# we "know" that 89 and 1 are the terminal values                                       #
cache[  1 ] :=  1;
cache[ 89 ] := 89;
FOR value FROM 2 TO cache max DO
    INT sum := cache[ value ];
    WHILE sum /= 1 AND sum /= 89 DO
        sum := cache[ sum ]
    OD;
    cache[ value ] := sum
OD;

FOR value FROM 1 TO 100 000 000 DO
    IF cache[ squared digit sum( value ) ] = 89 THEN count 89 +:= 1 FI
OD;

print( ( "Number of values whose squared digit sum is 89: ", whole( count 89, -10 ), newline ) )
