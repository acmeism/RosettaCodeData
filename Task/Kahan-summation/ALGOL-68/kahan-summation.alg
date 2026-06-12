# Kahan summation - Algol 68 doesn't have a float decimal mode, however as    #
# only 6 digits of precision are required and assuming INT is 32 bits, we can #
# emulate this fairly easily                                                  #

# MODE DEC is a float decimal with 6 digits                                   #
# We normalise the mantissa so that the first digit is non-zero if            #
# the number is not 0                                                         #
# so e.g.  1 is represented as 100000 E0                                      #
#         10 is represented as 100000 E1                                      #
# etc.                                                                        #
# we only provide enough operations for the task                              #

MODE DEC = STRUCT( BOOL negative, INT mantissa, INT exponent );

# constructs a string representation of a DEC number                          #
OP TOSTRING = ( DEC number )STRING:
    IF mantissa OF number = 0
    THEN
        # number is zero #
        " 0.00000E +0"
    ELSE
        # non-zero number #
        STRING result = whole( mantissa OF number, 0 );
        ( IF negative OF number
          THEN
              # number is negative - show leading "-" sign #
              "-"
          ELSE
              # positive number - show leading space #
              " "
          FI
        + result[ 1 : 1 ]
        + "."
        + result[ 2 :   ]
        + "E"
        + whole( exponent OF number, 3 )
        )
    FI
;

# negates a DEC number                                                        #
OP - = ( DEC a )DEC: ( NOT negative OF a, mantissa OF a, exponent OF a );

# adds two DEC numbers                                                        #
OP + = ( DEC a, DEC b )DEC:
    IF exponent OF a < exponent OF b
    THEN
        # the left operand has a smaller exponent than the right,             #
        # reverse the operands                                                #
        b + a

    ELSE
        # the left operand's exponent is at least as big as the right's       #

        # removes a digit from a DEC number with rounding, the exponent is    #
        # unchanged                                                           #
        OP REDUCE = ( DEC ka )DEC: ( negative OF ka
                                   , ( ( mantissa OF ka OVER 10 )
                                       + IF mantissa OF ka MOD 10 > 4 THEN 1 ELSE 0 FI
                                     )
                                   , exponent OF ka
                                   );
        # adds an extra digit to a DEC number, exponent is unchanged          #
        OP EXTEND = ( DEC ka )DEC: ( negative OF ka, mantissa OF ka * 10, exponent OF ka );
        # signs the mantissa                                                  #
        OP APPLYSIGN = ( DEC ka )DEC:( FALSE
                                     , IF negative OF ka THEN - mantissa OF ka ELSE mantissa OF ka FI
                                     , exponent OF ka
                                     );
        # unsigns the mantissa and sets negative accordingly                  #
        OP EXTRACTSIGN = ( DEC ka )DEC: ( mantissa OF ka < 0, ABS ( mantissa OF ka ), exponent OF ka );

        # give each number an extra digit                                     #
        DEC result  := EXTEND a;
        DEC operand := EXTEND b;

        # scale the values so that they have the same exponent                #

        WHILE exponent OF operand < exponent OF result
        DO
            operand := REDUCE operand;
            exponent OF operand PLUSAB 1
        OD;

        # sign the mantissas                                                  #
        result  := APPLYSIGN result;
        operand := APPLYSIGN operand;

        # add                                                                 #
        mantissa OF result PLUSAB mantissa OF operand;

        # remove the extra digit, round and unsign the mantissa               #
        result := REDUCE EXTRACTSIGN result;

        # if the mantissa is < 100000 and not 0, increase the mantissa and    #
        # reduce the exponent so that the first digit is not 0                #
        IF mantissa OF result /= 0
        THEN
            # non-zero mantissa - scale if necessary                          #
            WHILE mantissa OF result < 100000
            DO
                mantissa OF result TIMESAB 10;
                exponent OF result MINUSAB  1
            OD
        FI;

        result

    FI # + #
;

# subtracts two DEC numbers                                                   #
OP - = ( DEC a, DEC b )DEC: a + ( - b );

# performs Kahan summation on an array of DEC numbers                         #
# The numbers must be ordered highest to lowest                               #
# Algorithm as per the Wikipaedia page, except we start with sum              #
# set to the first element of the list, not 0                                 #
OP KAHANSUM = ( []DEC a )DEC:
    BEGIN

        DEC sum := a[LWB a];
        DEC c   := ( FALSE, 0, 0 );

        FOR i FROM LWB a + 1 TO UPB a
        DO
            DEC y := a[i] - c;
            DEC t := sum + y;
            c     := ( t - sum ) - y;
            sum   := t
        OD;

        sum
    END # KAHANSUM #
;

# test the Kahan summation and 6 digit decimal floating point                 #
BEGIN

    # construct DEC values a = 10000.0, b = 3.14159, c = 2.71828              #

    DEC a := ( FALSE, 100000, 4 );
    DEC b := ( FALSE, 314159, 0 );
    DEC c := ( FALSE, 271828, 0 );

    # simple sum #
    print( ( "Simple: ", TOSTRING a, " + ", TOSTRING b, " + ", TOSTRING c, " = ", TOSTRING ( ( a + b ) + c )
           , newline
           )
         );
    # Kahan #
    []DEC list = ( a, b, c );
    print( ( "Kahan : ", TOSTRING a, " + ", TOSTRING b, " + ", TOSTRING c, " = ", TOSTRING KAHANSUM list
           , newline
           )
         )
END
