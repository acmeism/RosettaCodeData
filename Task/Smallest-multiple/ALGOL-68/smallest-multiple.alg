BEGIN # find the smallest number that is divisible by each of the numbers 1..n #
      # translation of the Wren sample #
    PR precision 1000 PR # set the precision of LONG LONG INT #
    PR read "primes.incl.a68" PR
    # returns the lowest common multiple of the numbers 1 : n #
    PROC lcm = ( INT n )LONG LONG INT:
         BEGIN
            # sieve the primes to n #
            []BOOL prime = PRIMESIEVE n;
            LONG LONG INT result := 1;
            FOR p TO UPB prime DO
                IF prime[ p ] THEN
                    LONG LONG INT f := p;           # f will be set to the #
                    WHILE f * p <= n DO f *:= p OD; # highest multiple of p <= n #
                    result *:= f
                FI
            OD;
            result
         END # lcm # ;
    # returns a string representation of n with commas #
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
    print( ( "The LCMs of the numbers 1 to N inclusive is:", newline ) );
    []INT tests = ( 10, 20, 200, 2000 );
    FOR i FROM LWB tests TO UPB tests DO
        print( ( whole( tests[ i ], -5 ), ": ", commatise( lcm( tests[ i ] ) ), newline ) )
    OD
END
