BEGIN # tropical algebra operator overloading #

    REAL minus inf = - max real;

    PROC real plus = ( REAL a, b )REAL: a + b;

    BEGIN
        PRIO  X = 7; # need to specify the precedence of a new dyadic #
                     # operator, X now has the same precedence as *   #
        OP    X = ( REAL a, b )REAL: real plus( a, b );
        OP    + = ( REAL a, b )REAL: IF a < b THEN b ELSE a FI;
        OP    ^ = ( REAL a, INT b )REAL:
            IF b < 1
            THEN print( ( "0 or -ve right operand for ""^""", newline ) ); stop
            ELSE a * b
            FI;
        # additional operators for integer operands                   #
        OP    X = ( INT a, REAL b )REAL: REAL(a) X      b;
        OP    X = ( REAL a, INT b )REAL: a       X REAL(b);
        OP    X = ( INT a,      b )REAL: REAL(a) X REAL(b);
        OP    + = ( INT a, REAL b )REAL: REAL(a) +      b;
        OP    + = ( REAL a, INT b )REAL: a       + REAL(b);
        OP    + = ( INT a,      b )REAL: REAL(a) + REAL(b);
        OP    ^ = ( INT a,      b )REAL: REAL(a) ^      b;
        # task test cases                                             #

        PROC check = ( REAL result, STRING expr, REAL expected )VOID:
             print( ( expr, IF result = expected THEN " is TRUE" ELSE " is FALSE ****" FI, newline ) );

        check( 2      X -2,        "2 (X) -2          = 0                  ",  0        );
        check( -0.001 + minus inf, "-0.001 (+) -Inf   = -0.001             ", -0.001    );
        check( 0      X minus inf, "0 (X) -Inf        = -Inf               ", minus inf );
        check( 1.5    + 1,         "1.5 (+) -1        = 1.5                ", 1.5       );
        check( -0.5   X 0,         "-0.5 (X) 0        = -0.5               ", -0.5      );
        print( ( "5 ^ 7: ", fixed( 5 ^ 7, -6, 1 ), newline ) );
        check( 5 X ( 8 + 7 ),      "5 (X) ( 8 (+) 7 ) = 5 (X) 8 (+) 5 (X) 7", 5 X 8 + 5 X 7 )
    END
END
