BEGIN # Primes - allocate descendants to their ancestors                     #
      #        - based on the EasyLang sample                                #

    PR read "primes.incl.a68" PR                   # include prime utilities #
    PR read   "sort.incl.a68" PR                    # include sort utilities #
    PR read   "rows.incl.a68" PR             # include row (array) utilities #

    INT max number    =      99;           # maximum number we will consider #
    INT max desc      = 600 000;     # maximum number of descendants handled #
    INT max ancestors =      10;     # maximum number of   ancestors handled #

    []BOOL prime = PRIMESIEVE max number;   # sieve the primes to max number #

    MODE INTEGER = LONG INT;                # needs to be big enough to hold #
                                            #      descendants and ancestors #
    # table of ancestors - a count[ n ] holds the number of ancestors of n   #
    [ 1 : max number, 1 : max ancestors ]INTEGER ancestors;
    [ 1 : max number                    ]INT     a count;
    FOR n FROM 1 LWB ancestors TO 1 UPB ancestors DO
        a count[ n ] := 0;
        FOR a FROM 2 LWB ancestors TO 2 UPB ancestors DO
            ancestors[ n, a ] := 0
        OD
    OD;

    # table of descentdants, d first[ n ] holds the index of the latest      #
    # descendant of n, prev descendant[ x ] holds the index of the previous  #
    # descendant ( 0 indicates no previous descendant )                      #
    [ 1 : max desc   ]INTEGER descendant, sorted descendants;
    [ 1 : max desc   ]INT     prev descendant;
    [ 1 : max number ]INT     d first;
    FOR n FROM LWB d first TO UPB d first DO d first[ n ] := 0 OD;
    FOR n FROM LWB descendant TO UPB descendant DO
        descendant[ n ] := sorted descendants[ n ] := prev descendant[ n ] := 0
    OD;
    INT next d := 1;      # next free element in descendant, prev descendant #

    # adds a as an ancestor for d                                            #
    PROC add ancestor = ( INT d, INTEGER a )VOID:
         ancestors[ d, a count[ d ] +:= 1 ] := a;

    # adds d to the descendants of n                                         #
    PROC add descendant = ( INT n, INTEGER d )VOID:
         BEGIN
            INT n prev                           := d first[ n ];
            descendant[ d first[ n ] := next d ] := d;
            prev descendant[            next d ] := n prev;
            next d                              +:= 1
         END # add descendant # ;

    # find the descendants                                                   #
    FOR p FROM LWB prime TO UPB prime DO
        IF prime[ p ] THEN
            add descendant( p, p );
            FOR s FROM LWB d first TO UPB d first - p DO
                INT s pos := d first[ s ];
                WHILE s pos > 0 DO
                    INTEGER ps = descendant[ s pos ];
                    add descendant( s + p, p * ps );
                    s pos := prev descendant[ s pos ]
                OD
            OD
        FI
    OD;

    # find the ancestors and show some descendants and ancestors             #
    INT next to show := 10;
    INT total        :=  0;
    FOR s FROM LWB d first TO UPB d first DO
        # get a sorted list of the descendants of s, exclude s if present    #
        INT s pos := 0;
        INT d pos := d first[ s ];
        WHILE d pos /= 0 DO
            IF descendant[ d pos ] /= s THEN
                sorted descendants[ s pos +:= 1 ] := descendant[ d pos ]
            FI;
            d pos := prev descendant[ d pos ]
        OD;
        sorted descendants QUICKSORT ELEMENTS( 1, s pos );
        total +:= s pos;
        FOR d TO s pos DO
            IF sorted descendants[ d ] <= max number THEN
                FOR p TO a count[ s ] DO
                    add ancestor( SHORTEN sorted descendants[ d ]
                                , ancestors[ s, p ]
                                )
                OD;
                add ancestor( SHORTEN sorted descendants[ d ], s )
            FI
        OD;
        IF s = next to show THEN
            print( ( "-- ", whole( s, 0 ), " --", newline ) );
            print( ( whole( acount[ s ], -6 ), " Ancestors  : [" ) );
            SHOW ancestors[ s, 1 : acount[ s ] ];
            print( ( " ]", newline, whole( s pos, -6 ), " Descendants: [" ) );
            IF s pos < 10 THEN
                SHOW sorted descendants[ 1 : s pos ]
            ELSE
                print( ( " ",     whole( sorted descendants[     1 ], 0 ) ) );
                print( ( " ",     whole( sorted descendants[     2 ], 0 ) ) );
                print( ( " ... ", whole( sorted descendants[ s pos ], 0 ) ) )
            FI;
            print( ( " ]", newline, newline ) );
            next to show := IF next to show = 10 THEN 46 ELSE max number FI
        FI
    OD;
    print( ( whole( total, 0 ), " total descendants", newline ) )
END
