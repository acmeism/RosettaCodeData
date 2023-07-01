BEGIN # determine which characters can be in identifiers, etc. by trying to  #
      # compile test programs                                                #

    STRING source name = "_tmp.a68";
    STRING a68 command = "a68 " + source name + " > _tmp.err 2>&1";

    # attenpts to compile the code with "%" substituted with id,             #
    #          returns 0 if it compiled OK, non-zero otherwise               #
    PROC attempt compilation = ( STRING template, id )INT:
         BEGIN
            STRING code := "";
            # replace "%" with the identifier in the template                #
            FOR t pos FROM LWB template TO UPB template DO
                code +:= IF   template[ t pos ] /= "%"
                         THEN template[ t pos ]
                         ELSE id
                         FI
            OD;
            # output the source file and try compiling it                    #
            FILE   source file;
            BOOL   open error := IF open( source file, source name, stand out channel ) = 0
                                 THEN
                                     # opened OK - file already exists and   #
                                     #             will be overwritten       #
                                     FALSE
                                 ELSE
                                     # failed to open the file               #
                                     # - try creating        a new file      #
                                     establish( source file, source name, stand out channel ) /= 0
                                 FI;
            IF open error
            THEN                                   # failed to open the file #
                print( ( "Unable to open ", source name, newline ) );
                stop
            ELSE                                            # file opened OK #
                put( source file, ( code ) );                 # write source #
                close( source file );
                system( a68 command )                           # compile it #
            FI
         END # attempt compilation # ;
    # attempt to construct all two-charaacter symbols and determine whether  #
    # they are valid by attempting to compile a program containing them      #
    # only 7-bit ASCII characters > space are considered                     #
    PROC try = ( STRING template, legend )VOID:
         BEGIN
            [ 0 : 127 ]BOOL first, second;
            FOR i FROM LWB first TO UPB first DO
                first[ i ] := second[ i ] := FALSE
            OD;
            FOR f FROM ABS " " + 1 TO UPB first DO
                CHAR fc = REPR f;
                IF attempt compilation( template, fc ) = 0
                THEN
                    # this character can be the first character of a symbol  #
                    first[ f ] := TRUE;
                    FOR s FROM ABS " " + 1 TO UPB second DO
                        IF NOT second[ s ]
                        THEN
                            # haven't found this is a valid second character #
                            # yet                                            #
                            IF attempt compilation( template, fc + REPR s ) = 0
                            THEN
                                # compiled OK                                #
                                second[ s ] := TRUE
                            FI
                        FI
                    OD
                FI
            OD;
            print( ( "Characters valid for ", legend, ":", newline ) );
            print( ( "    as first: " ) );
            FOR c pos FROM LWB first TO UPB first DO
                IF   first[ c pos ]
                THEN print( ( REPR c pos ) )
                ELIF second[ c pos ]
                THEN print( ( " " ) )
                FI
            OD;
            print( ( newline ) );
            print( ( "    as other: " ) );
            FOR c pos FROM LWB first TO UPB first DO
                IF   second[ c pos ]
                THEN print( ( REPR c pos ) )
                ELIF first[ c pos ]
                THEN print( ( " " ) )
                FI
            OD;
            print( ( newline ) )
         END # try # ;

    try( "BEGIN INT %; % := 1 END",                                "identifiers"       );
    try( "BEGIN OP % = ( INT a )INT: a; % 1 END",                  "monadic operators" );
    try( "BEGIN PRIO % = 5; OP % = ( INT a, b )INT: a; 1 % 1 END", "dyadic operators"  );
    try( "BEGIN MODE % = INT; % x; x := 1 END",                    "mode indicants"    )

END
