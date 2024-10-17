BEGIN # find sequences of primes where the gaps between the elements #
      # are strictly ascending/descending                            #
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
    # shos the results of a search #
    PROC show sequence = ( []INT primes, STRING seq name, INT seq start, seq length )VOID:
         BEGIN
            print( ( "    The longest sequence of primes with "
                   , seq name
                   , " differences contains "
                   , whole( seq length, 0 )
                   , " primes"
                   , newline
                   , "        First such sequence (differences in brackets):"
                   , newline
                   , "            "
                   )
                 );
            print( ( whole( primes[ seq start ], 0 ) ) );
            FOR p FROM seq start + 1 TO seq start + ( seq length - 1 ) DO
                print( ( " (", whole( ABS( primes[ p ] - primes[ p - 1 ] ), 0 ), ") " ) );
                print( ( whole( primes[ p ], 0 ) ) )
            OD;
            print( ( newline ) )
         END # show seuence # ;
    # find the longest sequence of primes where the successive differences are ascending/descending #
    PROC find sequence = ( []INT primes, BOOL ascending, REF INT seq start, seq length )VOID:
         BEGIN
            seq start     := seq length := 0;
            INT start diff = IF ascending THEN 0 ELSE UPB primes + 1 FI;
            FOR p FROM LWB primes TO UPB primes DO
                INT prev diff := start diff;
                INT length    := 1;
                FOR s FROM p + 1 TO UPB primes
                WHILE INT diff = ABS ( primes[ s ] - primes[ s - 1 ] );
                      IF ascending THEN diff > prev diff ELSE diff < prev diff FI
                DO
                    length   +:= 1;
                    prev diff := diff
                OD;
                IF length > seq length THEN
                    # found a longer sequence #
                    seq length := length;
                    seq start  := p
                FI
            OD
         END # find sequence #;
    BEGIN
        INT max number   = 1 000 000;
        []INT primes     = prime list( max number );
        INT asc length  := 0;
        INT asc start   := 0;
        INT desc length := 0;
        INT desc start  := 0;
        find sequence( primes, TRUE,   asc start,  asc length );
        find sequence( primes, FALSE, desc start, desc length );
        # show the sequences #
        print( ( "For primes up to ", whole( max number, 0 ), newline ) );
        show sequence( primes, "ascending",   asc start,  asc length );
        show sequence( primes, "descending", desc start, desc length )
    END
END
