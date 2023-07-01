# Find Munchausen Numbers between 1 and 5000                                        #
# note that 6^6 is 46 656 so we only need to consider numbers consisting of 0 to 5   #

# table of Nth powers - note 0^0 is 0 for Munchausen numbers, not 1                 #
[]INT nth power = ([]INT( 0, 1, 2 * 2, 3 * 3 * 3, 4 * 4 * 4 * 4, 5 * 5 * 5 * 5 * 5 ))[ AT 0 ];

INT d1 := 0; INT d1 part := 0;
INT d2 := 0; INT d2 part := 0;
INT d3 := 0; INT d3 part := 0;
INT d4 := 1;
WHILE d1 < 6 DO
    INT number           = d1 part + d2 part + d3 part + d4;
    INT digit power sum := nth power[ d1 ]
                         + nth power[ d2 ]
                         + nth power[ d3 ]
                         + nth power[ d4 ];
    IF digit power sum = number THEN
        print( ( whole( number, 0 ), newline ) )
    FI;
    d4 +:= 1;
    IF d4 > 5 THEN
        d4       := 0;
        d3      +:= 1;
        d3 part +:= 10;
        IF d3 > 5 THEN
            d3       := 0;
            d3 part  := 0;
            d2      +:= 1;
            d2 part +:= 100;
            IF d2 > 5 THEN
                d2       := 0;
                d2 part  := 0;
                d1      +:= 1;
                d1 part +:= 1000;
            FI
        FI
    FI
OD
