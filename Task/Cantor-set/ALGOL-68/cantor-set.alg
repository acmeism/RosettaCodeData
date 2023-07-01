BEGIN
    # draw a Cantor Set using ASCII                                            #
    INT    lines     = 5; # number of lines for the set                        #
    # we must choose the line width so that the width of each segment is       #
    # divisible by 3 ( except for the final line where the segment width will  #
    # be 1 )                                                                   #
    INT    set width = 3 ^ ( lines - 1 );
    [ set width ]CHAR set;
    # start with a complete line #
    FOR i TO set width DO set[ i ] := "#" OD;
    print( ( set, newline ) );
    # repeatedly modify the line, replacing the middle third of each segment   #
    # with blanks                                                              #
    INT   segment width := set width OVER 3;
    WHILE segment width > 0 DO
        INT   set pos := 1;
        WHILE set pos < ( set width - segment width ) DO
            set pos   +:= segment width;
            FOR char pos FROM set pos TO ( set pos + segment width ) - 1 DO
                set[ char pos ] := " "
            OD;
            set pos +:= segment width
        OD;
        print( ( set, newline ) );
        segment width OVERAB 3
    OD
END
