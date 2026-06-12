BEGIN # find the first 20 primes which are n + ( n + 1 ) for some n  #
    PR read "primes.incl.a68" PR           # include prime utilities #
    []BOOL prime = PRIMESIEVE 200;         # should be enough primes #
    INT p count := 0;
    FOR p FROM 3 BY 2 WHILE p count < 20 DO
        IF prime[ p ] THEN
            INT n  = p OVER 2;
            INT n1 = n + 1;
            p count +:= 1;
            print( ( whole( n, -2 ), " + ", whole( n1, -2 ), " = ", whole( p, -3 ), newline ) )
        FI
    OD
END
