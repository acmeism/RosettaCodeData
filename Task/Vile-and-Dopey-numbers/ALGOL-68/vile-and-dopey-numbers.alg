BEGIN # find vile & dopey numbers                                            #

    PR read "rows.incl.a68" PR    # include roww (array) utilities inc. SHOW #

    # returns TRUE if n is vile, FALSE if it is dopey                        #
    #         numbers are vile if odd or their binary representation ends in #
    #         an even number of zeros                                        #
    OP    ISVILE = ( INT n )BOOL:
          IF n < 1 THEN print( ( "Can't classify: ", whole( n, 0 ) ) ); FALSE
          ELIF ODD n THEN TRUE
          ELSE
             INT zeroes := 0, v := n;
             WHILE NOT ODD v DO
                 v OVERAB 2;
                 zeroes +:= 1
             OD;
             NOT ODD zeroes
          FI # VILE # ;

    BEGIN # task                                                             #
        [ 1 : 25 ]INT vile 25, dopey 25;
        [ 1 : 10 ]INT vile count;
        INT power of 2 := 1, two to power := 2;
        INT n vile := 0, n dopey := 0;
        FOR n TO 2^10 DO
            IF ISVILE n THEN
                IF ( n vile  +:= 1 ) <= UPB vile 25  THEN vile 25[  n vile  ] := n FI
            ELSE
                IF ( n dopey +:= 1 ) <= UPB dopey 25 THEN dopey 25[ n dopey ] := n FI
            FI;
            IF n = two to power THEN
                vile count[ power of 2 ] := n vile;
                power of 2   +:= 1;
                two to power *:= 2
            FI
        OD;
        print( ( "First 25 vile  numbers: " ) );
        SHOW vile 25;
        print( ( newline ) );
        print( ( "First 25 Dopey numbers: " ) );
        SHOW dopey 25;
        print( ( newline ) );
        print( ( "power 2^power vile count dopey count", newline ) );
        print( ( "----- ------- ---------- -----------", newline ) );
        FOR p TO UPB vile count DO
            print( ( whole( p, -5 ), whole( 2^p, -8 ) ) );
            print( ( whole( vile count[ p ], -11 ), whole( 2^p - vile count[ p ], -12 ), newline ) )
        OD
    END
END
