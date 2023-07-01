BEGIN
    # performs Egyptian division of dividend by divisor, setting quotient and remainder #
    # this uses 32 bit numbers, so a table of 32 powers of 2 should be sufficient       #
    # ( divisors > 2^30 will probably overflow - this is not checked here )             #
    PROC egyptian division = ( INT dividend, divisor, REF INT quotient, remainder )VOID:
         BEGIN
            [ 1 : 32 ]INT powers of 2, doublings;
            # initialise the powers of 2 and doublings tables #
            powers of 2[ 1 ] := 1;
            doublings  [ 1 ] := divisor;
            INT   table pos  := 1;
            WHILE table pos +:= 1;
                  powers of 2[ table pos ] := powers of 2[ table pos - 1 ] * 2;
                  doublings  [ table pos ] := doublings  [ table pos - 1 ] * 2;
                  doublings[ table pos ] <= dividend
            DO
                SKIP
            OD;
            # construct the accumulator and answer #
            INT accumulator := 0, answer := 0;
            WHILE table pos >=1
            DO
                IF ( accumulator + doublings[ table pos ] ) <= dividend
                THEN
                    accumulator +:= doublings  [ table pos ];
                    answer      +:= powers of 2[ table pos ]
                FI;
                table pos -:= 1
            OD;
            quotient  := answer;
            remainder := ABS ( accumulator - dividend )
        END # egyptian division # ;

    # task test case #
    INT quotient, remainder;
    egyptian division( 580, 34, quotient, remainder );
    print( ( "580 divided by 34 is: ", whole( quotient, 0 ), " remainder: ", whole( remainder, 0 ), newline ) )
END
