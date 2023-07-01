BEGIN # Chinese Zodiac #
    # returns s right-padded with blanks to w characters, or s if s is already at least w characters long #
    PRIO PAD = 1;
    OP   PAD = ( STRING s, INT w )STRING:
         BEGIN
            STRING result := s;
            WHILE ( ( UPB result + 1 ) - LWB s ) < w DO result +:= " " OD;
            result
         END # PAD # ;
    []STRING animal name  = ( "Rat",   "Ox",   "Tiger",  "Rabbit",  "Dragon", "Snake"
                            , "Horse", "Goat", "Monkey", "Rooster", "Dog",    "Pig"
                            );
    []STRING element name = ( "Wood",  "Fire", "Earth",  "Metal",   "Water" );
    []INT    test year    = ( 1935, 1938, 1968, 1972, 1976, 1984, 1985, 2017 );
    print( ( "year element animal  aspect", newline ) );
    FOR i FROM LWB test year TO UPB test year DO
        INT    year    = test year[ i ];
        STRING element = element name[ ( ( year - 4 ) MOD 10 OVER 2 ) + 1 ];
        STRING animal  = animal name[    ( year - 4 ) MOD 12          + 1 ];
        STRING yy      = IF ODD year THEN "Yin" ELSE "Yang" FI;
        print( ( whole( year, -4 ), " ", element PAD 7, " ", animal PAD 7, " ", yy, newline ) )
    OD
END
