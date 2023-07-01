BEGIN
    # find some abundant odd numbers - numbers where the sum of the proper    #
    #                                  divisors is bigger than the number     #
    #                                  itself                                 #

    # returns the sum of the proper divisors of n                             #
    PROC divisor sum = ( INT n )INT:
    BEGIN
        INT sum := 1;
        FOR d FROM 2 TO ENTIER sqrt( n ) DO
            IF n MOD d = 0 THEN
                sum +:= d;
                IF INT other d := n OVER d;
                   other d /= d
                THEN
                    sum +:= other d
                FI
            FI
        OD;
        sum
    END # divisor sum # ;
    # find numbers required by the task                                       #
    BEGIN
        # first 25 odd abundant numbers                                       #
        INT odd number := 1;
        INT a count    := 0;
        INT d sum      := 0;
        print( ( "The first 25 abundant odd numbers:", newline ) );
        WHILE a count < 25 DO
            IF ( d sum := divisor sum( odd number ) ) > odd number THEN
                a count +:= 1;
                print( ( whole( odd number, -6 )
                       , " proper divisor sum: "
                       , whole( d sum, 0 )
                       , newline
                       )
                     )
            FI;
            odd number +:= 2
        OD;
        # 1000th odd abundant number                                          #
        WHILE a count < 1 000 DO
            IF ( d sum := divisor sum( odd number ) ) > odd number THEN
                a count := a count + 1
            FI;
            odd number +:= 2
        OD;
        print( ( "1000th abundant odd number:"
               , newline
               , "    "
               , whole( odd number - 2, 0 )
               , " proper divisor sum: "
               , whole( d sum, 0 )
               , newline
               )
             );
        # first odd abundant number > one billion                             #
        odd number := 1 000 000 001;
        BOOL found := FALSE;
        WHILE NOT found DO
            IF ( d sum := divisor sum( odd number ) ) > odd number THEN
                found  := TRUE;
                print( ( "First abundant odd number > 1 000 000 000:"
                       , newline
                       , "    "
                       , whole( odd number, 0 )
                       , " proper divisor sum: "
                       , whole( d sum, 0 )
                       , newline
                       )
                     )
            FI;
            odd number +:= 2
        OD
    END
END
