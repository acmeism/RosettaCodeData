BEGIN # find twin primes whose sum is a square, i.e.:                        #
      # find primes p such that p + 2 is prime and p + p + 2 is a square     #

    REAL start cpu = cpu time;

    INT max prime = ( max int OVER 2 ) - 2;     # maximum possible prime to consider #
    PR read "primes.incl.a68" PR

    PROC print pair = ( INT pp count, INT p1, INT x, x2 )VOID:
         BEGIN
            STRING twin sum = whole( p1, -18 ) + " + " + whole( p1 + 2, 0 );
            INT    twin len = ( UPB twin sum - LWB twin sum ) + 1;
            print( ( whole( pp count, -8 ), twin sum, " " * ( 40 - twin len ), " = " ) );
            print( ( whole( x, -18 ), "^2 = ", whole( x2, 0 ) ) );
            IF count >= 100 THEN
                print( ( " ", fixed( cpu time - start cpu, -12, 4 ), " seconds" ) )
            FI;
            print( ( newline ) )
        END # print pair # ;

    # if p is a twin prime then we want p where 2p + 2 = x^2 for some x      #
    # x must be even                                                         #
    INT count   := 0, last x2 := 0, last p := 0;
    INT max root = ENTIER sqrt( ( 2 * max prime ) + 2 );
    FOR x FROM 2 BY 2 TO IF max root <= 1 000 000 THEN max root ELSE 1 000 000 FI DO
        INT x2 := x * x;
        INT p  := ( x2 - 2 ) OVER 2;
        IF is probably prime( p ) THEN
            IF is probably prime( p + 2 ) THEN
                count  +:= 1;
                last x2 := x2;
                last p  := p;
                IF count MOD 1000 = 0 THEN
                    print pair( count, p, x, x2 )
                FI
            FI
        FI
    OD;
    print pair( count, last p, ENTIER sqrt( last x2 ), last x2 )

END
