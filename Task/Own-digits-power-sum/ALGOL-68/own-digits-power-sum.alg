BEGIN
    # counts of used digits, check is a copy used to check the number is an own digit power sum #
    [ 0 : 9 ]INT used, check; FOR i FROM 0 TO 9 DO check[ i ] := 0 OD;
    [ 1 : 9, 1 : 9 ]LONG INT power;     # table of digit powers       #
    FOR i TO 9 DO power[ 1, i ] := i OD;
    FOR j FROM 2 TO 9 DO
        FOR i TO 9 DO power[ j, i ] := power[ j - 1, i ] * i OD
    OD;
    # find the lowest possible first digit for each digit combination #
    # this is the roughly the low3est n where P*n^p > 10^p            #
    [ 1 : 9 ]INT lowest digit;
    lowest digit[ 2 ] := lowest digit[ 1 ] := -1;
    LONG INT p10 := 100;
    FOR i FROM 3 TO 9 DO
        FOR p FROM 2 TO 9 WHILE LONG INT np = power[ i, p ] * i;
                                np < p10 DO
            lowest digit[ i ] := p
        OD;
        p10 *:= 10
    OD;
    # find the maximum number of zeros possible for each width and max digit #
    [ 1 : 9, 1 : 9 ]INT max zeros; FOR i TO 9 DO FOR j TO 9 DO max zeros[ i, j ] := 0 OD OD;
    p10 := 1000;
    FOR w FROM 3 TO 9 DO
        FOR d FROM lowest digit[ w ] TO 9 DO
            INT nz := 9;
            WHILE IF nz < 0
                  THEN FALSE
                  ELSE LONG INT np := power[ w, d ] * nz;
                       np > p10
                  FI
            DO
                nz -:= 1
            OD;
            max zeros[ w, d ] := IF nz > w THEN 0 ELSE w - nz FI
        OD;
        p10 *:= 10
    OD;
    # find the numbers, works backeards through the possible combinations of  #
    # digits, starting from all 9s                                            #
    [ 1 : 100 ]LONG INT numbers;  # will hold the own digit power sum numbers #
    INT n count   := 0;           # count of the own digit power sums         #
    INT try count := 0;           # count of digit combinations tried         #
    [ 1 : 9 ]INT digits;          # the latest digit combination to try       #
    FOR d        TO 9 DO digits[ d ] := 9 OD;
    FOR d FROM 0 TO 8 DO used[   d ] := 0 OD; used[ 9 ] := 9;
    INT width     := 9;           # number of digits                          #
    INT last      := width;       # final digit position                      #
    p10           := 100 000 000; # min value for a width digit power sum     #
    WHILE width > 2 DO
        try count   +:= 1;
        LONG INT dps := 0;        # construct the digit power sum             #
        check        := used;
        FOR i TO 9 DO
            IF used[ i ] /= 0 THEN dps +:= used[ i ] * power[ width, i ] FI
        OD;
        # reduce the count of each digit by the number of times it appear in the digit power sum #
        LONG INT n := dps;
        WHILE check[ SHORTEN ( n MOD 10 ) ] -:= 1; # reduce the count of this digit #
              ( n OVERAB 10 ) > 0
        DO SKIP OD;
        BOOL reduce width := dps <= p10;
        IF NOT reduce width THEN
            # dps is not less than the minimum possible width number          #
            # check there are no non-zero check counts left and so result is  #
            # equal to its digit power sum                                    #
            INT z count := 0;
            FOR i FROM 0 TO 9 WHILE check[ i ] = 0 DO z count +:= 1 OD;
            IF z count = 10 THEN
                numbers[ n count +:= 1 ] := dps
            FI;
            # prepare the next digit combination: reduce the last digit #
            used[ digits[ last ] ] -:= 1;
            digits[ last ]         -:= 1;
            IF digits[ last ] = 0 THEN
                # the last digit is now zero - check this number of zeros is possible #
                IF used[ 0 ] >= max zeros[ width, digits[ 1 ] ] THEN
                    # have exceeded the maximum number of zeros for the first digit in this width #
                    digits[ last ] := -1
                FI
            FI;
            IF digits[ last ] >= 0 THEN
                # still processing the last digit #
                used[ digits[ last ] ] +:= 1
            ELSE
                # last digit is now -1, start processing the previous digit #
                INT prev := last;
                WHILE IF ( prev -:= 1 ) < 1
                      THEN # processed all digits #
                          FALSE
                      ELSE
                          # have another digit #
                          used[ digits[ prev ] ] -:= 1;
                          digits[ prev ]         -:= 1;
                          digits[ prev ] < 0
                      FI
                DO SKIP OD;
                IF prev > 0 THEN
                    # still some digits to process #
                    IF prev = 1 THEN
                        IF digits[ 1 ] <= lowest digit[ width ] THEN
                            # just finished the lowest possible maximum digit for this width #
                            prev := 0
                        FI
                    FI;
                    IF prev /= 0 THEN
                        # OK to try a lower digit #
                        used[ digits[ prev ] ] +:= 1;
                        FOR i FROM prev + 1 TO width DO
                            digits[ i ] := digits[ prev ];
                            used[ digits[ prev ] ] +:= 1
                        OD
                    FI
                FI;
                IF prev <= 0 THEN
                    # processed all the digits for this width #
                    reduce width := TRUE
                FI
            FI
        FI;
        IF reduce width THEN
            # reduce the number of digits #
            width   := last -:= 1;
            IF last > 0 THEN
                # iniialise for fewer digits #
                FOR d               TO last DO digits[ d ] :=  9 OD;
                FOR d FROM last + 1 TO 9    DO digits[ d ] := -1 OD;
                FOR d FROM        0 TO 9    DO used[   d ] :=  0 OD;
                used[ 9 ] := last;
                p10   OVERAB 10
            FI
        FI
    OD;
    # show the own digit power sums #
    print( ( "Own digits power sums for N = 3 to 9 inclusive:", newline ) );
    FOR i FROM n count BY -1 TO LWB numbers DO
        print( ( whole( numbers[ i ], 0 ), newline ) )
    OD;
    print( ( "Considered ", whole( try count, 0 ), " digit combinations" ) )
END
