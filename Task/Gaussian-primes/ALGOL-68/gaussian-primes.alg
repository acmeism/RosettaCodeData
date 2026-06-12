BEGIN # find and plot Gaussian primes: complex numbers with integer real and #
      # imaginary parts where:                                               #
      #     either the real and imaginary parts are non 0 and the norm       #
      #            (sum of squares of the real and imaginary parts) is prime #
      #         or one of the real/imaginary parts is zero and the other is  #
      #            +/- a prime of the form 4n + 3                            #

    PR read "primes.incl.a68" PR                   # include prime utilities #
    []BOOL primes = PRIMESIEVE 10 000;          # sieve the primes to 10 000 #

    # applies gp to the Gaussian primes with within radius of 0+0i           #
    PROC process gaussian primes = ( INT radius, PROC(INT,INT)VOID gp )VOID:
         BEGIN
            INT r2 = radius * radius;
            FOR rp FROM - radius TO radius DO
                FOR ip FROM - radius TO radius DO
                    IF  INT norm = ( rp * rp ) + ( ip * ip );
                        norm < r2
                    THEN
                        IF rp /= 0 AND ip /= 0 THEN
                            IF primes[ norm ] THEN gp( rp, ip ) FI
                        ELIF rp /= 0 OR ip /= 0 THEN
                            IF   INT abs sum parts = ABS ( rp + ip );
                                 primes[ abs sum parts ]
                             AND ( abs sum parts - 3 ) MOD 4 = 0
                            THEN
                                gp( rp, ip )
                            FI
                        FI
                    FI
                OD
            OD
         END  # process gaussian primes # ;

    # show Gaussian primes within a radius (root of the norm) of 10 of 0+0i  #
    INT gp count := 0;
    process gaussian primes( 10
                           , ( INT rp, ip )VOID:
                             BEGIN
                                 print( ( " "
                                        , IF rp > 0 THEN " " ELSE "-" FI, whole( ABS rp, 0 )
                                        , IF ip < 0 THEN "-" ELSE "+" FI, whole( ABS ip, 0 )
                                        , "i"
                                        )
                                      ),
                                  IF ( gp count +:= 1 ) MOD 12 = 0 THEN print( ( newline ) ) FI
                             END
                           );
    # plot the Gaussian primes within a radius of 50 of the origin (0+0i)    #
    [ -50 : 50, -50 : 50 ]CHAR plot;
    FOR i FROM 1 LWB plot TO 1 UPB plot DO
        FOR j FROM 2 LWB plot TO 2 UPB plot DO
            plot[ i, j ] := IF i = 0 THEN "-" ELSE " " FI
        OD;
        plot[ i, 0 ] := "|"
    OD;
    plot[ 0, 0 ] := "+";
    process gaussian primes( 50, ( INT rp, ip )VOID: plot[ rp, ip ] := "*" );
    print( ( newline, newline ) );
    FOR i FROM 1 LWB plot TO 1 UPB plot DO
        FOR j FROM 2 LWB plot TO 2 UPB plot DO
            print( ( " ", plot[ i, j ] ) )
        OD;
        print( ( newline ) )
    OD
END
