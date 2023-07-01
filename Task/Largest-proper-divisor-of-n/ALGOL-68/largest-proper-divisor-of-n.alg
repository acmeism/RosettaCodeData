FOR n TO 100 DO # show the largest proper divisors for n = 1..100 #
    INT largest proper divisor := 1;
    FOR j FROM ( n OVER 2 ) BY -1 TO 2 WHILE largest proper divisor = 1 DO
        IF n MOD j = 0 THEN
            largest proper divisor := j
        FI
    OD;
    print( ( whole( largest proper divisor, -3 ) ) );
    IF n MOD 10 = 0 THEN print( ( newline ) ) FI
OD
