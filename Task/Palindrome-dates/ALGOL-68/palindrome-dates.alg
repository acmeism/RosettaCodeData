BEGIN # print future palindromic dates                                           #
    # a palindromic date must be of the form demn-nm-ed                          #
    # returns a string representation of n with at least 2 digits                #
    PROC two digits = ( INT n )STRING:
         BEGIN
             STRING result := whole( ABS n, 0 );
             IF ( UPB result - LWB result ) + 1 < 2 THEN "0" +=: result FI;
             IF n < 0 THEN "-" +=: result FI;
             result
         END # two digits # ;
    # possible years for a palindromic date                                      #
    []INT mn     = (  1, 10, 11, 20, 21, 30, 40, 50, 60, 70, 80, 90 );
    # months corresponding to the year for for a palindromic date                #
    []INT nm     = ( 10,  1, 11,  2, 12,  3,  4,  5,  6,  7,  8,  9 );
    # possible centuaries for a palindromic date                                 #
    []INT de     = ( 10, 11, 12, 13, 20, 21, 22, 30, 31, 32, 40, 41, 42, 50
                   , 51, 52, 60, 61, 62, 70, 71, 72, 80, 81, 82, 90, 91, 92
                   );
    # days corresponding to the centuary for a palindromic date                  #
    []INT ed     = (  1, 11, 21, 31,  2, 12, 22,  3, 13, 23,  4, 14, 24,  5
                   , 15, 25,  6, 16, 26,  7, 17, 27,  8, 18, 28,  9, 19, 29
                   );
    # max days per month ( february handled specifically in code )               #
    []INT max dd = ( 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 );
    # current date in local time (Algol 68G extension)                           #
    []INT date   = local time;
    INT   yy now = local time[ 1 ] MOD  100;
    INT   cc now = local time[ 1 ] OVER 100;
    INT dates to print := 15; # maximum number of dates to print                 #
    FOR c pos FROM LWB de TO UPB de WHILE dates to print > 0 DO
        INT cc = de[ c pos ];
        INT dd = ed[ c pos ];
        FOR y pos FROM LWB nm TO UPB nm WHILE dates to print > 0 DO
            INT mm = nm[ y pos ];
            INT yy = mn[ y pos ];
            IF cc > cc now OR ( cc = cc now AND yy > yy now ) THEN
                # have a possible future date                                    #
                IF dd <= max dd[ mm ]
                OR ( mm = 2 AND dd = 29 AND yy MOD 4 = 0 )
                THEN
                    # have a valid future date                                   #
                    # no need to test yy = 0 as dd = 0 is impossible             #
                    dates to print -:= 1;
                    print( ( two digits( cc )
                           , two digits( yy )
                           , "-"
                           , two digits( mm )
                           , "-"
                           , two digits( dd )
                           , newline
                           )
                         )
                FI
            FI
        OD
    OD
END
