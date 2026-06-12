BEGIN # implements packed BCD arithmetic                                     #
    INT x99 = ( 9 * 16 ) + 9;           # maximum unsigned 2-digit BCD value #
    # structure to hold BCD values                                           #
    MODE BCD = STRUCT( INT  value           # BCD value - signed -x99 to x99 #
                     , BOOL carry           # TRUE if the value overflowed,  #
                     );                     # FALSE otherwise                #

    # constructs a BCD value from a, assuming it is in the correct format    #
    # if the value has overflowed, it is truncated to a valid value and      #
    # carry is set                                                           #
    OP ASBCD    = ( INT a )BCD:
       BEGIN
           INT  v    := ABS a;
           BOOL carry = v > x99;
           IF carry THEN
               v := ( ( ( v OVER 16 ) MOD 10 ) * 16 ) + ( v MOD 16 )
           FI;
           BCD( v * SIGN a, carry )
       END # ASBCD # ;
    # returns a converted to BCD format, truncating and setting carry        #
    #         if necessary                                                   #
    OP TOBCD    = ( INT a )BCD:
       IF a < 0
       THEN - TOBCD ABS a
       ELSE BCD( ( ( ( a OVER 10 ) MOD 10 ) * 16 ) + ( a MOD 10 ), a > x99 )
       FI # TOBCD # ;

    BCD  bcd 99 = TOBCD 99;
    BCD  bcd 1  = TOBCD  1;

    # returns a two-digit string representation of the BCD value a           #
    OP TOSTRING = ( BCD a )STRING: IF value OF a < 0 THEN "-" ELSE "" FI
                                 + whole( ABS value OF a OVER 16, 0 )
                                 + whole( ABS value OF a MOD  16, 0 )
                                 ;
    # returns a string representation of the row of BCD values in a          #
    #         assumes the most significant digits are in a[ LWB a ]          #
    OP TOSTRING = ( []BCD a )STRING:
       BEGIN
            STRING result := "";
            FOR b pos FROM LWB a TO UPB a DO result +:= TOSTRING a[ b pos ] OD;
            result
       END # TOSTRING # ;
    # returns the sum of a and b, a and b can be positive or negative        #
    #         the result is always positive, if it would be negative, it is  #
    #         tens complemented                                              #
    OP +        = ( BCD a, b )BCD:
       BEGIN
            INT  av = ABS value OF a,      bv = ABS value OF b;
            BOOL ap =     value OF a >= 0, bp =     value OF b >= 0;
            INT  a2 = av MOD 16,           b2 = bv MOD 16;
            INT bcd value =
                IF   ap = bp
                THEN # both positive or both negative                        #
                    INT result := av + bv;
                    IF a2 + b2 > 9 THEN result +:= 6 FI;
                    IF ap THEN result ELSE - result FI
                ELIF av >= bv
                THEN # different signs, magnitude of a at least that of b    #
                    INT result := av - bv;
                    IF a2 < b2 THEN result -:= 6 FI;
                    IF ap THEN result ELSE - result FI
                ELSE # different signs, magnitude of a less than that of b   #
                    INT result := bv - av;
                    IF b2 < a2 THEN result -:= 6 FI;
                    IF ap THEN - result ELSE - result FI
                FI;
            IF bcd value >= 0 THEN # result is positive                      #
                ASBCD bcd value
            ELSE                   # result is negative - tens complement    #
                BCD result := ( bcd 99 + ASBCD bcd value ) + bcd 1;
                carry OF result := TRUE;
                result
            FI
       END # + # ;
    # returns the value of b negated, carry is preserved                     #
    OP -        = ( BCD a )BCD: BCD( - value OF a, carry OF a );
    # returns the difference of a and b, a and b can be positive or negative #
    OP -        = ( BCD a, b )BCD: a + - b;
    # adds b to a and resurns a                                              #
    OP +:=      = ( REF BCD a, BCD b )REF BCD: a := a + b;
    # subtracts b from a and resurns a                                       #
    OP -:=      = ( REF BCD a, BCD b )REF BCD: a := a - b;

    # task test cases                                                        #
    print( ( TOSTRING ( TOBCD 19 + bcd 1 ), newline ) );
    print( ( TOSTRING ( TOBCD 30 - bcd 1 ), newline ) );
    BCD r = TOBCD 99 + bcd 1;
    print( ( IF carry OF r THEN "1" ELSE "" FI, TOSTRING r, newline ) );
    print( ( newline ) );

    # use the 2-digit BCD to add/subtract larger numbers                     #
    [ 1 : 6 ]BCD d12 :=
         ( TOBCD  1, TOBCD 23, TOBCD 45, TOBCD 67, TOBCD 89, TOBCD 01 );
    []BCD        a12  =
         ( TOBCD  1, TOBCD 11, TOBCD 11, TOBCD 11, TOBCD 11, TOBCD 11 );
    TO 10 DO                                     # repeatedly add s12 to d12 #
        print( ( TOSTRING d12, " + ", TOSTRING a12, " = " ) );
        BOOL carry := FALSE;
        FOR b pos FROM UPB d12 BY -1 TO LWB d12 DO
            d12[ b pos ] +:= a12[ b pos ];
            BOOL need carry = carry OF d12[ b pos ];
            IF carry THEN d12[ b pos ] +:= bcd 1 FI;
            carry := need carry OR carry OF d12[ b pos ]
        OD;
        print( ( TOSTRING d12, newline ) )
    OD;
    TO 10 DO                              # repeatedly subtract a12 from d12 #
        print( ( TOSTRING d12, " - ", TOSTRING a12, " = " ) );
        BOOL carry := FALSE;
        FOR b pos FROM UPB d12 BY -1 TO LWB d12 DO
            d12[ b pos ] -:= a12[ b pos ];
            BOOL need carry = carry OF d12[ b pos ];
            IF carry THEN d12[ b pos ] -:= bcd 1 FI;
            carry := need carry OR carry OF d12[ b pos ]
        OD;
        print( ( TOSTRING d12, newline ) )
    OD

END
