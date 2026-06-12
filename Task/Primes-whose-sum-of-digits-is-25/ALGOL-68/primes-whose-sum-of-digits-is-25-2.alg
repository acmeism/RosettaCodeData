BEGIN
    PROC pow mod = (LONG LONG INT b,in e, modulus)LONG LONG INT: (
      LONG LONG INT sq := b, e := in e;
      LONG LONG INT out:= IF ODD e THEN b ELSE 1 FI;
      e OVERAB 2;
      WHILE e /= 0 DO
        sq := sq * sq MOD modulus;
        IF ODD e THEN out := out * sq MOD modulus FI ;
        e OVERAB 2
      OD;
      out
    );
    INT p25 count := 0;
    PROC sum25 = ( LONG LONG INT p, INT rem )VOID:
         FOR i TO IF rem > 9 THEN 9 ELSE rem FI DO
            IF   rem > i THEN
                sum25( ( p * 10 ) + i, rem - i )
            ELIF ODD i AND i /= 5 THEN
                LONG LONG INT n = ( p * 10 ) + i;
                IF n MOD 3 /= 0 THEN
                    BOOL          is prime := TRUE;
                    # miller rabin primality test #
                    INT  k    = 10;
                    LONG LONG INT d := n - 1;
                    INT s := 0;
                    WHILE NOT ODD d DO
                        d OVERAB 2;
                        s +:= 1
                    OD;
                    TO k WHILE is prime DO
                        LONG LONG INT a := 2 + ENTIER (random*(n-3));
                        LONG LONG INT x := pow mod(a, d, n);
                        IF x /= 1 THEN
                            BOOL done := FALSE;
                            TO s WHILE NOT done DO
                                IF   x = n-1
                                THEN done := TRUE
                                ELSE x := x * x MOD n
                                FI
                            OD;
                            IF NOT done THEN IF x /= n-1 THEN is prime := FALSE FI FI
                        FI
                    OD;
                    # END miller rabin primality test #
                    IF is prime THEN
                        # IF ( p25 count + 1 ) MOD 100 = 0 THEN print( ( whole( p25 count + 1, -8 ), whole( n, -30 ), newline ) ) FI; #
                        p25 count +:= 1
                    FI
                FI
            FI
         OD;
    sum25( 0, 25 );
    print( ( "There are ", whole( p25 count, 0 ), " sum25 primes that contain no zeroes", newline ) )
END
