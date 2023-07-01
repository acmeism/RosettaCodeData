BEGIN # find some Motzkin numbers #
    PR read "primes.incl.a68" PR
    # returns a table of the Motzkin numbers 0 .. n #
    OP   MOTZKIN = ( INT n )[]LONG LONG INT:
         BEGIN
            [ 0 : n ]LONG LONG INT m;
            IF n >= 0 THEN
                m[ 0 ] := 1;
                IF n >= 1 THEN
                    m[ 1 ] := 1;
                    FOR i FROM 2 TO UPB m DO
                        m[ i ] := ( ( m[ i - 1 ] * ( ( 2 * i ) + 1  ) )
                                  + ( m[ i - 2 ] * ( ( 3 * i ) - 3  ) )
                                  )
                             OVER ( i + 2 )
                    OD
                FI
            FI;
            m
         END # MOTZKIN # ;
    # returns a string representation of n with commas                       #
    PROC commatise = ( LONG LONG INT n )STRING:
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
         END; # commatise #
    # left-pads a string to at least n characters                            #
    PROC pad left = ( STRING s, INT n )STRING:
         IF INT len = ( UPB s - LWB s ) + 1; len >= n THEN s ELSE ( ( n - len ) * " " ) + s FI;

    # show the Motzkin numbers #
    print( ( " n                      M[n] Prime?", newline ) );
    print( ( "-----------------------------------", newline ) );
    []LONG LONG INT m = MOTZKIN 41;
    FOR i FROM LWB m TO UPB m DO
        print( ( whole( i, -2 )
               , pad left( commatise( m[ i ] ), 26 )
               , IF is probably prime( m[ i ] ) THEN "  prime" ELSE "" FI
               , newline
               )
             )
    OD
END
