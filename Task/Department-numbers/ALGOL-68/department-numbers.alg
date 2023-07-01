BEGIN
    # show possible department number allocations for police, sanitation and fire departments #
    # the police department number must be even, all department numbers in the range 1 .. 7   #
    # the sum of the department numbers must be 12                                            #
    INT max department number =  7;
    INT department sum        = 12;
    print( ( "police sanitation fire", newline ) );
    FOR police FROM 2 BY 2 TO max department number DO
        FOR sanitation TO max department number DO
            IF sanitation /= police THEN
                INT fire = ( department sum - police ) - sanitation;
                IF  fire > 0 AND fire <= max department number
                AND fire /= sanitation
                AND fire /= police
                THEN
                    print( ( whole( police,      -6 )
                           , whole( sanitation, -11 )
                           , whole( fire,        -5 )
                           , newline
                           )
                         )
                FI
            FI
        OD
    OD
END
