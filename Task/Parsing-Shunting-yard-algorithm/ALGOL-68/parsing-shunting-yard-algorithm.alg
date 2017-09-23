BEGIN
    # parses s and returns an RPN expression using Dijkstra's "Shunting Yard" algorithm #
    # s is expected to contain a valid infix expression containing single-digit numbers and single-character operators #
    PROC parse = ( STRING s )STRING:
    BEGIN
        # add to the output #
        PROC output element = ( CHAR c )VOID:
        BEGIN
            output[ output pos +:= 1 ] := c;
            output pos +:= 1
        END # output element # ;
        PROC stack op = ( CHAR c )VOID: stack[ stack pos +:= 1 ] := c;
        # unstacks and returns the top operator on the stack - stops the program if the stack is empty #
        PROC unstack = CHAR:
            IF stack pos < 1 THEN
                # empty stack #
                print( ( "Stack underflow", newline ) );
                stop
            ELSE
                # still something on the stack to unstack #
                CHAR    result = stack[ stack pos ];
                stack[ stack pos ] := " ";
                stack pos         -:=  1;
                result
            FI # unstack # ;
        # returns the priority of the operator o - which must be one of "(", "^", "*", "/", "+" or "-" #
        PROC priority of = ( CHAR o )INT: IF o = "(" THEN -1 ELIF o = "^" THEN 4 ELIF o = "*" OR o = "/" THEN 3 ELSE 2 FI;
        # returns TRUE if o is a right-associative operator, FALSE otherwise #
        PROC right = ( CHAR c )BOOL: c = "^";
        PROC lower or equal priority = ( CHAR c )BOOL:
            IF stack pos < 1 THEN FALSE # empty stack #
            ELSE priority of( c ) <= priority of( stack[ stack pos ] )
            FI # lower or equal priority # ;
        PROC lower priority = ( CHAR c )BOOL:
            IF stack pos < 1 THEN FALSE # empty stack #
            ELSE priority of( c ) < priority of( stack[ stack pos ] )
            FI # lower priority # ;
        # max stack size and output size #
        INT    max stack = 32;
        # stack and output queue #
        [ 1 : max stack ]CHAR stack;
        [ 1 : max stack ]CHAR output;
        FOR c pos TO max stack DO stack[ c pos ] := output[ c pos ] := " " OD;
        # stack pointer and output queue pointer #
        INT    stack pos  := 0;
        INT    output pos := 0;
        print( ( "Parsing: ", s, newline ) );
        print( ( "token   output                               stack", newline ) );
        FOR s pos FROM LWB s TO UPB s DO
            CHAR c = s[ s pos ];
            IF c /= " " THEN
                IF c >= "0" AND c <= "9" THEN output element( c )
                ELIF c = "(" THEN stack op( c )
                ELIF c = ")" THEN
                    # close bracket - unstack to the matching "(" and unstack the "(" #
                    WHILE CHAR op char = unstack;
                          op char /= "("
                    DO
                        output element( op char )
                    OD
                ELIF right( c ) THEN
                    # right associative operator #
                    WHILE lower priority( c )          DO output element( unstack ) OD;
                    stack op( c )
                ELSE
                    # must be left associative #
                    WHILE lower or equal priority( c ) DO output element( unstack ) OD;
                    stack op( c )
                FI;
                print( ( c, "       ", output, "     ", stack, newline ) )
            FI
        OD;
        WHILE stack pos >= 1 DO output element( unstack ) OD;
        output[ 1 : output pos ]
    END # parse # ;

    print( ( "result: ", parse( "3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3" ), newline ) )
END
