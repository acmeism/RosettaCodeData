BEGIN # display the period and group number of an element, #
      # given its atomic number                            #
    INT max atomic number = 118; # highest known element   #
    # the positions are stored as:                         #
    #     ( group number * group multiplier ) + period     #
    INT group multiplier  = 100;
    [ 1 : max atomic number ]INT position;
    # construct the positions of the elements in the table #
    BEGIN
        STRING periodic table = "-                ="
                              + "--          -----="
                              + "--          -----="
                              + "-----------------="
                              + "-----------------="
                              + "--8--------------="
                              + "--9--------------="
                              ;
        INT period  := 1;
        INT group   := 1;
        INT element := 1;
        FOR t FROM LWB periodic table TO UPB periodic table DO
            CHAR p = periodic table[ t ];
            IF p = "8" OR p = "9" THEN
                # lantanoids or actinoids                   #
                INT series period = IF p = "8" THEN 8 ELSE 9 FI;
                INT series group := 4;
                TO 15 DO
                    position[ element ] := ( group multiplier * series group ) + series period;
                    element            +:= 1;
                    series group       +:= 1
                OD
            ELIF p /= " " THEN
                # there is a single element here            #
                position[ element ] := ( group multiplier * group ) + period;
                element            +:= 1;
                IF p = "=" THEN
                    # final element of the period           #
                    period +:= 1;
                    group   := 0
                FI
            FI;
            group +:= 1
        OD
    END;
    # display the period and group numbers of test elements #
    []INT test = ( 1, 2, 29, 42, 57, 58, 59, 71, 72, 89, 90, 103, 113 );
    FOR t FROM LWB test TO UPB test DO
        INT e = test[ t ];
        IF e < LWB position OR e > UPB position THEN
            print( ( "Invalid element: ", whole( e, 0 ), newline ) )
        ELSE
            INT period = position[ e ] MOD  group multiplier;
            INT group  = position[ e ] OVER group multiplier;
            print( ( "Element ", whole( e,      -3 )
                   , " -> ", whole( period,  0 ), ", ", whole( group,  -2 )
                   , newline
                   )
                 )
        FI
    OD
END
