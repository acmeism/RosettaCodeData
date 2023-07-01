BEGIN
    INT    lower    :=    1;
    INT    upper    :=  100;
    print( ( "Think of a number between ", whole( lower, 0 ), " and ", whole( upper, 0 ), newline ) );
    print( ( "Please enter Y if I guess correctly, L is it is lower, G if it is greater or Q if you've had enough", newline ) );
    WHILE
        INT mid = lower + ( ( upper - lower ) OVER 2 );
        CHAR reply;
        WHILE
            print( ( "Is it ", whole( mid, 0 ), "?    Y/L/G/Q: " ) );
            read( ( reply, newline ) );
            NOT char in string( reply, NIL, "YLGQylgq" )
        DO SKIP OD;
        IF   reply = "Q" OR reply = "q" OR reply = "Y" OR reply = "y"
        THEN FALSE
        ELIF lower >= upper THEN
            print( ( "Based on your answers so far, it must be ", whole( lower, 0 ), newline ) );
            FALSE
        ELSE
            IF   reply = "L" OR reply = "l" THEN upper := mid - 1
            ELIF reply = "G" OR reply = "g" THEN lower := mid + 1
            FI;
            TRUE
        FI
    DO SKIP OD
END
