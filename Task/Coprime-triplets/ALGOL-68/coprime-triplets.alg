BEGIN # find members of the coprime triplets sequence: starting from 1, 2 the #
      # subsequent members are the lowest number coprime to the previous two  #
      # that haven't appeared in the sequence yet                             #
    # iterative Greatest Common Divisor routine, returns the gcd of m and n   #
    PROC gcd = ( INT m, n )INT:
         BEGIN
            INT a := ABS m, b := ABS n;
            WHILE b /= 0 DO
                INT new a = b;
                b        := a MOD b;
                a        := new a
            OD;
            a
         END # gcd # ;
    # returns an array of the coprime triplets up to n                        #
    OP   COPRIMETRIPLETS = ( INT n )[]INT:
         BEGIN
            [ 1 : n ]INT result;
            IF n > 0 THEN
                result[ 1 ] := 1;
                IF n > 1 THEN
                    [ 1 : n ]BOOL used;
                    used[ 1 ] := used[ 2 ] := TRUE;
                    FOR i FROM 3 TO n DO used[ i ] := FALSE; result[ i ] := 0 OD;
                    result[ 2 ] := 2;
                    FOR i FROM 3 TO n DO
                        INT p1 = result[ i - 1 ];
                        INT p2 = result[ i - 2 ];
                        BOOL found := FALSE;
                        FOR j TO n WHILE NOT found DO
                            IF NOT used[ j ] THEN
                                found := gcd( p1, j ) = 1 AND gcd( p2, j ) = 1;
                                IF found THEN
                                    used[   j ] := TRUE;
                                    result[ i ] := j
                                FI
                            FI
                        OD
                    OD
                FI
            FI;
            result
         END # COPRIMETRIPLETS # ;
    []INT cps = COPRIMETRIPLETS 49;
    INT printed := 0;
    FOR i TO UPB cps DO
        IF cps[ i ] /= 0 THEN
            print( ( whole( cps[ i ], -3 ) ) );
            printed +:= 1;
            IF printed MOD 10 = 0 THEN print( ( newline ) ) FI
        FI
    OD;
    print( ( newline, "Found ", whole( printed, 0 ), " coprime triplets up to ", whole( UPB cps, 0 ), newline ) )
END
