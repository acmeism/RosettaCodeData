BEGIN # Bernoulli's triangle                                                 #

    # returns the next row of Bernoulli's triangle after prev                #
    OP   NEXTBTROW = ( []INT prev )[]INT:
         IF UPB prev < LWB prev THEN
            # generate the first row                                         #
            ( 1 )
         ELSE
            # row 2 or higher                                                #
            [ LWB prev : UPB prev + 1 ]INT next;
            next[ LWB prev : UPB prev ] := prev;
            INT p2 := 2;
            FOR i FROM UPB prev BY -1 TO LWB prev + 1 DO
                next[ i ] := prev[ i - 1 ] + prev[ i ];
                p2 +:= p2
            OD;
            next[ UPB next ] := p2;
            next
         FI # NEXTBTROW #;

    BEGIN # show the first 15 rows of the triangle                           #
        FLEX[ 1 : 0 ]INT row;
        TO 15 DO
            row := NEXTBTROW row;
            FOR i FROM LWB row TO UPB row DO
                print( ( IF i = 1 THEN "" ELSE " " FI, whole( row[ i ], 0 ) ) )
            OD;
            print( ( newline ) )
        OD
    END
END
