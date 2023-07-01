# RPN Expression evaluator - handles numbers and + - * / ^    #
#     the right-hand operand for ^ is converted to an integer #

# expression terminator #
CHAR end of expression character = REPR 12;

# evaluates the specified rpn expression #
PROC evaluate = ( STRING rpn expression )VOID:
BEGIN

    [ 256 ]REAL   stack;
    INT           stack pos := 0;

    # pops an element off the stack #
    PROC pop = REAL:
    BEGIN
        stack pos -:= 1;
        stack[ stack pos + 1 ]
    END; # pop #

    INT rpn pos := LWB rpn expression;

    # evaluate tokens from the expression until we get the end of expression #
    WHILE

        # get the next token from the string #

        STRING token type;
        REAL   value;

        # skip spaces #
        WHILE rpn expression[ rpn pos ] = " "
        DO
            rpn pos +:= 1
        OD;

        # handle the token #
        IF rpn expression[ rpn pos ] = end of expression character
        THEN
            # no more tokens #
            FALSE

        ELSE
            # have a token #

            IF  rpn expression[ rpn pos ] >= "0"
            AND rpn expression[ rpn pos ] <= "9"
            THEN
                # have a number #

                # find where the nmumber is in the expression #
                INT  number start = rpn pos;
                WHILE (   rpn expression[ rpn pos ] >= "0"
                      AND rpn expression[ rpn pos ] <= "9"
                      )
                   OR rpn expression[ rpn pos ] = "."
                DO
                    rpn pos +:= 1
                OD;

                # read the number from the expression #
                FILE number f;
                associate( number f
                         , LOC STRING := rpn expression[ number start : rpn pos - 1 ]
                         );
                get( number f, ( value ) );
                close( number f );

                token type := "number"

            ELSE
                # must be an operator #
                CHAR op      = rpn expression[ rpn pos ];
                rpn pos    +:= 1;

                REAL arg1   := pop;
                REAL arg2   := pop;
                token type  := op;

                value := IF   op = "+"
                         THEN
                             # add the top two stack elements #
                             arg1 + arg2
                         ELIF op = "-"
                         THEN
                             # subtract the top two stack elements #
                             arg2 - arg1
                         ELIF op = "*"
                         THEN
                             # multiply the top two stack elements #
                             arg2 * arg1
                         ELIF op = "/"
                         THEN
                             # divide the top two stack elements #
                             arg2 / arg1
                         ELIF op = "^"
                         THEN
                             # raise op2 to the power of op1 #
                             arg2 ^ ENTIER arg1
                         ELSE
                             # unknown operator #
                             print( ( "Unknown operator: """ + op + """", newline ) );
                             0
                         FI

            FI;

            TRUE
        FI
    DO
        # push the new value on the stack and show the new stack #

        stack[ stack pos +:= 1 ] := value;

        print( ( ( token type + "            " )[ 1 : 8 ] ) );
        FOR element FROM LWB stack TO stack pos
        DO
            print( ( " ", fixed( stack[ element ], 8, 4 ) ) )
        OD;
        print( ( newline ) )

    OD;

    print( ( "Result is: ", fixed( stack[ stack pos ], 12, 8 ), newline ) )

END; # evaluate #

main: (

    # get the RPN expresson from the user #

    STRING rpn expression;

    print( ( "Enter expression: " ) );
    read( ( rpn expression, newline ) );

    # add a space to terminate the final token and an expression terminator #
    rpn expression +:= " " + end of expression character;

    # execute the expression #
    evaluate( rpn expression )

)
