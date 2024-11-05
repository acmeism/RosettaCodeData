BEGIN # find the lowest n distinct primes that sum to an integer x           #

    INT max number = 100 000;              # largest number we will consider #
    # sieve the primes to max number                                         #
    [ 1 : max number ]BOOL prime; FOR i TO UPB prime DO prime[ i ] := ODD i OD;
    prime[ 1 ] := FALSE;
    prime[ 2 ] := TRUE;
    FOR s FROM 3 BY 2 TO ENTIER sqrt( max number ) DO
        IF prime[ s ] THEN
            FOR p FROM s * s BY s TO UPB prime DO prime[ p ] := FALSE OD
        FI
    OD;

    [ 1 : 0 ]INT no partition;       # empty array - used if can't partition #

    # returns n partitioned into p primes or an empty array if n can't be    #
    #         partitioned into p primes, the first prime to try is in pstart #
    PROC partition from = ( INT n, p, pstart )[]INT:
         IF   p < 1 OR n < 2 OR pstart < 2 THEN         # invalid parameters #
            no partition
         ELIF p = 1 THEN          # partition into 1 prime - n must be prime #
            IF NOT prime[ n ] THEN no partition ELSE n FI
         ELIF p = 2 THEN                   # partition into a pair of primes #
            INT  half n = n OVER 2;
            INT  p1    := 0, p2 := 0;
            BOOL found := FALSE;
            FOR p pos FROM pstart TO UPB prime WHILE NOT found AND p pos < half n DO
                IF prime[ p pos ] THEN
                    p1    := p pos;
                    p2    := n - p pos;
                    found := prime[ p2 ]
                FI
            OD;
            IF NOT found THEN no partition ELSE ( p1, p2 ) FI
         ELSE                              # partition into 3 or more primes #
            [ 1 : p ]INT p2;
            INT  half n = n OVER 2;
            INT  p1    := 0;
            BOOL found := FALSE;
            FOR p pos FROM pstart TO UPB prime WHILE NOT found AND p pos < half n DO
                IF prime[ p pos ] THEN
                    p1    := p pos;
                    []INT sub partition = partition from( n - p1, p - 1, p pos + 1 );
                    IF found := UPB sub partition = p - 1 THEN
                        # have p - 1 primes summing to n - p1                #
                        p2[ 1 ]     := p1;
                        p2[ 2 : p ] := sub partition
                    FI
                FI
            OD;
            IF NOT found THEN no partition ELSE p2 FI
         FI # partition from # ;

    # returns the partition of n into p primes or an empty array if that is  #
    #         not possible                                                   #
    PROC partition = ( INT n, p )[]INT: partition from( n, p, 2 );

    # show the first partition of n into p primes, if that is possible       #
    PROC show partition = ( INT n, p )VOID:
         BEGIN
            []INT primes = partition( n, p );
            STRING partition info = whole( n, -6 ) + " with " + whole( p, -2 )
                                  + " prime" + IF p = 1 THEN " " ELSE "s" FI + ": ";
            IF UPB primes < LWB primes THEN
                print( ( "Partitioning ", partition info, "is not possible" ) )
            ELSE
                print( ( "Partitioned  ", partition info ) );
                print( ( whole( primes[ LWB primes ], 0 ) ) );
                FOR p pos FROM LWB primes + 1 TO UPB primes DO
                    print( ( "+", whole( primes[ p pos ], 0 ) ) )
                OD
            FI;
            print( ( newline ) )
         END # show partition # ;

    # test cases                                                             #
    show partition( 99809,  1 );
    show partition(    18,  2 );
    show partition(    19,  3 );
    show partition(    20,  4 );
    show partition(  2017, 24 );
    show partition( 22699,  1 );
    show partition( 22699,  2 );
    show partition( 22699,  3 );
    show partition( 22699,  4 );
    show partition( 40355,  3 )

END
