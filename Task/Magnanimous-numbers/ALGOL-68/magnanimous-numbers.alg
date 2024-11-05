BEGIN # find some magnanimous numbers - numbers where inserting a + between any #
      # digits ab=nd evaluating the sum results in a prime in all cases         #
    PR read "primes.incl.a68" PR                      # include prime utilities #
    # returns the first n magnanimous numbers                                   #
    #         uses global sieve prime which must include 0 and be large enough  #
    #         for all possible sub-sequences of digits                          #
    OP MAGNANIMOUS = ( INT n )[]INT:
       BEGIN
            [ 1 : n ]INT result;
            INT          m count := 0;
            FOR i FROM 0 WHILE m count < n DO
                # split the number into pairs of digit sequences #
                # and check the sums of the pairs are all prime #
                INT  divisor   := 10;
                BOOL all prime := TRUE;
                WHILE IF   INT front = i OVER divisor;
                           front = 0
                      THEN FALSE
                      ELSE all prime := prime[ front + ( i MOD divisor ) ]
                      FI
                DO
                    divisor *:= 10
                OD;
                IF all prime THEN result[ m count +:= 1 ] := i FI
            OD;
            result
       END; # MAGNANIMPUS #
    # prints part of a sequence of magnanimous numbers #
    PROC print magnanimous = ( []INT m, INT first, INT last, STRING legend )VOID:
         BEGIN
             print( ( legend, ":", newline ) );
             FOR i FROM first TO last DO print( ( " ", whole( m[ i ], 0 ) ) ) OD;
             print( ( newline ) )
         END ; # print magnanimous #
    # we assume the first 400 magnanimous numbers will be in 0 .. 1 000 000 #
    # so we will need a sieve of 0 up to 99 999 + 9 #
    []BOOL prime = PRIMESIEVE (  99 999 + 9 );
    # construct the sequence of magnanimous numbers #
    []INT mns = MAGNANIMOUS 400;
    print magnanimous( mns,   1,  45, "First 45 magnanimous numbers" );
    print magnanimous( mns, 241, 250, "Magnanimous numbers 241-250"  );
    print magnanimous( mns, 391, 400, "Magnanimous numbers 391-400"  )
END
