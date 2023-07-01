BEGIN # find some Chowla numbers ( Chowla n = sum of divisors of n exclusing n and 1 ) #
    # returs the Chowla number of n #
    PROC chowla = ( INT n )INT:
         BEGIN
             INT sum := 0;
             FOR i FROM 2 WHILE i * i <= n DO
                 IF n MOD i = 0 THEN
                     INT j = n OVER i;
                     sum +:= i + IF i = j THEN 0 ELSE j FI
                 FI
             OD;
             sum
         END # chowla # ;

    FOR n TO 37 DO print( ( "chowla(", whole( n, 0 ), ") = ", whole( chowla( n ), 0 ), newline ) ) OD;

    INT count := 0, power := 100;
    FOR n FROM 2 TO 10 000 000 DO
        IF chowla( n ) = 0 THEN count +:= 1 FI;
        IF n MOD power = 0 THEN
            print( ( "There are ", whole( count, 0 ), " primes < ", whole( power, 0 ), newline ) );
            power *:= 10
        FI
    OD;
    count := 0;
    INT limit = 350 000 000;
    INT k    := 2, kk := 3;
    WHILE INT p = k * kk;
          p <= limit
    DO
        IF chowla( p ) = p - 1 THEN
            print( ( whole( p, 0 ), " is a perfect number", newline ) );
            count +:= 1
        FI;
        k := kk + 1; kk +:= k
    OD;
    print( ( "There are ", whole( count, 0 ), " perfect numbers < ", whole( limit, 0 ), newline ) )
END
