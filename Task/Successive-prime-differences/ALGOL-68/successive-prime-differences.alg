BEGIN # find some sequences of primes where the gaps between the elements #
      # follow specific patterns                                          #
    # reurns a list of primes up to n #
    PROC prime list = ( INT n )[]INT:
         BEGIN
            # sieve the primes to n #
            INT no = 0, yes = 1;
            [ 1 : n ]INT p;
            p[ 1 ] := no; p[ 2 ] := yes;
            FOR i FROM 3 BY 2 TO n DO p[ i ] := yes OD;
            FOR i FROM 4 BY 2 TO n DO p[ i ] := no  OD;
            FOR i FROM 3 BY 2 TO ENTIER sqrt( n ) DO
                IF p[ i ] = yes THEN FOR s FROM i * i BY i + i TO n DO p[ s ] := no OD FI
            OD;
            # replace the sieve with a list #
            INT p pos := 0;
            FOR i TO n DO IF p[ i ] = yes THEN p[ p pos +:= 1 ] := i FI OD;
            p[ 1 : p pos ]
         END # prime list # ;
    # prints the elements of list #
    PROC print list = ( STRING name, []INT list )VOID:
         BEGIN
            print( ( name, "[" ) );
            FOR i FROM LWB list TO UPB list DO print( ( " ", whole( list[ i ], 0 ) ) ) OD;
            print( ( " ]" ) )
         END # print list # ;
    # attempts to find patterns in the differences of primes and prints the results #
    PROC try differences = ( []INT primes, []INT pattern )VOID:
         BEGIN
            INT    pattern length = ( UPB pattern - LWB pattern ) + 1;
            [ 1 :  pattern length + 1 ]INT first; FOR i TO UPB first DO first[ i ] := 0 OD;
            [ 1 :  pattern length + 1 ]INT last;  FOR i TO UPB last  DO last[  i ] := 0 OD;
            INT    count := 0;
            FOR p FROM LWB primes + pattern length TO UPB primes DO
                BOOL matched := TRUE;
                INT e pos    := LWB pattern;
                FOR e FROM p - pattern length TO p - 1
                WHILE matched := primes[ e + 1 ] - primes[ e ] = pattern[ e pos ]
                DO
                    e pos +:= 1
                OD;
                IF matched THEN
                    # found a matching sequence #
                    count +:= 1;
                    last   := primes[ p - pattern length : p @ 1 ];
                    IF count = 1 THEN first := last FI
                FI
            OD;
            print( ( "  Found ", whole( count, 0 ), " prime sequence(s) that differ by: " ) );
            print list( "", pattern );
            print( ( newline ) );
            IF count > 0 THEN
                # found at least one sequence #
                print list( "    first: ", first );
                print list( "    last: ",  last  );
                print( ( newline ) )
            FI;
            print( ( newline ) )
         END # try differences # ;
    INT max number = 1 000 000;
    []INT    p list = prime list( max number );
    print( ( "For primes up to ", whole( max number, 0 ), "...", newline ) );
    try differences( p list, ( 2 )               );try differences( p list, ( 1 )               );
    try differences( p list, ( 2, 2 )            );try differences( p list, ( 2, 4 )            );
    try differences( p list, ( 4, 2 )            );try differences( p list, ( 6, 4, 2 )         );
    try differences( p list, ( 2, 4, 6, 8 )      );try differences( p list, ( 2, 4, 6, 8, 10 )  );
    try differences( p list, ( 32, 16, 8, 4, 2 ) )
END
