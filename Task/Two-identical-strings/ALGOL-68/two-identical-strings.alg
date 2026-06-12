BEGIN # show the decimal and binary representations of numbers that are of the concatenation of #
      # two identical binary strings                                                            #
    # returns a binary representation of v #
    OP TOBINSTRING = ( INT v )STRING:
       IF v = 0 THEN "0"
       ELSE
            STRING result := "";
            INT rest := v;
            WHILE rest > 0 DO
                IF ODD rest THEN "1" ELSE "0" FI +=: result;
                rest OVERAB 2
            OD;
            result
       FI # TOBINSTRING # ;
    INT power of 2 := 1;
    FOR b WHILE IF b = power of 2 THEN
                    power of 2 *:= 2
                FI;
                INT cat value = ( b * power of 2 ) + b;
                cat value < 1000
    DO
        print( ( whole( cat value, -4 ), ": ", TOBINSTRING cat value, newline ) )
    OD
END
