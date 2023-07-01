BEGIN # find some Jacobsthal and related Numbers                             #
    INT max jacobsthal = 29;        # highest Jacobsthal number we will find #
    INT max oblong     = 20; # highest Jacobsthal oblong number we will find #
    INT max j prime    = 20;     # number of Jacobsthal prinmes we will find #
    PR precision 200 PR                 # set the precision of LONG LONG INT #
    PR read "primes.incl.a68" PR                   # include prime utilities #
    [ 0 : max jacobsthal ]LONG INT j;         # will hold Jacobsthal numbers #
    [ 0 : max jacobsthal ]LONG INT jl;  # will hold Jacobsthal-Lucas numbers #
    [ 1 : max oblong     ]LONG INT jo; # will hold Jacobsthal oblong numbers #
    # calculate the Jacobsthal Numbers and related numbers                   #
    # Jacobsthal      : J0  = 0, J1  = 1, Jn  = Jn-1  + 2 × Jn-2             #
    # Jacobsthal-Lucas: JL0 = 2, JL1 = 1, JLn = JLn-1 + 2 × JLn-2            #
    # Jacobsthal oblong: JOn = Jn x Jn-1                                     #
    j[ 0 ] := 0; j[ 1 ] := 1; jl[ 0 ] := 2; jl[ 1 ] := 1; jo[ 1 ] := 0;
    FOR n FROM 2 TO UPB j DO
        j[  n ] := j[  n - 1 ] + ( 2 * j[  n - 2 ] );
        jl[ n ] := jl[ n - 1 ] + ( 2 * jl[ n - 2 ] )
    OD;
    FOR n TO UPB jo DO
        jo[ n ] := j[ n ] * j[ n - 1 ]
    OD;
    # prints an array of numbers with the specified legend                   #
    PROC show numbers = ( STRING legend, []LONG INT numbers )VOID:
         BEGIN
            INT n count := 0;
            print( ( "First ", whole( ( UPB numbers - LWB numbers ) + 1, 0 ), " ", legend, newline ) );
            FOR n FROM LWB numbers TO UPB numbers DO
                print( ( " ", whole( numbers[ n ], -11 ) ) );
                IF ( n count +:= 1 ) MOD 5 = 0 THEN print( ( newline ) ) FI
            OD
         END # show numbers # ;
    # show the various numbers numbers                                       #
    show numbers( "Jacobsthal Numbers:",        j  );
    show numbers( "Jacobsthal-Lucas Numbers:",  jl );
    show numbers( "Jacobsthal oblong Numbers:", jo );
    # find some prime Jacobsthal numbers                                     #
    LONG LONG INT  jn1 := j[ 1 ], jn2 := j[ 0 ];
    INT  p count := 0;
    print( ( "First ", whole( max j prime, 0 ), " Jacobstal primes:", newline ) );
    print( ( "   n  Jn", newline ) );
    FOR n FROM 2 WHILE p count < max j prime DO
        LONG LONG INT jn = jn1 + ( 2 * jn2 );
        jn2        := jn1;
        jn1        := jn;
        IF is probably prime( jn ) THEN
            # have a probably prime Jacobsthal number                        #
            p count +:= 1;
            print( ( whole( n, -4 ), ": ", whole( jn, 0 ), newline ) )
        FI
    OD
END
