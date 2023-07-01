# returns the population count (number of bits on) of the non-negative       #
# integer n                                                                  #
PROC population count = ( LONG INT n )INT:
     BEGIN
        LONG INT number := n;
        INT      result := 0;
        WHILE number > 0 DO
            IF ODD number THEN result +:= 1 FI;
            number OVERAB 2
        OD;
        result
     END # population # ;

# population count of 3^0, 3^1, 3*2, ..., 3^29                               #
LONG INT  power of three := 1;
print( ( "3^x pop counts:" ) );
FOR power FROM 0 TO 29 DO
    print( ( " ", whole( population count( power of three ), 0 ) ) );
    power of three *:= 3
OD;
print( ( newline ) );
# print the first thirty evil numbers (even population count)                #
INT evil count := 0;
print( ( "evil numbers  :" ) );
FOR n FROM 0 WHILE evil count < 30 DO
    IF NOT ODD population count( n ) THEN
        print( ( " ", whole( n, 0 ) ) );
        evil count +:= 1
    FI
OD;
print( ( newline ) );
# print the first thirty odious numbers (odd population count)               #
INT odious count := 0;
print( ( "odious numbers:" ) );
FOR n WHILE odious count < 30 DO
    IF ODD population count( n ) THEN
        print( ( " ", whole( n, 0 ) ) );
        odious count +:= 1
    FI
OD;
print( ( newline ) )
