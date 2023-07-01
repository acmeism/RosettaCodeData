# simple guess-the-number game #

main:(

    BOOL valid input := TRUE;

    # register an error handler so we can detect and recover from #
    # invalid input #
    on value error( stand in
                  , ( REF FILE f )BOOL:
                    BEGIN
                        valid input := FALSE;
                        TRUE
                    END
                  );

    # construct a random integer between 1 and 100                #
    INT   number = 1 + ROUND ( random * 99 );

    print( ( "I'm thinking of a number between 1 and 100", newline ) );

    # read the user's guesses until they guess correctly          #
    # we give feedback so they can find the number using interval #
    # halving                                                     #
    WHILE
        print( ( "What do you think it is? " ) );
        INT guess;
        WHILE
            valid input := TRUE;
            read( ( guess, newline ) );
            NOT valid input
        DO
            print( ( "Please guess a number between 1 and 100", newline ) )
        OD;
        number /= guess
    DO
        IF number > guess
        THEN
            # the user's guess was too small #
            print( ( newline, "My number is higher than that", newline ) )
        ELSE
            # the user's guess was too large #
            print( ( newline, "My number is lower than that",  newline ) )
        FI
    OD;
    print( ( "That's correct!", newline ) )
)
