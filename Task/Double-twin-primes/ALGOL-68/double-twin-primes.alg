BEGIN # find some sequences of primes where the gaps between the elements #
      # are 2, 4, 2 - i.e., n, n+2, n+6 and n+8 are all prime             #
    PR read "primes.incl.a68" PR                # include prime utilities #
    []BOOL prime  = PRIMESIEVE 1 000;
    INT    count := 0;
    INT    p     := 3;        # 2 cannot be a twin prime, so start with 3 #
    WHILE p <= UPB prime - 8 DO
        BOOL is double twin := FALSE;
        IF prime[ p ] THEN
            IF prime[ p + 2 ] THEN
                IF prime[ p + 6 ] THEN
                    IF prime[ p + 8 ] THEN
                        count         +:= 1;
                        is double twin := TRUE;
                        print( ( "["
                               , whole( p,     -4 ), whole( p + 2, -4 )
                               , whole( p + 6, -4 ), whole( p + 8, -4 )
                               , " ]"
                               , newline
                               )
                             )
                    FI
                FI
            FI
        FI;
        p +:= IF is double twin THEN 6 ELSE 2 FI
    OD;
    print( ( "Found ", whole( count, 0 ), " double twin primes below ", whole( UPB prime, 0 ), newline ) )
END
