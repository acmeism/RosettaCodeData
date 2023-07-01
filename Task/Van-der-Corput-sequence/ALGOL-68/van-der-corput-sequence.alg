BEGIN # show members of the van der Corput sequence in various bases         #
      # translated from the C sample                                         #

    # sets num and denom to the numerator and denominator of the nth member  #
    # of the van der Corput sequence in the specified base                   #
    PROC vc = ( INT nth, base,  REF INT num, denom )VOID:
         BEGIN
            INT p := 0, q := 1, n := nth;

            WHILE n /= 0 DO
                p    *:= base +:= n MOD base;
                q    *:= base;
                n OVERAB base
            OD;

            num   := p;
            denom := q;

            # reduce the numerrator and denominator by their gcd             #
            WHILE p /= 0 DO n := p; p := q MOD p; q := n OD;
            num   OVERAB q;
            denom OVERAB q
         END # vc # ;

    # task                                                                   #
    FOR b FROM 2 TO 5 DO
        print( ( "base ", whole( b, 0 ), ":" ) );
        FOR i FROM 0 TO 9 DO
            INT d, n;
            vc( i, b, n, d );
            IF n /= 0
            THEN print( ( "  ", whole( n, 0 ), "/", whole( d, 0 ) ) )
            ELSE print( ( "  0" ) )
            FI
        OD;
        print( ( newline ) )
    OD
END
