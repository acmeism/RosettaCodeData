# find some narcissistic decimal numbers                                      #

# returns TRUE if n is narcissitic, FALSE otherwise; n should be >= 0         #
PROC is narcissistic = ( INT n )BOOL:
     BEGIN
        # count the number of digits in n                                     #
        INT digits := 0;
        INT number := n;
        WHILE digits +:= 1;
              number OVERAB 10;
              number > 0
        DO SKIP OD;
        # sum the digits'th powers of the digits of n                         #
        INT sum := 0;
        number  := n;
        TO digits DO
            sum +:= ( number MOD 10 ) ^ digits;
            number OVERAB 10
        OD;
        # n is narcissistic if n = sum                                        #
        n = sum
     END # is narcissistic # ;

# print the first 25 narcissistic numbers                                     #
INT count := 0;
FOR n FROM 0 WHILE count < 25 DO
    IF is narcissistic( n ) THEN
        # found another narcissistic number                                   #
        print( ( " ", whole( n, 0 ) ) );
        count +:= 1
    FI
OD;
print( ( newline ) )
