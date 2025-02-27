BEGIN # find some of Chernick's Carmichael numbers - translation of Go       #

    PR precision 80 PR                  # set the precision of LONG LONG INT #
    PR read "primes.incl.a68" PR                   # include prime utilities #

    # integer mode large enough to hold a Chernick's Carmichael number       #
    MODE CHERNICKINTEGER = LONG LONG INT;
    # integer mode large to hold a factor of a Chernick's Carmichael number  #
    MODE CHERNICKFACTOR  = LONG INT;

    # returns the value of the Chernick's Carmichaal number U( n, m )        #
    #      or 0 if n and m are not a Chernicj's Carmichael number            #
    PROC possible chernick = ( INT n, m )CHERNICKINTEGER:
         IF   CHERNICKINTEGER prod := 6 * m + 1;
              NOT  is probably prime( prod )
         THEN 0
         ELIF CHERNICKFACTOR f := 12 * m + 1;
              NOT  is probably prime( f )
         THEN 0
         ELSE CHERNICKFACTOR t := 9 * m;
              prod *:= f;
              f     := t;
              BOOL result := TRUE;
              CHERNICKINTEGER ii := 1;
              WHILE IF   ii > n - 2
                    THEN FALSE
                    ELSE f      := ( t +:= t ) + 1;
                         result := is probably prime( f )
                    FI
              DO    ii   +:= 1;
                    prod *:= f
              OD;
              IF result THEN prod ELSE 0 FI
         FI # possible chernick # ;

    BEGIN
        FOR n FROM 3 TO 9 DO
            INT m := IF n > 4 THEN 2 ^ ( n - 4 ) ELSE 1 FI;
            WHILE IF   CHERNICKINTEGER cn = possible chernick( n, m );
                       cn > 0
                  THEN print( ( "U( ",   whole(  n,  0 ) ) );
                       print( ( ", "  ,  whole(  m, -8 ) ) );
                       print( ( " ): ",  whole( cn,  0 ), newline ) );
                       FALSE
                  ELSE m +:= IF n <= 4 THEN 1 ELSE 2 ^ ( n - 4 ) FI;
                       TRUE
                  FI
            DO SKIP OD
        OD
    END
END
