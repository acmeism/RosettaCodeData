BEGIN # Dutch national flag problem: sort a set of randomly arranged red, white and blue balls into order #
      # ball sets are represented by STRING items, red by "R", white by "W" and blue by "B" #
    # returns the balls sorted into red, white and blue order #
    PROC sort balls = ( STRING balls )STRING:
    BEGIN
        [ 1 : ( UPB balls + 1 ) - LWB balls ]CHAR result, white, blue;
        INT r pos := 0, w pos := 0, b pos := 0;
        # copy the red balls into the result and split the white and blue #
        # into separate lists #
        FOR pos FROM LWB balls TO UPB balls DO
            CHAR b = balls[ pos ];
            IF b = "R" THEN
                # red ball - add to the result #
                result[ r pos +:= 1 ] := b
            ELIF b = "W" THEN
                # white ball #
                white[ w pos  +:= 1 ] := b
            ELSE
                # must be blue #
                blue[ b pos   +:= 1 ] := b
            FI
        OD;
        # add the white balls to the list #
        IF w pos > 0 THEN
            # there were some white balls - add them to the result #
            result[ r pos + 1 : r pos + w pos ] := white[ 1 : w pos ];
            r pos +:= w pos
        FI;
        # add the blue balls to the list #
        IF b pos > 0 THEN
            # there were some blue balls - add them to the end of the result #
            result[ r pos + 1 : r pos + b pos ] := blue[ 1 : b pos ];
            r pos +:= b pos
        FI;
        result[ 1 : r pos ]
    END # sort balls # ;
    # returns TRUE if balls is sorted, FALSE otherwise #
    PROC sorted balls = ( STRING balls )BOOL:
    BEGIN
        BOOL result := TRUE;
        FOR i FROM LWB balls + 1 TO UPB balls
        WHILE result := (  CHAR prev = balls[ i - 1 ];
                           CHAR curr = balls[ i     ];
                           prev = curr
                        OR ( prev = "R" AND curr = "W" )
                        OR ( prev = "R" AND curr = "B" )
                        OR ( prev = "W" AND curr = "B" )
                        )
        DO SKIP OD;
        result
    END # sorted balls # ;
    # constructs an unsorted random string of n balls #
    PROC random balls = ( INT n )STRING:
    BEGIN
        STRING result := n * "?";
        WHILE FOR i TO n DO
                  result[ i ] := IF   INT r = ENTIER( next random * 3 ) + 1;
                                      r = 1
                                 THEN "R"
                                 ELIF r = 2
                                 THEN "W"
                                 ELSE "B"
                                 FI
              OD;
              sorted balls( result )
        DO SKIP OD;
        result
    END # random balls # ;
    # tests #
    FOR i FROM 11 BY 3 TO 17 DO
        STRING balls;
        balls := random balls( i );
        print( ( "before: ", balls, IF sorted balls( balls ) THEN " initially sorted??" ELSE "" FI, newline ) );
        balls := sort balls( balls );
        print( ( "after:  ", balls, IF sorted balls( balls ) THEN "" ELSE " NOT" FI, " sorted", newline ) )
    OD
END
