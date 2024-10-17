# S-Expressions #
CHAR nl = REPR 10;
# mode representing an S-expression #
MODE SEXPR = STRUCT( UNION( VOID, STRING, REF SEXPR ) element, REF SEXPR next );
# creates an initialises an SEXPR #
PROC new s expr = REF SEXPR: HEAP SEXPR := ( EMPTY, NIL );
# reports an error #
PROC error = ( STRING msg )VOID: print( ( "**** ", msg, newline ) );
# S-expression reader - reads and returns an S-expression from the string s #
PROC s reader = ( STRING s )REF SEXPR:
     BEGIN
        PROC at end      = BOOL: s pos > UPB s;
        PROC curr        = CHAR: IF at end THEN REPR 0 ELSE s[ s pos ] FI;
        PROC skip spaces = VOID: WHILE NOT at end AND ( curr = " " OR curr = nl ) DO s pos +:= 1 OD;
        PROC end of list = BOOL: at end OR curr = ")";
        INT s pos := LWB s;
        INT t pos;
        [ ( UPB s - LWB s ) + 1 ]CHAR token; # token text - large enough to hold the whole string if necessary #
        # adds the current character to the token #
        PROC add curr    = VOID: token[ t pos +:= 1 ] := curr;
        # get an s expression element from s #
        PROC get element = REF SEXPR:
             BEGIN
                REF SEXPR result = new s expr;
                skip spaces;
                # get token text #
                IF   at end THEN
                    # no element #
                    element OF result := EMPTY
                ELIF curr = "("  THEN
                    s pos +:= 1;
                    skip spaces;
                    IF NOT end of list
                    THEN
                        REF SEXPR nested expression = get element;
                        REF SEXPR element pos      := nested expression;
                        element OF result          := nested expression;
                        skip spaces;
                        WHILE NOT end of list
                        DO
                            element pos := next OF element pos := get element;
                            skip spaces
                        OD
                    FI;
                    IF curr = ")" THEN
                        s pos +:= 1
                    ELSE
                        error( "Missing "")""" )
                    FI
                ELIF curr = ")" THEN
                    s pos +:= 1;
                    error( "Unexpected "")""" );
                    element OF result := EMPTY
                ELSE
                    # quoted or unquoted string #
                    t pos := LWB token - 1;
                    IF curr /= """" THEN
                        # unquoted string #
                        WHILE add curr;
                              s pos +:= 1;
                              NOT at end AND curr /= " " AND curr /= "("
                                         AND curr /= ")" AND curr /= """"
                                         AND curr /= nl
                        DO SKIP OD
                    ELSE
                        # quoted string #
                        WHILE add curr;
                              s pos +:= 1;
                              NOT at end AND curr /= """"
                        DO SKIP OD;
                        IF curr /= """" THEN
                            # missing string quote #
                            error( "Unterminated string: <<" + token[ : t pos ] + ">>" )
                        ELSE
                            # have the closing quote #
                            add curr;
                            s pos +:= 1
                        FI
                    FI;
                    element OF result := token[ : t pos ]
                FI;
                result
             END # get element # ;

        REF SEXPR s expr = get element;
        skip spaces;
        IF NOT at end THEN
            # extraneuos text after the expression #
            error( "Unexpected text at end of expression: " + s[ s pos : ] )
        FI;

        s expr
     END # s reader # ;
# prints an S expression #
PROC s writer = ( REF SEXPR s expr )VOID:
     BEGIN
        # prints an S expression with a suitable indent #
        PROC print indented s expression = ( REF SEXPR s expression, INT indent )VOID:
             BEGIN
                REF SEXPR s pos := s expression;
                WHILE REF SEXPR( s pos ) ISNT REF SEXPR( NIL ) DO
                    TO indent DO print( ( " " ) ) OD;
                    CASE element OF s pos
                    IN  (VOID       ): print( ( "()", newline ) )
                     ,  (STRING    s): print( ( s,    newline ) )
                     ,  (REF SEXPR e): BEGIN
                                          print( ( "(", newline ) );
                                          print indented s expression( e, indent + 4 );
                                          TO indent DO print( ( " " ) ) OD;
                                          print( ( ")", newline ) )
                                      END
                    OUT
                        error( "Unexpected S expression element" )
                    ESAC;
                    s pos := next OF s pos
                OD
             END # print indented s expression # ;

        print indented s expression( s expr, 0 )
     END # s writer # ;
# test the eader and writer with the example from the task #
s writer( s reader( "((data ""quoted data"" 123 4.5)"
                  + nl
                  + " (data (!@# (4.5) ""(more"" ""data)"")))"
                  + nl
                  )
        )
