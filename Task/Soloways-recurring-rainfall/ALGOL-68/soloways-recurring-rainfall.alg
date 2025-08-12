BEGIN # read a sequence of integers, terminated by 99999 and output their average #
    INT end value       = 99999;
    INT sum            := 0;
    INT count          := 0;
    BOOL invalid value := FALSE;
    on value error( stand in, ( REF FILE f )BOOL: invalid value := TRUE );
    WHILE
        INT n := 0;
        WHILE
            print( ( "Enter rainfall (integer) or ", whole( end value, 0 ), " to quit: " ) );
            read( ( n, newline ) );
            invalid value
        DO
            print( ( "Invalid input, please enter an integer", newline ) );
            invalid value := FALSE
        OD;
        n /= end value
    DO
        sum   +:= n;
        count +:= 1;
        print( ( "New average: ", fixed( sum / count, -12, 4 ), newline ) )
    OD
END
