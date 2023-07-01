BEGIN
    # find the numbers the string 123456789 ( with "+/-" optionally inserted  #
    # before each digit ) can generate                                        #

    # experimentation shows that the largest hundred numbers that can be      #
    # generated are are greater than or equal to 56795                        #
    # as we can't declare an array with bounds -123456789 : 123456789 in      #
    # Algol 68G, we use -60000 : 60000 and keep counts for the top hundred    #

    INT max number = 60 000;
    [ - max number : max number ]STRING solutions;
    [ - max number : max number ]INT    count;
    FOR i FROM LWB solutions TO UPB solutions DO solutions[ i ] := ""; count[ i ] := 0 OD;

    # calculate the numbers ( up to max number ) we can generate and the strings leading to them  #
    # also determine the largest numbers we can generate #
    [ 100 ]INT largest;
    [ 100 ]INT largest count;
    INT impossible number = - 999 999 999;
    FOR i FROM LWB largest TO UPB largest DO
        largest      [ i ] := impossible number;
        largest count[ i ] := 0
    OD;
    [ 1 : 18 ]CHAR sum string := ".1.2.3.4.5.6.7.8.9";
    []CHAR sign char = []CHAR( "-", " ", "+" )[ AT -1 ];
    # we don't distinguish between strings starting "+1" and starting " 1" #
    FOR s1 FROM -1 TO 0 DO
        sum string[  1 ] := sign char[ s1 ];
        FOR s2 FROM -1 TO 1 DO
            sum string[  3 ] := sign char[ s2 ];
            FOR s3 FROM -1 TO 1 DO
                sum string[  5 ] := sign char[ s3 ];
                FOR s4 FROM -1 TO 1 DO
                    sum string[  7 ] := sign char[ s4 ];
                    FOR s5 FROM -1 TO 1 DO
                        sum string[  9 ] := sign char[ s5 ];
                        FOR s6 FROM -1 TO 1 DO
                            sum string[ 11 ] := sign char[ s6 ];
                            FOR s7 FROM -1 TO 1 DO
                                sum string[ 13 ] := sign char[ s7 ];
                                FOR s8 FROM -1 TO 1 DO
                                    sum string[ 15 ] := sign char[ s8 ];
                                    FOR s9 FROM -1 TO 1 DO
                                        sum string[ 17 ] := sign char[ s9 ];
                                        INT number := 0;
                                        INT part   := IF s1 < 0 THEN -1 ELSE 1 FI;
                                        IF s2 = 0 THEN part *:= 10 +:= 2 * SIGN part ELSE number +:= part; part := 2 * s2 FI;
                                        IF s3 = 0 THEN part *:= 10 +:= 3 * SIGN part ELSE number +:= part; part := 3 * s3 FI;
                                        IF s4 = 0 THEN part *:= 10 +:= 4 * SIGN part ELSE number +:= part; part := 4 * s4 FI;
                                        IF s5 = 0 THEN part *:= 10 +:= 5 * SIGN part ELSE number +:= part; part := 5 * s5 FI;
                                        IF s6 = 0 THEN part *:= 10 +:= 6 * SIGN part ELSE number +:= part; part := 6 * s6 FI;
                                        IF s7 = 0 THEN part *:= 10 +:= 7 * SIGN part ELSE number +:= part; part := 7 * s7 FI;
                                        IF s8 = 0 THEN part *:= 10 +:= 8 * SIGN part ELSE number +:= part; part := 8 * s8 FI;
                                        IF s9 = 0 THEN part *:= 10 +:= 9 * SIGN part ELSE number +:= part; part := 9 * s9 FI;
                                        number +:= part;
                                        IF  number >= LWB solutions
                                        AND number <= UPB solutions
                                        THEN
                                            solutions[ number ] +:= ";" + sum string;
                                            count    [ number ] +:= 1
                                        FI;
                                        BOOL inserted := FALSE;
                                        FOR l pos FROM LWB largest TO UPB largest WHILE NOT inserted DO
                                            IF number > largest[ l pos ] THEN
                                                # found a new larger number #
                                                FOR m pos FROM UPB largest BY -1 TO l pos + 1 DO
                                                    largest      [ m pos ] := largest      [ m pos - 1 ];
                                                    largest count[ m pos ] := largest count[ m pos - 1 ]
                                                OD;
                                                largest      [ l pos ] := number;
                                                largest count[ l pos ] := 1;
                                                inserted := TRUE
                                            ELIF number = largest[ l pos ] THEN
                                                # have another way of generating this number #
                                                largest count[ l pos ] +:= 1;
                                                inserted := TRUE
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
    OD;

    # show the solutions for 100 #
    print( ( "100 has ", whole( count[ 100 ], 0 ), " solutions:" ) );
    STRING s := solutions[ 100 ];
    FOR s pos FROM LWB s TO UPB s DO
        IF   s[ s pos ] = ";" THEN print( ( newline, "        " ) )
        ELIF s[ s pos ] /= " " THEN print( ( s[ s pos ] ) )
        FI
    OD;
    print( ( newline ) );
    # find the number with the most solutions #
    INT max solutions := 0;
    INT number with max := LWB count - 1;
    FOR n FROM 0 TO max number DO
        IF count[ n ] > max solutions THEN
            max solutions := count[ n ];
            number with max := n
        FI
    OD;
    FOR n FROM LWB largest count TO UPB largest count DO
        IF largest count[ n ] > max solutions THEN
            max solutions := largest count[ n ];
            number with max := largest[ n ]
        FI
    OD;
    print( ( whole( number with max, 0 ), " has the maximum number of solutions: ", whole( max solutions, 0 ), newline ) );
    # find the smallest positive number that has no solutions #
    BOOL have solutions := TRUE;
    FOR n FROM 0 TO max number
    WHILE IF NOT ( have solutions := count[ n ] > 0 )
          THEN print( ( whole( n, 0 ), " is the lowest positive number with no solutions", newline ) )
          FI;
          have solutions
    DO SKIP OD;
    IF have solutions
    THEN print( ( "All positive numbers up to ", whole( max number, 0 ), " have solutions", newline ) )
    FI;
    print( ( "The 10 largest numbers that can be generated are:", newline ) );
    FOR t pos FROM 1 TO 10 DO
        print( ( " ", whole( largest[ t pos ], 0 ) ) )
    OD;
    print( ( newline ) )

END
