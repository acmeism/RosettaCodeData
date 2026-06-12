# Algol 68 pre-processor                                                      #
# Processes "read" pragmas in an Algol 68 upper stropping source              #
#    It is assumed _ is allowd in tags and bold words                         #
#    It is assumed that {} are alternatives for () as in ALGOL 68G            #
#       to use {} as ALGOL 68RS/algol68toc style nestable brief-comments,     #
#       change rs style brief comments to TRUE                                #
#    ALGOL 68G ( and probably other compilers ) allow quote-stropped bold     #
#       words to appear in an otherwise upper-stropped source,                #
#           e.g. BEGIN 'SKIP' END would be a valid program                    #
#       this is not supported here so pragmatic comments such as:             #
#       'PR' read "someFile" 'PR' will cause problems                         #
#    pragmatic comments should be disabled by PR pragmats off PR,             #
#       this is not implemented                                               #
#    the "read" must be in lower case                                         #
#    ALGOL 68G's read pragmatic comment only includes the file the first time #
#       it is mentioned in a read pragmatic comment - this is implemented     #
#       here by keeping a list of the included files - the list is limited to #
#       200 entries                                                           #
BEGIN

    # TRUE if {} delimits a nestable brief comment, as in ALGOL 68RS and      #
    #      algol68toc, FALSE if {} are alternatives to () as in ALGOL 68G     #
    BOOL rs style brief comments = FALSE;

    # input file information                                                  #
    MODE INFILE = STRUCT( REF FILE src         # actual source file           #
                        , STRING   line        # latest source line           #
                        , INT      pos         # character position in line   #
                        );
    # initialises the INFILE f to be associated with the FILE src             #
    PRIO INIT = 9;
    OP   INIT = ( REF FILE src, REF INFILE f )REF INFILE:
         BEGIN
            line OF f := "";
            pos  OF f := 1 + UPB line OF f;
            src  OF f := src;
            set eof handler( f );
            f
         END # INIT # ;
    # TRUE if EOF has been reached, FALSE otherwise                           #
    BOOL at eof := FALSE;
    CHAR c      := " ";
    # newline character                                                       #
    CHAR nl      = REPR 10;
    # maximum number of include files that can be nested                      #
    INT max include depth = 10;
    # source file stack                                                       #
    [ 0 : max include depth ]INFILE in stack;
    # current include depth                                                   #
    INT include depth := 0;
    # number of errors reported                                               #
    INT error count   := 0;
    # number of included files                                                #
    INT include count := 0;
    # names of previously included files                                      #
    [ 1 : 200 ]STRING included files;

    # sets the logical file end procedure of the specified file to a routine  #
    # that allows us to detect EOF on a source file                           #
    PROC set eof handler = ( REF INFILE fl )VOID:
         on logical file end( src OF fl
                            , ( REF FILE f )BOOL:
                              BEGIN
                                  # note that we reached EOF on the           #
                                  # latest read                               #
                                  IF NOT at eof
                                  THEN
                                      # first time we have spotted eof,       #
                                      # we need to call newline so that       #
                                      # if the last line didn't have a        #
                                      # newline at the end, it is still read  #
                                      # however that will call this routine   #
                                      # so we have to ensure we only do it    #
                                      # once                                  #
                                      at eof := TRUE;
                                      newline( f )
                                  FI;
                                  # return TRUE so processing can continue    #
                                  TRUE
                              END
                            );

    # reports an error                                                        #
    PROC error = ( STRING message )VOID:
         BEGIN
            error count +:= 1;
            print( ( newline, newline, "**** ", message, newline ) )
         END # error # ;
    # gets the next source character, handling end-of-file on include files   #
    # the source character is stored in c                                     #
    PROC next char = VOID:
         BEGIN
            WHILE
                BOOL read again := FALSE;
                REF INFILE s = in stack[ include depth ];
                IF pos OF s <= UPB line OF s THEN
                    # not past the end of the source line                     #
                    c := ( line OF s )[ pos OF s ];
                    pos OF s +:= 1
                ELIF
                    # past the end of the current source line - get the next  #
                    at eof := FALSE;
                    get( src OF s, ( line OF s, newline ) );
                    NOT at eof
                THEN
                    # got a new line                                          #
                    line OF s +:= nl;
                    pos  OF s  := LWB line OF s;
                    read again := TRUE
                ELIF include depth = 0 THEN
                    # eof on the main source                                  #
                    line OF s := ""
                ELSE
                    # got eof on an include file                              #
                    include depth -:= 1;
                    read again     := TRUE;
                    at eof         := FALSE;
                    close( src OF s )
                FI;
                read again
            DO SKIP OD
         END # next char # ;
    # returns TRUE if the current character is whitespace                     #
    PROC have whitespace = BOOL: c <= " ";
    # returns TRUE if the current character is a string delimiter             #
    PROC have string delimiter = BOOL: c = """";
    # returns TRUE if the current character can start a bold word             #
    PROC have bold = BOOL: c >= "A" AND c <= "Z";
    # returns TRUE if the current character can start a brief tag             #
    PROC have tag  = BOOL: c >= "a" AND c <= "z";
    # reports an unterminated construct ( e.g. string, comment )              #
    PROC unterminated = ( STRING construct )VOID:
         error( "Unterminated " + construct );
    # outputs ch to stand out                                                 #
    PROC out char = ( CHAR ch )VOID:
         IF ch = nl THEN print( ( newline ) ) ELSE print( ch ) FI;
    # outputs str to stand out                                                #
    PROC out string = ( STRING str )VOID: print( ( str ) );
    # outputs a brief comment to stand out                                    #
    #    end char is the closing delimiter,                                   #
    #    nested char is the opening delimiter for nestable brief comments     #
    #        if nested char is blank, the brief comment does not nest         #
    #    this handles ALGOL 68RS and algol68toc style {} comments             #
    PROC skip brief comment = ( CHAR end char, CHAR nested char )VOID:
         BEGIN
            out char( c );
            WHILE next char;
                  NOT at eof AND c /= end char
            DO
                IF c = nested char AND NOT have whitespace THEN
                    # nested brief comment                                    #
                    skip brief comment( end char, nested char )
                ELSE
                    # notmal comment char                                     #
                    out char( c )
                FI
            OD;
            IF at eof THEN
                # unterminated comment                                        #
                unterminated( """" + end char + """ comment" );
                c := end char
            FI;
            out char( c );
            next char
         END # skip brief comment # ;
    # gets a string of spaces from the source                                 #
    PROC get whitespace = STRING:
         BEGIN
            STRING result := "";
            WHILE NOT at eof AND have whitespace DO result +:= c; next char OD;
            result
         END # get whitespace # ;
    # gets a string denotation from the source                                #
    PROC in string = STRING:
         BEGIN
            STRING result := "";
            # within a string denotation, "" denotes the " character          #
            WHILE have string delimiter DO
                WHILE result +:= c;
                      next char;
                      NOT at eof AND NOT have string delimiter
                DO SKIP OD;
                IF NOT have string delimiter THEN
                    # unterminated string                                     #
                    unterminated( "string" );
                    c := """"
                FI;
                result +:= c;
                next char
            OD;
            result
         END # in string # ;
    # returns s unquoted                                                      #
    PROC unquote string = ( STRING s )STRING:
         BEGIN
            STRING result := "";
            # within a string denotation, "" denotes the " character          #
            INT c pos := LWB s + 1;
            WHILE cpos < UPB s DO
                CHAR ch = s[ c pos ];
                IF ch = """" THEN
                    # have an embedded quote - it will be doubled             #
                    c pos +:= 1
                FI;
                result +:= ch;
                c pos  +:= 1
            OD;
            result
         END # unquote string # ;
    # gets a bold word from then source                                       #
    PROC get bold word = STRING:
         BEGIN
            STRING result := "";
            WHILE have bold OR c = "_" DO result +:= c; next char OD;
            result
         END # get bold word # ;
    # geta a brief tag from the source                                        #
    PROC get tag = STRING:
         BEGIN
            STRING result := "" ;
            WHILE have tag OR c = "_" DO result +:= c; next char OD;
            result
         END # get tag # ;
    # copies the source to the output until a bold word is encountered        #
    PROC skip to bold = STRING:
         IF at eof
         THEN ""
         ELSE STRING result := "";
              WHILE out char( c );
                    next char;
                    NOT at eof
                AND NOT have bold
              DO SKIP OD;
              IF NOT at eof THEN result := get bold word FI;
              result
         FI # skip to bold # ;
    # handles a bold PRAGMA, COMMENT or other bold word                       #
    PROC bold word or pragment = VOID:
         IF STRING bold word := get bold word;
            bold word = "CO" OR bold word = "COMMENT"
         THEN
            # have a bold comment                                             #
            STRING delimiter = bold word;
            WHILE out string( bold word );
                  bold word := skip to bold;
                  NOT at eof
              AND bold word /= delimiter
            DO SKIP OD;
            IF at eof THEN
                # unterminated commant                                        #
                unterminated( """" + delimiter + """ comment" )
            FI;
            out string( delimiter )
         ELIF bold word = "PR" OR bold word = "PRAGMA"
         THEN
            # have a pragmatic comment - could be file inclusion              #
            STRING delimiter  = bold word;
            STRING pragment  := bold word;
            STRING op        := "";
            STRING file name := "";
            # skip spaces after the PR/PRAGMA                                 #
            pragment +:= get whitespace;
            # get the operation, if there is a tag                            #
            IF have tag THEN
                # have an operation                                           #
                op        := get tag;
                pragment +:= op + get whitespace
            FI;
            # get the file name, if there is one                              #
            IF have string delimiter THEN
                # have a file name                                            #
                file name := in string;
                pragment +:= file name + get whitespace;
                file name := unquote string( file name )
            FI;
            # should now have the closing delimiter                           #
            IF NOT have bold THEN
                # no bold word in/at-the-end-of the pragment                  #
                bold word := ""
            ELSE
                # have a bold word - could be the delimiter                   #
                pragment +:= ( bold word := get bold word )
            FI;
            IF op        /= "read"
            OR file name  = ""
            OR bold word /= delimiter
            THEN
                # not a read pragmatic comment                                #
                out string( pragment );
                IF bold word /= delimiter THEN
                    # haven't got the closing delimiter yet                   #
                    WHILE bold word := skip to bold;
                          NOT at eof
                      AND bold word /= delimiter
                    DO SKIP OD;
                    IF at eof THEN
                        # unterminated comment                                #
                        unterminated( """" + delimiter + """" )
                    FI;
                    out string( delimiter )
                FI
            ELIF # check for an already included file and add the name to     #
                 # the list if it hasn't been included before                 #
                 BOOL already included := FALSE;
                 FOR file pos TO include count
                 WHILE NOT ( already included := included files[ file pos ] = file name )
                 DO SKIP OD;
                 IF NOT already included THEN
                     # first time this file has been included                 #
                     # - add it to the list                                   #
                     IF include count < UPB included files THEN
                         # room to include this file                          #
                         included files[ include count +:= 1 ] := file name
                     ELSE
                         # too many include files                             #
                         error( "Too many include files: " + file name )
                     FI
                 FI;
                 already included
            THEN
                # the file is already included - the pragma should be ignored #
                SKIP
            ELIF
                # check the include file depth                                #
                include depth >= UPB in stack
            THEN
                # max include depth exceeded                                  #
                out string( pragment );
                error( "Include files nested too deply: " + file name )
            ELIF REF FILE inc = HEAP FILE;
                 open( inc, file name, stand in channel ) /= 0
            THEN
                # couldn't open the file                                      #
                out string( pragment );
                error( "Unable to include: " + file name )
            ELSE
                # file opened OK                                              #
                in stack[ include depth +:= 1 ] := inc INIT HEAP INFILE
            FI
         ELSE
            # some other bold word                                            #
            out string( bold word )
         FI # bold word or pragment # ;

    # copy the source to stand out, expanding read/incldue pragmas            #

    in stack[ include depth := 0 ] := stand in INIT HEAP INFILE;
    next char;
    WHILE NOT at eof DO
        IF   c = "#" THEN
            # brief comment                                                   #
            skip brief comment( "#", " " )
        ELIF c = "{" AND rs style brief comments THEN
            # nestable brief comment ( ALGOL 68RS and algol68toc )            #
            skip brief comment( "}", "{" )
        ELIF have string delimiter THEN
            # STRING or CHAR denotation                                       #
            out string( in string )
        ELIF have bold THEN
            # have a bold word                                                #
            bold word or pragment
        ELSE
            # anything else                                                   #
            out char( c );
            next char
        FI
    OD;

    IF error count > 0 THEN
        # had errors processing the source                                    #
        print( ( "**** ", whole( error count, 0 ), " errors", newline ) )
    FI

END
