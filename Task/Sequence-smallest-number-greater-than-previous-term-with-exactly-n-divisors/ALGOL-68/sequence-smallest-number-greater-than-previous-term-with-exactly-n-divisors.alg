BEGIN

    PROC count divisors = ( INT n )INT:
         BEGIN
            INT i2, count := 0;
            FOR i WHILE ( i2 := i * i ) < n DO
                IF n MOD i = 0 THEN count +:= 2 FI
            OD;
            IF i2 = n THEN count + 1 ELSE count FI
         END # count divisors # ;

    INT max = 15;

    print( ( "The first ", whole( max, 0 ), " terms of the sequence are:" ) );
    INT next := 1;
    FOR i WHILE next <= max DO
        IF next = count divisors( i ) THEN
            print( ( " ", whole( i, 0 ) ) );
            next +:= 1
        FI
    OD

END
