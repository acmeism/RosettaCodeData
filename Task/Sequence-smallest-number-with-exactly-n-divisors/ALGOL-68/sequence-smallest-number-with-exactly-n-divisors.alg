BEGIN

    PROC count divisors = ( INT n )INT:
         BEGIN
            INT count := 0;
            FOR i WHILE i*i <= n DO
                IF n MOD i = 0 THEN
                    count +:= IF i = n OVER i THEN 1 ELSE 2 FI
                FI
            OD;
            count
         END # count divisors # ;

    INT max = 15;
    [ max ]INT seq;FOR i TO max DO seq[ i ] := 0 OD;
    INT found := 0;
    FOR i WHILE found < max DO
        IF INT divisors = count divisors( i );
           divisors <= max
        THEN
            # have an i with an appropriate number of divisors                 #
            IF seq[ divisors ] = 0 THEN
                # this is the first i with that many divisors                  #
                seq[ divisors ] := i;
                found          +:= 1
            FI
        FI
    OD;
    print( ( "The first ", whole( max, 0 ), " terms of the sequence are:", newline ) );
    FOR i TO max DO
        print( ( whole( seq( i ), 0 ), " " ) )
    OD;
    print( ( newline ) )

END
