BEGIN # find elements of the Klarner-Rado sequence                           #
      #    - if n is an element, so are 2n + 1 and 3n + 1                    #
    INT max element = 100 000 000;
    [ 0 : max element ]BOOL kr; FOR i FROM LWB kr TO UPB kr DO kr[ i ] := FALSE OD;
    INT n21      := 3;                    # next 2n+1 value                  #
    INT n31      := 4;                    # next 3n+1 value                  #
    INT p2       := 1;                    # the n for the next 2n+1 value    #
    INT p3       := 1;                    # the n for the next 3n+1 value    #
    kr[ 1 ]      := TRUE;
    INT kr count := 0;
    INT max count = 1 000 000;
    FOR i WHILE kr count < max count DO
        IF i = n21 THEN                   # found the next 2n+1 value        #
            IF kr[ p2 ] THEN
                kr[ i ] := TRUE
            FI;
            p2  +:= 1;
            n21 +:= 2
        FI;
        IF i = n31 THEN                   # found the next 3n+1 value        #
            IF kr[ p3 ] THEN
                kr[ i ] := TRUE
            FI;
            p3  +:= 1;
            n31 +:= 3
        FI;
        IF kr[ i ] THEN
            kr count +:= 1;
            IF   kr count <= 100 THEN
                print( ( " ", whole( i, -3 ) ) );
                IF kr count MOD 20 = 0 THEN print( ( newline ) ) FI
            ELIF kr count =     1 000 THEN
                print( ( "The     thousandth element is ", whole( i, -8 ), newline ) )
            ELIF kr count =    10 000 THEN
                print( ( "The ten thousandth element is ", whole( i, -8 ), newline ) )
            ELIF kr count =   100 000 THEN
                print( ( "The 100-thousandth element is ", whole( i, -8 ), newline ) )
            ELIF kr count = 1 000 000 THEN
                print( ( "The      millionth element is ", whole( i, -8 ), newline ) )
            FI
        FI
    OD
END
