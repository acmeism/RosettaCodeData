BEGIN # find non-ascending subsequences in a list of integer values and      #
      # count those with the percentage change in various ranges             #

    # mode to hold the details of a non-ascending sequence                   #
    MODE SEQUENCE = STRUCT( INT start index, end index );

    # returns the next non-ascending SEQUENCE from data starting at prev,    #
    #         or a SEQUENCE with start index > end index if there isn't one  #
    PRIO NEXTSEQUENCE = 1;
    OP   NEXTSEQUENCE = ( []INT data, SEQUENCE prev )SEQUENCE:
         IF  INT s pos = end index OF prev + 1;
             s pos > UPB data
         THEN SEQUENCE( s pos, UPB data )      # reached the end of the data #
         ELSE INT value := data[ s pos ];            # still some data left #
              INT e pos := s pos + 1;
              WHILE IF e pos > UPB data THEN FALSE ELSE data[ e pos ] <= value FI
              DO
                  value  := data[ e pos ];
                  e pos +:= 1
              OD;
              SEQUENCE( s pos, e pos - 1 )
         FI # NEXTSEQUENCE # ;

    # returns the first non-ascending SEQUENCE from data                     #
    #         or a SEQUENCE with start index > end index if there isn't one  #
    OP   FIRSTSEQUENCE = ( []INT data )SEQUENCE:
         IF  LWB data > UPB data
         THEN SEQUENCE( LWB data, UPB data )          # data has no elements #
         ELSE                                            # data is not empty #
              data NEXTSEQUENCE SEQUENCE( -1, LWB data - 1 )
         FI # FIRSTSEQUENCE # ;

    # count the non-ascending SEQUENCEs in data, grouping by the percentage  #
    # changes in the specified ranges                                        #
    # ranges must be the upper bound of the required range and must be       #
    # specified in order, the first range will start at 0, there will be a   #
    # final element for percentages >= the final range                       #
    # SEQUENCEs with a single element or 0 percentage change are ignored     #
    # returns the counts                                                     #
    PRIO COUNTCHANGESBYPERCENTAGE = 1;
    OP   COUNTCHANGESBYPERCENTAGE = ( []INT data, ranges )[]INT:
         BEGIN
            [ LWB ranges : UPB ranges + 1 ]INT counts;
            FOR i FROM LWB counts TO UPB counts DO counts[ i ] := 0 OD;
            SEQUENCE prev := FIRSTSEQUENCE data;
            WHILE INT start pos = start index OF prev;
                  INT end pos   = end index OF prev;
                  end pos >= start pos
            DO
                IF end pos > start pos THEN          # more than one element #
                    INT  s value = data[ start pos ], e value = data[ end pos ];
                    REAL change = ( ( s value - e value ) / s value ) * 100;
                    IF change > 0 THEN               # there was a decrease #
                        BOOL found := FALSE;
                        FOR i FROM LWB counts TO UPB counts - 1 WHILE NOT found DO
                            IF found := ranges[ i ] > change THEN counts[ i ] +:= 1 FI
                        OD;
                        IF NOT found THEN counts[ UPB counts ] +:= 1 FI
                    FI
                FI;
                prev := data NEXTSEQUENCE prev
            OD;
            counts
         END # COUNTCHANGESBYPERCEBTAGE # ;

    BEGIN # task test case                                                   #
        []INT ranges = ( 4, 8, 12, 16, 25 );
        []INT data = (
90, 90, 90, 91, 91, 92, 92, 92, 91, 91, 91, 90, 90, 90, 89, 89, 88, 87, 87, 87, 86, 86, 86, 85, 85,
86, 86, 87, 87, 88, 89, 89, 89, 90, 90, 91, 91, 91, 92, 92, 92, 92, 92, 92, 92, 92, 92, 91, 91, 90,
90, 90, 90, 90, 89, 89, 89, 89, 88, 88, 88, 88, 88, 88, 88, 88, 88, 88, 88, 88, 89, 89, 89, 89, 89,
89, 90, 90, 90, 89, 89, 89, 89, 89, 89, 88, 88, 88, 88, 88, 88, 87, 88, 88, 88, 88, 88, 88, 88, 88,
88, 88, 88, 88, 88, 88, 88, 88, 88, 88, 88, 88, 88, 89, 89, 89, 89, 89, 88, 88, 88, 88, 88, 88, 89,
89, 89, 89, 89, 89, 89, 89, 88, 88, 88, 88, 88, 88, 88, 88, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87,
87, 87, 88, 88, 88, 88, 88, 88, 88, 88, 88, 89, 89, 89, 89, 89, 89, 89, 88, 88, 88, 88, 88, 88, 88,
88, 88, 88, 88, 89, 89, 89, 89, 89, 89, 89, 89, 89, 89, 88, 88, 88, 87, 87, 87, 87, 86, 86, 86, 86,
86, 86, 87, 87, 87, 87, 87, 87, 87, 88, 88, 88, 88, 88, 88, 88, 88, 88, 89, 89, 89, 89, 89, 89, 89,
88, 88, 88, 88, 88, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 89, 89, 91,
94, 94, 95, 96, 96, 96, 97, 97, 96, 96, 96, 96, 95, 95, 94, 93, 93, 92, 92, 91, 91, 90, 89, 89, 88,
86, 86, 85, 83, 83, 81, 80, 80, 80, 79, 79, 79, 78, 78, 79, 81, 82, 82, 85, 89, 89, 91, 93, 93, 94,
95, 95, 95, 95, 95, 95, 95, 95, 95, 94, 94, 94, 94, 93, 93, 93, 92, 92, 91, 91, 91, 90, 90, 90, 88,
87, 87, 86, 85, 85, 84, 84, 84, 83, 84, 84, 84, 85, 86, 86, 87, 87, 87, 88, 88, 88, 89, 90, 90, 90,
91, 91, 92, 92, 92, 93, 94, 94, 94, 95, 95, 95, 95, 94, 94, 94, 93, 93, 93, 92, 92, 92, 91, 91, 90,
89, 89, 87, 86, 85, 85, 84, 83, 83, 82, 82, 82, 81, 81, 81, 81, 81, 81, 82, 85, 85, 86, 89, 89, 91,
92, 93, 93, 93, 94, 94, 94, 94, 94, 94, 94, 94, 94, 93, 93, 93, 92, 92, 92, 91, 91, 91, 90, 89, 89,
88, 88, 88, 87, 87, 87, 86, 86, 86, 85, 85, 85, 85, 85, 85, 86, 87, 87, 87, 88, 88, 88, 88, 88, 88,
89, 89, 89, 89, 89, 89, 90, 90, 90, 90, 91, 91, 92, 93, 93, 94, 94, 95, 95, 95, 96, 96, 96, 95, 95,
95, 94, 94, 93, 93, 93, 92, 90, 90, 89, 87, 87, 87, 85, 83, 83, 82, 81, 81, 81, 80, 80, 81, 81, 81,
81, 81, 81, 81, 81, 81, 81, 81, 81, 83, 86, 88, 88, 90, 91, 91, 91, 92, 92, 93, 93, 93, 94, 95, 95,
95, 96, 96, 96, 96, 96, 96, 96, 95, 95, 95, 95, 95, 94, 93, 93, 92, 92, 92, 91, 90, 90, 90, 90, 90,
91, 93, 93, 94, 94, 94, 94, 95, 94, 94, 94, 94, 94, 94, 93, 93, 93, 93, 93, 93, 92, 92, 92, 92, 92,
91, 91, 91, 91, 91, 91, 91, 91, 90, 90, 90, 90, 90, 90, 90, 90, 89, 89, 89, 89, 89, 89, 89, 89, 89,
89, 90, 90, 90, 90, 91, 91, 92, 93, 93, 93, 94, 94, 94, 94, 94, 94, 94, 94, 94, 95, 95, 95, 95, 95,
95, 95, 95, 95, 94, 93, 93, 93, 93, 93, 92, 92, 92, 91, 91, 91, 91, 90, 90, 90, 89, 89, 89, 88, 88,
88, 88, 88, 88, 88, 88, 88, 89, 89, 89, 89, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 91, 91, 91, 91,
91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 91, 92,
92, 93, 93, 93, 93, 94, 94, 94, 93, 93, 93, 93, 93, 93, 92, 92, 92, 91, 91, 91, 90, 90, 90, 89, 88,
88, 87, 87, 87, 86, 86, 85, 85, 85, 86, 86, 86, 87, 87, 88, 88, 88, 89, 90, 90, 90, 91, 91, 91, 91,
91, 91, 91, 91, 91, 92, 92, 92, 93, 93, 93, 93, 93, 93, 93, 92, 92, 92, 91, 91, 90, 90, 90, 89, 88,
87, 87, 87, 86, 86, 86, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 85, 86, 86, 86, 86, 87, 88, 88, 88,
89, 89, 90, 91, 91, 92, 93, 93, 93, 94, 94, 94, 94, 94, 94, 94, 94, 94, 93, 93, 93, 92, 92, 92, 91,
90, 90, 90, 89, 89, 88, 88, 88, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 87, 88, 88, 88,
90, 90, 91, 93, 93, 93, 93, 93, 94, 93, 93, 93, 93, 93, 93, 92, 92, 92, 91, 91, 91, 90, 90, 90, 89,
89, 89, 88, 87, 87, 87, 87, 87, 86, 87, 87, 87, 87, 87, 87, 87, 87, 87, 88, 88, 88, 88, 88, 88, 88,
89               );

        # shows start percentage, end percentage and count                   #
        PROC show range count = ( INT p start, p end, count )VOID:
             print( ( IF p start = 0 THEN "(" ELSE "[" FI
                    , whole( p start, -3 ), "% .. ", whole( p end, -3 ), "% "
                    , IF p end = 100 THEN "]" ELSE ")" FI, ": ", whole( count, 0 )
                    , newline ) );

        []INT counts = data COUNTCHANGESBYPERCENTAGE ranges;
        INT r start := 0;
        FOR i FROM LWB counts TO UPB counts - 1 DO
            show range count( r start, ranges[ i ], counts[ i ] );
            r start := ranges[ i ]
        OD;
        IF r start < 100 THEN show range count( r start, 100, counts[ UPB counts ] ) FI
    END
END
