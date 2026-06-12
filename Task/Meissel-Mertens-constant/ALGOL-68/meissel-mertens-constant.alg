BEGIN # compute an approximation to the Meissel-Mertens constant             #
    # construct a sieve of odd primes                                        #
    [ 0 : 10 000 000 ]BOOL primes;
    BEGIN
        FOR i TO UPB primes DO primes[ i ] := TRUE  OD;
        INT ip := 1;
        FOR i WHILE i + ( ip +:= 2 ) <= UPB primes DO
            IF primes[ i ] THEN
                FOR s FROM i + ip BY ip TO UPB primes DO primes[ s ] := FALSE OD
            FI
        OD
    END;
    # sum the reciprocals of the primes                                      #
    INT       p count := 1;
    INT       last p  := 0;
    LONG REAL sum     := long ln( 0.5 ) + 0.5;
    INT       p       := 1;
    INT       p10     := 10;
    # Euler's constant from the wikipedia, truncated for LONG REAL           #
    LONG REAL eulers constant = 0.5772156649015328606 # 0651209008240243104215933593992 #;
    FOR i TO UPB primes DO
        p +:= 2;
        IF primes[ i ] THEN
            LONG REAL rp = 1 / LENG p;
            sum     +:= long ln( 1 - rp ) + rp;
            p count +:= 1;
            last p   := p;
            IF p count = p10 THEN
                print( ( "after ", whole( p count, -8 ), " primes, the approximation is: "
                       , fixed( sum + eulers constant, -14, 12 )
                       , ", last prime considered: ", whole( last p, 0 )
                       , newline
                       )
                     );
                p10 := IF p10 < 1 000 000 THEN p10 * 10 ELSE p10 + 1 000 000 FI
            FI
        FI
    OD;
    print( ( "after ", whole( p count, -8 ), " primes, the approximation is: "
           , fixed( sum + eulers constant, -14, 12 )
           , ", last prime considered: ", whole( last p, 0 )
           , newline
           )
         )
END
