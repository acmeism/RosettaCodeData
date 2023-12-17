BEGIN
    # find some cuban primes (using the definition: a prime p is a cuban prime if   #
    #                                                   p = n^3 - ( n - 1 )^3       #
    #                                                   for some n > 0)             #
    PR read "primes.incl.a68" PR                          # include prime utilities #
    # returns a string representation of n with commas                              #
    PROC commatise = ( LONG INT n )STRING:
         BEGIN
            STRING result      := "";
            STRING unformatted  = whole( n, 0 );
            INT    ch count    := 0;
            FOR c FROM UPB unformatted BY -1 TO LWB unformatted DO
                IF   ch count <= 2 THEN ch count +:= 1
                ELSE                    ch count  := 1; "," +=: result
                FI;
                unformatted[ c ] +=: result
            OD;
            result
         END # commatise # ;

    INT sieve max = 2 000 000;
    []BOOL sieve = PRIMESIEVE sieve max;            # sieve the primes to max sieve #

    # find the cuban primes                                                         #
    INT       cuban count   := 0;
    LONG INT  final cuban   := 0;
    INT       max cuban      = 100 000; # mximum number of cubans to find           #
    INT       print limit    =     200; # show all cubans up to this one            #
    print( ( "First ", commatise( print limit ), " cuban primes:", newline ) );
    LONG INT prev cube      := 1;
    FOR n FROM 2 WHILE
        LONG INT this cube   = ( LENG n * n ) * n;
        LONG INT p           = this cube - prev cube;
        prev cube           := this cube;
        IF ODD p THEN
            # 2 is not a cuban prime so we only test odd numbers                    #
            IF IF p <= UPB sieve THEN sieve[ SHORTEN p ] ELSE is probably prime( p ) FI
            THEN
                # have a cuban prime                                                #
                IF ( cuban count +:= 1 ) <= print limit THEN
                    # must show this cuban                                          #
                    STRING p formatted = commatise( p );
                    print( ( "          "[ UPB p formatted : ], p formatted ) );
                    IF cuban count MOD 10 = 0 THEN print( ( newline ) ) FI
                FI;
                final cuban := p
            FI
        FI;
        cuban count < max cuban
    DO SKIP OD;
    IF cuban count MOD 10 /= 0 THEN print( ( newline ) ) FI;
    print( ( "The ", commatise( max cuban ), " cuban prime is: ", commatise( final cuban ), newline ) )
END
