BEGIN # find some steady squares - numbers whose squares end in the number    #
      # e.g. 376^2 = 141 376                                                  #
    INT max number    = 10 000; # maximum number we will consider             #
    INT power of ten := 10;
    []INT last digit = ( 1, 5, 6 );
    FOR n FROM 0 BY 10 TO max number DO
        IF n = power of ten THEN
            # the number of digits just increased                             #
            power of ten *:= 10
        FI;
        FOR d FROM LWB last digit TO UPB last digit DO
            INT nd = n + last digit[ d ];
            INT n2 = nd * nd;
            IF n2 MOD power of ten = nd THEN
                # have a steady square                                        #
                print( ( whole( nd, -5 ), "^2 = ", whole( n2, 0 ), newline ) )
            FI
        OD
    OD
END
