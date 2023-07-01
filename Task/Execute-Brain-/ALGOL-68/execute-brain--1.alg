BEGIN # Brain**** -> Algol 68 transpiler #
      # a single line of Brain**** code is prompted for and read from #
      # standard input, the generated code is written to standard output #
      # the original code is included in the output as a comment #

    # transpiles the Brain**** code in code list to Algol 68 #
    PROC generate = ( STRING code list )VOID:
    BEGIN

        PROC emit  = ( STRING code )VOID: print( ( code, newline ) );
        PROC emit1 = ( STRING code )VOID:
             print( ( IF need semicolon THEN ";" ELSE "" FI
                    , newline, indent, code
                    )
                  );
        PROC next  = CHAR: IF   c pos > c max
                           THEN "$"
                           ELSE CHAR result = code list[ c pos ];
                                c pos +:= 1;
                                result
                           FI;

        # address and data modes and the data space #
        emit( "BEGIN" );
        emit( "  MODE DADDR = INT; # data address #" );
        emit( "  MODE DATA  = INT;" );
        emit( "  DATA zero  = 0;" );
        emit( "  [-255:255]DATA data;  # finite data space #" );
        emit( "  FOR i FROM LWB data TO UPB data DO data[i] := zero OD;" );
        emit( "  DADDR addr := ( UPB data + LWB data ) OVER 2;" );

        # actual code #

        STRING indent         := "  ";
        BOOL   need semicolon := FALSE;
        INT    c pos          := LWB code list;
        INT    c max           = UPB code list;
        CHAR   c              := next;
        WHILE c /= "$" DO
            IF   c = "?"
            THEN emit1( "SKIP" );
                 need semicolon := TRUE;
                 WHILE ( c := next ) = "?" DO SKIP OD
            ELIF c = "<" OR c = ">"
            THEN CHAR op code   = c;
                 CHAR assign op = IF c = ">" THEN "+" ELSE "-" FI;
                 INT incr      := 1;
                 WHILE ( c := next ) = op code DO incr +:= 1 OD;
                 emit1( "addr " + assign op + ":= " + whole( incr, 0 ) );
                 need semicolon := TRUE
            ELIF c = "+" OR c = "-"
            THEN CHAR op code   = c;
                 INT incr      := 1;
                 WHILE ( c := next ) = op code DO incr +:= 1 OD;
                 emit1( "data[ addr ] " + op code + ":= " + whole( incr, 0 ) );
                 need semicolon := TRUE
            ELIF c = "."
            THEN emit1( "print( ( REPR data[ addr ] ) )" );
                 need semicolon := TRUE;
                 c              := next
            ELIF c = ","
            THEN emit1( "data[ addr ] := ABS read char" );
                 need semicolon := TRUE;
                 c              := next
            ELIF c = "["
            THEN emit1( "WHILE data[ addr ] /= zero DO" );
                 indent        +:= "  ";
                 need semicolon := FALSE;
                 c              := next
            ELIF c = "]"
            THEN need semicolon := FALSE;
                 indent         := indent[ LWB indent + 2 : ];
                 emit1( "OD" );
                 need semicolon := TRUE;
                 c              := next
            ELSE
                 print( ( "Invalid op code: """, c, """", newline ) );
                 c              := next
            FI
        OD;
        emit( "" );
        emit( "END" )

    END # gen # ;

    # get the code to transpile and output it as a comment at the start #
    # of the code #
    print( ( "CO BF> " ) );
    STRING code list;
    read( ( code list, newline ) );
    print( ( newline, code list, newline, "CO", newline ) );
    # transpile the code #
    generate( code list )


END
