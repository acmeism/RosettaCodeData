BEGIN # find Achilles Numbers: numbers whose prime factors p appear at least  #
      # twice (i.e. if p is a prime factor, so is p^2) and cannot be          #
      # expressed as m^k for any integer m, k > 1                             #
      # also find strong Achilles Numbers: Achilles Numbers where the Euler's #
      # totient of the number is also Achilles                                #
    # returns the number of integers k where 1 <= k <= n that are mutually    #
    #         prime to n                                                      #
    PROC totient = ( INT n )INT:        # algorithm from the second Go sample #
        IF   n < 3 THEN 1               #        in the Totient Function task #
        ELIF n = 3 THEN 2
        ELSE
            INT result := n;
            INT v      := n;
            INT i      := 2;
            WHILE i * i <= v DO
                IF v MOD i = 0 THEN
                    WHILE v MOD i = 0 DO v OVERAB i OD;
                    result -:= result OVER i
                FI;
                IF i = 2 THEN
                   i := 1
                FI;
                i +:= 2
            OD;
            IF v > 1 THEN result -:= result OVER v FI;
            result
         FI # totient # ;
    # find the numbers                                                        #
    INT max number = 1 000 000;                 # max number we will consider #
    PR read "primes.incl.a68" PR                #     include prime utilities #
    []BOOL prime = PRIMESIEVE max number;       # construct a sieve of primes #
    # table of numbers, will be set to TRUE for the Achilles Numbers          #
    [ 1 : max number ]BOOL achiles;
    FOR a TO UPB achiles DO
        achiles[ a ] := TRUE
    OD;
    # remove the numbers that don't have squared primes as factors            #
    achiles[ 1 ] := FALSE;
    FOR a TO UPB achiles DO
        IF prime[ a ] THEN
            # have a prime, remove it and every multiple of it that isn't a   #
            # multiple of a squared                                           #
            INT a count := 0;
            FOR j FROM a BY a TO UPB achiles DO
                a count +:= 1;
                IF a count = a THEN # have a multiple of i^2, keep the number #
                    a count := 0
                ELSE               # not a multiple of i^2, remove the number #
                    achiles[ j ] := FALSE
                FI
            OD
        FI
    OD;
    # achiles now has TRUE for the powerful numbers, remove all m^k (m,k > 1) #
    FOR m FROM 2 TO UPB achiles DO
        INT mk    := m;
        INT max mk = UPB achiles OVER m;    # avoid overflow if INT is 32 bit #
        WHILE mk <= max mk DO
            mk           *:= m;
            achiles[ mk ] := FALSE
        OD
    OD;
    # achiles now has TRUE for imperfect powerful numbers                     #
    # show the first 50 Achilles Numbers                                      #
    BEGIN
        print( ( "First 50 Achilles Numbers:", newline ) );
        INT a count := 0;
        FOR a WHILE a count < 50 DO
            IF achiles[ a ] THEN
                a count +:= 1;
                print( ( " ", whole( a, -6 ) ) );
                IF a count MOD 10 = 0 THEN
                    print( ( newline ) )
                FI
            FI
        OD
    END;
    # show the first 50 Strong Achilles numbers                               #
    BEGIN
        print( ( "First 20 Strong Achilles Numbers:", newline ) );
        INT s count := 0;
        FOR s WHILE s count < 20 DO
            IF achiles[ s ] THEN
                IF achiles[ totient( s ) ] THEN
                    s count +:= 1;
                    print( ( " ", whole( s, -6 ) ) );
                    IF s count MOD 10 = 0 THEN
                        print( ( newline ) )
                    FI
                FI
            FI
        OD
    END;
    # count the number of Achilles Numbers by their digit counts              #
    BEGIN
        INT a count     :=   0;
        INT power of 10 := 100;
        INT digit count :=   2;
        FOR a TO UPB achiles DO
            IF achiles[ a ] THEN
                # have an Achilles Number                                     #
                a count +:= 1
            FI;
            IF a = power of 10 THEN
                # have reached a power of 10                                  #
                print( ( "Achilles Numbers with ", whole( digit count, 0 )
                       , " digits: ",             whole( a count,    -6 )
                       , newline
                       )
                     );
                digit count +:=  1;
                power of 10 *:= 10;
                a count      :=  0
            FI
        OD
    END
END
