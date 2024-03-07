BEGIN # solve the sum and product puzzle: find X, Y where 1 < X < Y; X + Y <= 100 #
      # mathematician S knows X + Y and P knows X * Y                             #
      # S says P doesn't know X and Y, P says they now know X and Y which leads S #
      # to also know X and Y                                                      #
      # which leads to the following (from the task)                              #
      # 1: For every possible sum decomposition of the number X+Y,                #
      #        the product has in turn more than one product decomposition        #
      # 2: The number X*Y has only one product decomposition for which 1: is true #
      # 3: The number X+Y has only one sum decomposition for which 2: is true     #

    # determine the possible sums and products and count their occurances         #
    INT max n = 98, min n = 2;
    [ 0 : max n * max n ]INT s count, p count;
    [ min n : max n, min n : max n ]BOOL candidate;
    FOR x FROM LWB p count TO UPB p count DO p count[ x ] := s count[ x ] := 0 OD;
    FOR x FROM min n TO max n DO FOR y FROM min n TO max n DO candidate[ x, y ] := FALSE OD OD;
    FOR x FROM min n TO max n - min n DO
        FOR y FROM x + 1 TO max n - x DO
            s count[ x + y ] +:= 1;
            p count[ x * y ] +:= 1
        OD
    OD;

    # shows the count of the candidates                                          #
    PROC show candidates = ( STRING stage )VOID:
         BEGIN
            INT c count := 0;
            FOR x FROM min n TO max n DO
                FOR y FROM min n TO max n DO IF candidate[ x, y ] THEN c count +:= 1 FI OD
            OD;
            print( ( stage, " ", whole( c count, - 5 ), " candidate", IF c count = 1 THEN "" ELSE "s" FI, newline ) )
        END # show candidates # ;

    # checks 1: is TRUE for x plus y, returns TRUE if it is, FALSE otherwose      #
    PROC all sums have multiple product decompositions = ( INT x plus y )BOOL:
         BEGIN
            BOOL all multiple p := TRUE;
            FOR x FROM min n TO x plus y OVER 2 WHILE all multiple p DO
                INT y = x plus y - x;
                IF y > x AND y <= max n THEN
                    # x, y is a sum decomposition of x plus y                     #
                    IF candidate[ x, y ] THEN all multiple p := all multiple p AND p count[ x * y ] > 1 FI
                FI
            OD;
            all multiple p
         END # all sums have multiple product decompositions # ;

    # checks 2: is TRUE for x times y, returns TRUE if it is, FALSE otherwose     #
    PROC only one product decomposition = ( INT x times y )BOOL:
         BEGIN
            INT multiple p := 0;
            FOR x FROM min n TO ENTIER sqrt( x times y ) DO
                IF x times y MOD x = 0 THEN
                    INT y = x times y OVER x;
                    IF y > x AND y <= max n THEN
                        # x, y is a product decomposition of x times y            #
                        IF candidate[ x, y ] THEN
                            IF all sums have multiple product decompositions( x + y ) THEN
                                multiple p +:= 1
                            FI
                        FI
                    FI
                FI
            OD;
            multiple p = 1
         END # only one product decomposition # ;

    # start off with all min n .. max n as candidates                             #
    FOR x FROM min n TO max n DO
        FOR y FROM x + 1 TO max n DO
            IF x + y <= 100 THEN candidate[ x, y ] := TRUE FI
        OD
    OD;
    show candidates( "Sum and product puzzle " );

    # Statement 1: S says P doesn't know X and Y                                  #
    FOR x plus y FROM min n TO max n + min n DO
        IF NOT all sums have multiple product decompositions( x plus y ) THEN
            FOR x FROM min n TO x plus y OVER 2 DO
                INT y = x plus y - x;
                IF y > x AND y <= max n THEN candidate[ x, y ] := FALSE FI
            OD
        FI
    OD;
    show candidates( "After statement 1      " );

    # Statement 2: P says they now know X and Y                                   #
    FOR x times y FROM min n * ( min n + 1 ) TO max n * max n DO
        IF NOT only one product decomposition( x times y ) THEN
            FOR x FROM min n TO ENTIER sqrt( x times y ) DO
                IF x times y MOD x = 0 THEN
                    INT y = x times y OVER x;
                    IF y > x AND y <= max n THEN candidate[ x, y ] := FALSE FI
                FI
            OD
        FI
    OD;
    show candidates( "After statement 2      " );

    # Statement 3: S says they now also know X and Y, check 3:                    #
    FOR x plus y FROM min n TO max n + min n DO
        INT multiple s := 0;
        FOR x FROM min n TO x plus y OVER 2 DO
            INT y = x plus y - x;
            IF y > x AND y <= max n THEN
                # x, y is a sum decomposition of x plus y                         #
                IF candidate[ x, y ] THEN
                    IF only one product decomposition( x * y ) THEN multiple s +:= 1 FI
                FI
            FI
        OD;
        IF multiple s /= 1 THEN
            FOR x FROM min n TO x plus y OVER 2 DO
                INT y = x plus y - x;
                IF y > x AND y <= max n THEN candidate[ x, y ] := FALSE FI
            OD
        FI
    OD;
    show candidates( "After statement 3      " );

    print( ( newline, "solution: " ) );
    FOR x FROM min n TO max n DO
        FOR y FROM min n TO max n DO
            IF candidate[ x, y ] THEN print( ( whole( x, 0 ), ", ", whole( y, 0 ), newline ) ) FI
        OD
    OD

END
