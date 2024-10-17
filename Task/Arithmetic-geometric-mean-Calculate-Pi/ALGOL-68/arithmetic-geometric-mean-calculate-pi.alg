BEGIN # calculate PI using the arithmetic-geometric mean                       #
      #                                      - translation of the Sidef sample #
      PR precision 120 PR  # set the precision of LONG LONG REAL for ALGOL 68G #
                             # this cannot be changed dynamically in ALGOL 68G #
    # the Sidef sample sets its precision to 4 * the number of digits required #
    #         however the result appears to be the same here with fewer digits #
    #            though ALGOL 68 Genie version 3 requires more than 100 digita #

    MODE BIGREAL  = LONG LONG REAL;
    MODE BIGINT   = LONG LONG INT;
    PROC(BIGREAL)BIGREAL big sqrt = long long sqrt;

    PROC agm pi = ( INT digits )BIGREAL:
         BEGIN
             BIGREAL an := 1;
             BIGREAL bn := big sqrt( 0.5 );
             BIGREAL tn := 0.5 ^ 2;
             BIGINT  pn := 1;

             WHILE pn < digits DO
                BIGREAL prev an := an;
                an       := ( bn + an ) / 2;
                bn       := big sqrt( bn * prev an );
                prev an -:= an;
                tn      -:= pn * ( prev an ^ 2 );
                pn      *:= 2
             OD;

             ( ( an + bn ) ^ 2 ) / ( 4 * tn )
         END # agm pi # ;

    print( ( fixed( agm pi( 100 ), 0, 99 ) ) )

END
