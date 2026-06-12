# show the sums of the first n cubes where 0 <= n < 50 #
FOR i FROM 0 TO 49 DO
    INT sum = ( i * ( i + 1 ) ) OVER 2;
    print( ( whole( sum * sum, -8 ) ) );
    IF i MOD 10 = 9 THEN print( ( newline ) ) FI
OD
