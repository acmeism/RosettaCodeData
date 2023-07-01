BEGIN
    # Solve the McNuggets problem: find the largest n <= 100 for which there #
    # are no non-negative integers x, y, z such that 6x + 9y + 20z = n       #
    INT max nuggets = 100;
    [ 0 : max nuggets ]BOOL sum;
    FOR i FROM LWB sum TO UPB sum DO sum[ i ] := FALSE OD;
    FOR x FROM 0 BY 6 TO max nuggets DO
        FOR y FROM x BY 9 TO max nuggets DO
            FOR z FROM y BY 20 TO max nuggets DO
                sum[ z ] := TRUE
            OD # z #
        OD # y #
    OD # x # ;
    # show the highest number that cannot be formed                          #
    INT largest := -1;
    FOR i FROM UPB sum BY -1 TO LWB sum WHILE sum[ largest := i ] DO SKIP OD;
    print( ( "The largest non McNugget number is: "
           , whole( largest, 0 )
           , newline
           )
         )
END
