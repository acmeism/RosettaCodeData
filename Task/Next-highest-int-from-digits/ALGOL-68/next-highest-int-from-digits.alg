BEGIN # find the next integer > a given integer with the same digits         #

    OP   -    = ( CHAR a, b )INT: ABS a - ABS b;     # character subtraction #
    PROC swap = ( REF STRING s, INT a, b )VOID: # swap chars at a and b in s #
         BEGIN CHAR t = s[ a ]; s[ a ] := s[ b ]; s[ b ] := t END;

    # returns the next integer greater than v with the same digits as v      #
    OP   NEXT = ( LONG INT v )LONG INT:
         BEGIN
            LONG INT result := 0;
            STRING   s      := whole( v, 0 );
            INT      c pos  := UPB s - 1;
            # find the rightmost digit that has a lower digit to the left    #
            WHILE IF   c pos < LWB s
                  THEN FALSE
                  ELSE s[ c pos ] >= s[ c pos + 1 ]
                  FI
            DO
                c pos -:=1
            OD;
            IF c pos >= LWB s THEN
                # the digit at c pos is lower than one to its right          #
                # swap the lower digit with the smallest right digit greater #
                # than the lower digit                                       #
                CHAR c = s[ c pos ];
                INT  min pos  := c pos + 1;
                INT  min diff := s[ c pos + 1 ] - c;
                FOR m pos FROM c pos + 2 TO UPB s DO
                    IF s[ m pos ] > c THEN
                        IF  INT this diff = s[ m pos ] - c;
                            this diff < min diff
                        THEN
                            min diff := this diff;
                            min pos  := m pos
                        FI
                    FI
                OD;
                swap( s, min pos, c pos );
                # sort the right digits                                      #
                FOR u FROM UPB s - 1 BY -1 TO c pos + 1
                WHILE BOOL sorted := TRUE;
                      FOR p FROM c pos + 1 BY 1 TO u DO
                          IF s[ p ] > s[ p + 1 ] THEN
                              swap( s, p, p + 1 );
                              sorted := FALSE
                          FI
                      OD;
                      NOT sorted
                DO SKIP OD;
                # convert back to an integer                                 #
                result := s[ LWB s ] - "0";
                FOR i FROM LWB s + 1 TO UPB s DO
                    result *:= 10 +:= s[ i ] - "0"
                OD
            FI;
            result
         END # NEXT # ;

    # task test cases                                                        #
    []LONG INT tests = ( 0, 9, 12, 21, 12453, 738440, 45072010, 95322020
                       , 9589776899767587796600
                       );
    FOR i FROM LWB tests TO UPB tests DO
        print( ( whole( tests[ i ], -24 ), " -> ", whole( NEXT tests[ i ], 0 ), newline ) )
    OD
END
