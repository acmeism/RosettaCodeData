# Find all Munchausen numbers - note 11*(9^9) has only 10 digits so there are no    #
# Munchausen numbers with 11+ digits                                                #
# table of Nth powers - note 0^0 is 0 for Munchausen numbers, not 1                 #
[]INT nth power = ([]INT( 0, 1, 2 ^ 2, 3 ^ 3, 4 ^ 4, 5 ^ 5, 6 ^ 6, 7 ^ 7, 8 ^ 8, 9 ^ 9 ) )[ AT 0 ];

[       ]INT z count  = []INT( ( 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ) )[ AT 0 ];
[ 0 : 9 ]INT d count := z count;

# as the digit power sum is independent of the order of the digits, we need only    #
# consider one arrangement of each possible combination of digits                   #
FOR d1 FROM 0 TO 9 DO
    FOR d2 FROM 0 TO d1 DO
        FOR d3 FROM 0 TO d2 DO
            FOR d4 FROM 0 TO d3 DO
                FOR d5 FROM 0 TO d4 DO
                    FOR d6 FROM 0 TO d5 DO
                        FOR d7 FROM 0 TO d6 DO
                            FOR d8 FROM 0 TO d7 DO
                                FOR d9 FROM 0 TO d8 DO
                                    FOR da FROM 0 TO d9 DO
                                        LONG INT digit power sum  := nth power[ d1 ] + nth power[ d2 ];
                                        digit power sum          +:= nth power[ d3 ] + nth power[ d4 ];
                                        digit power sum          +:= nth power[ d5 ] + nth power[ d6 ];
                                        digit power sum          +:= nth power[ d7 ] + nth power[ d8 ];
                                        digit power sum          +:= nth power[ d9 ] + nth power[ da ];
                                        # count the occurrences of each digit (including leading zeros #
                                        d count        := z count;
                                        d count[ d1 ] +:= 1; d count[ d2 ] +:= 1; d count[ d3 ] +:= 1;
                                        d count[ d4 ] +:= 1; d count[ d5 ] +:= 1; d count[ d6 ] +:= 1;
                                        d count[ d7 ] +:= 1; d count[ d8 ] +:= 1; d count[ d9 ] +:= 1;
                                        d count[ da ] +:= 1;
                                        # subtract the occurrences of each digit in the power sum      #
                                        # (also including leading zeros) - if all counts drop to 0 we  #
                                        # have a Munchausen number                                     #
                                        LONG INT number        := digit power sum;
                                        INT      leading zeros := 10;
                                        WHILE number > 0 DO
                                            d count[ SHORTEN ( number MOD 10 ) ] -:= 1;
                                            leading zeros -:= 1;
                                            number OVERAB 10
                                        OD;
                                        d count[ 0 ] -:= leading zeros;
                                        IF  d count[ 0 ] = 0 AND d count[ 1 ] = 0 AND d count[ 2 ] = 0
                                        AND d count[ 3 ] = 0 AND d count[ 4 ] = 0 AND d count[ 5 ] = 0
                                        AND d count[ 6 ] = 0 AND d count[ 7 ] = 0 AND d count[ 8 ] = 0
                                        AND d count[ 9 ] = 0
                                        THEN
                                            print( ( digit power sum, newline ) )
                                        FI
                                    OD
                                OD
                            OD
                        OD
                    OD
                OD
            OD
        OD
    OD
OD
