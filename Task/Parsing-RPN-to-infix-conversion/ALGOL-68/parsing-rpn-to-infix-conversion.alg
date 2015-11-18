# rpn to infix - parses an RPN expression and generates the equivalent        #
#               infix expression                                              #
PROC rpn to infix = ( STRING rpn )STRING:
BEGIN

    # we parse the string backwards using recursive descent                   #
    INT    rpn pos   := UPB rpn;
    BOOL   had error := FALSE;

    # mode to hold nodes of the parse tree                                    #
    MODE NODE = STRUCT( INT op
                      , UNION( REF NODE, STRING ) left
                      , REF NODE right
                      );

    REF NODE nil node = NIL;


    # op codes                                                                #
    INT error            = 1;
    INT factor           = 2;
    INT add              = 3;
    INT sub              = 4;
    INT mul              = 5;
    INT div              = 6;
    INT pwr              = 7;

    []STRING op name     = ( "error", "factor", "+", "-", "*", "/", "^" );
    []BOOL   right associative
                         = ( FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE );
    []INT    priority    = ( 1, 1, 2, 2, 3, 3, 4 );



    # returns TRUE  if we have reached the end of the rpn string,             #
    #         FALSE otherwise                                                 #
    PROC at end = BOOL: rpn pos < LWB rpn;

    # positions to the previous character, if there is one                    #
    PROC next = VOID: rpn pos -:= 1;

    # skip spaces in the rpn string                                           #
    PROC skip spaces = VOID:
        WHILE have( " " )
        DO
            next
        OD # skip spaces # ;

    # returns TRUE  if the rpn character at rpn pos is c,                     #
    #         FALSE if the character is not c or there is no character        #
    #               at rpn pos                                                #
    PROC have = ( CHAR c )BOOL:
        IF at end
        THEN
            # no character at rpn pos #
            FALSE
        ELSE
            # have a character - check it is the required one #
            rpn[ rpn pos ] = c
        FI # have # ;

    # gets an operand from the rpn string                                     #
    # an operand is either a number or a sub-expression                       #
    PROC get operand = ( STRING rpn, STRING operand name )REF NODE:
    BEGIN

        # handle the operator or operand, if there is one                     #

        skip spaces;

        print( ( ( "parsing "
                 + operand name
                 + " from: "
                 + IF at end THEN "" ELSE rpn[ LWB rpn : rpn pos ] FI
                 )
               , newline
               )
             );

        REF NODE result :=
            IF   at end
            THEN
                # no operand #
                had error       := TRUE;
                HEAP NODE       := ( error, "!! Missing operand !!", NIL )
            ELIF have( "+" )
            THEN
                # addition #
                next;
                HEAP NODE right := get operand( rpn, "+ right operand" );
                HEAP NODE left  := get operand( rpn, "+ left operand"  );
                HEAP NODE       := ( add, left, right )
            ELIF have( "-" )
            THEN
                # subtraction #
                next;
                HEAP NODE right := get operand( rpn, "- right operand" );
                HEAP NODE left  := get operand( rpn, "- left operand"  );
                HEAP NODE       := ( sub, left, right )
            ELIF have( "*" )
            THEN
                # multiplication #
                next;
                HEAP NODE right := get operand( rpn, "* right operand" );
                HEAP NODE left  := get operand( rpn, "* left operand"  );
                HEAP NODE       := ( mul, left, right )
            ELIF have( "/" )
            THEN
                # division #
                next;
                HEAP NODE right := get operand( rpn, "/ right operand" );
                HEAP NODE left  := get operand( rpn, "/ left operand"  );
                HEAP NODE       := ( div, left, right )
            ELIF have( "^" )
            THEN
                # exponentiation #
                next;
                HEAP NODE right := get operand( rpn, "^ right operand" );
                HEAP NODE left  := get operand( rpn, "^ left operand"  );
                HEAP NODE       := ( pwr, left, right )
            ELSE
                # must be an operand #
                STRING value := "";

                WHILE NOT at end
                  AND NOT have( " " )
                DO
                    rpn[ rpn pos ] +=: value;
                    next
                OD;

                HEAP NODE := ( factor, value, NIL )
            FI;

        print( ( operand name + ": " + TOSTRING result, newline ) );

        result
    END # get operand # ;


    # converts the parse tree to a string with apppropriate parenthesis       #
    OP TOSTRING = ( REF NODE operand )STRING:
    BEGIN

        # converts a node of the parse tree to a string, inserting            #
        # parenthesis if necessary                                            #
        PROC possible parenthesis = ( INT op, REF NODE expr )STRING:
            IF op OF expr = error
            OR op OF expr = factor
            THEN
                # operand is an error/factor - parenthisis not needed #
                TOSTRING expr
            ELIF priority( op OF expr ) < priority( op )
            THEN
                # the expression is a higher precedence operator than the     #
                # one we are building the expression for - need parenthesis   #
                ( "( " + TOSTRING expr + " )" )
            ELIF right associative[ op OF operand ]
             AND op OF left( operand ) = op OF operand
            THEN
                # right associative operator                                  #
                ( "( " + TOSTRING expr + " )" )
            ELSE
                # lower precedence expression - parenthesis not needed        #
                TOSTRING expr
            FI # possible parenthesis # ;

        # gets the left branch of a node, which must be a node                #
        PROC left  = ( REF NODE operand )REF NODE:
            CASE left OF operand
            IN ( REF NODE o ): o
            ,  ( STRING   s ): HEAP NODE := ( error, s, NIL )
            ESAC # left # ;

        IF   had error
        THEN
            # an error occured parsing the expression #
            "Invalid expression"
        ELIF operand IS nil node
        THEN
           # no operand? #
            "<empty>"
        ELIF op OF operand = error
          OR op OF operand = factor
        THEN
            # error parsing the expression #
            # or a factor #
            CASE left OF operand
            IN ( REF NODE o ): "Error: String expected: (" + TOSTRING o + ")"
            ,  ( STRING   s ): s
            ESAC
        ELSE
            # general operand #
            ( possible parenthesis( op OF operand, left(    operand ) )
            + " " + op name[ op OF operand ] + " "
            + possible parenthesis( op OF operand, right OF operand   )
            )
        FI
    END # TOSTRING # ;

    STRING result = TOSTRING get operand( rpn, "expression" );

    # ensure there are no more tokens in the string #
    skip spaces;
    IF at end
    THEN
        # OK - there was only one expression #
        result
    ELSE
        # extraneous tokens #
        ( "Error - unexpected text before expression: ("
        + rpn[ LWB rpn : rpn pos ]
        + ")"
        )
    FI
END # rpn to infix # ;



main: (

    # test the RPN to Infix comnverter                                        #
    STRING rpn;

    rpn := "3 4 2 * 1 5 - 2 3 ^ ^ / +";
    print( ( rpn, ":  ", rpn to infix( rpn ), newline, newline ) );

    rpn := "1 2 + 3 4 + ^ 5 6 + ^";
    print( ( rpn, ":  ", rpn to infix( rpn ), newline ) )

)
