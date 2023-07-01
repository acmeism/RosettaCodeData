# This example uses ALGOL 68 user defined operators to add a COBOL-style     #
# "INSPECT statement" to ALGOL 68                                            #
#                                                                            #
# The (partial) syntax of the COBOL INSPECT is:                              #
#    INSPECT string-variable REPLACING ALL     string BY string              #
# or INSPECT string-variable REPLACING LEADING string BY string              #
# or INSPECT string-variable REPLACING FIRST   string BY string              #
#                                                                            #
# Because "BY" is a reserved bold word in ALGOL 68, we use "WITH" instead    #
#                                                                            #
# We define unary  operators INSPECT, ALL, LEADING and FIRST                 #
#       and binary operators REPLACING and WITH                              #
# We choose the priorities of REPLACING and WITH so that parenthesis is not  #
# needed to ensure the correct interpretation of the "statement"             #
#                                                                            #
# We also provide a unary DISPLAY operator for a partial COBOL DISPLAY       #
# statement                                                                  #

# INSPECTEE is returned by the INSPECT unary operator                        #
MODE INSPECTEE   = STRUCT( REF STRING item, INT option );

# INSPECTTOREPLACE is returned by the binary REPLACING operator              #
MODE INSPECTTOREPLACE
                 = STRUCT( REF STRING item, INT option, STRING to replace );
# REPLACEMENT is returned by the unary ALL, LEADING and FIRST operators      #
MODE REPLACEMENT = STRUCT( INT option, STRING replace );

# REPLACING option codes, these are the option values for a REPLACEMENT      #
INT  replace all     = 1;
INT  replace leading = 2;
INT  replace first   = 3;

OP   INSPECT   = ( REF STRING s )INSPECTEE: ( s, 0 );
OP   ALL       = ( STRING replace )REPLACEMENT: ( replace all,     replace );
OP   LEADING   = ( STRING replace )REPLACEMENT: ( replace leading, replace );
OP   FIRST     = ( STRING replace )REPLACEMENT: ( replace first,   replace );
OP   ALL       = ( CHAR   replace )REPLACEMENT: ( replace all,     replace );
OP   LEADING   = ( CHAR   replace )REPLACEMENT: ( replace leading, replace );
OP   FIRST     = ( CHAR   replace )REPLACEMENT: ( replace first,   replace );

OP   REPLACING = ( INSPECTEE inspected, REPLACEMENT replace )INSPECTTOREPLACE:
                     ( item    OF inspected
                     , option  OF replace
                     , replace OF replace
                     );

OP   WITH      = ( INSPECTTOREPLACE inspected, CHAR   replace with )REF STRING:
    BEGIN
        STRING with := replace with;
        inspected WITH with
    END; # WITH #

OP   WITH      = ( INSPECTTOREPLACE inspected, STRING replace with )REF STRING:
    BEGIN

        STRING    to replace  = to replace OF inspected;
        INT       pos        := 0;
        STRING    rest       := item OF inspected;
        STRING    result     := "";

        IF   option OF inspected = replace all
        THEN
            # replace all occurances of "to replace" with "replace with"     #
            WHILE string in string( to replace, pos, rest )
            DO
                result +:= rest[ 1 : pos - 1 ] + replace with;
                rest    := rest[ pos + UPB to replace : ]
            OD

        ELIF option OF inspected = replace leading
        THEN
            # replace leading occurances of "to replace" with "replace with" #
            WHILE IF string in string( to replace, pos, rest )
                  THEN
                      pos = 1
                  ELSE
                      FALSE
                  FI
            DO
                result +:= replace with;
                rest    := rest[ 1 + UPB to replace : ]
            OD

        ELIF option OF inspected = replace first
        THEN
            # replace first occurance of "to replace" with "replace with"    #
            IF string in string( to replace, pos, rest )
            THEN
                result +:= rest[ 1 : pos - 1 ] + replace with;
                rest    := rest[ pos + UPB to replace : ]
            FI

        ELSE
            # unsupported replace option #
            write( ( newline, "*** unsupported INSPECT REPLACING...", newline ) );
            stop
        FI;

        result +:= rest;
        item OF inspected := result
    END; # WITH #

OP   DISPLAY = ( STRING s )VOID: write( ( s, newline ) );


PRIO REPLACING = 2, WITH = 1;




main: (

    # test the INSPECT and DISPLAY "verbs" #

    STRING  text := "some text";
    DISPLAY text;

    INSPECT text REPLACING FIRST   "e"    WITH "bbc";
    DISPLAY text;

    INSPECT text REPLACING ALL     "b"    WITH "X";
    DISPLAY text;

    INSPECT text REPLACING ALL     "text" WITH "some";
    DISPLAY text;

    INSPECT text REPLACING LEADING "som"  WITH "k";
    DISPLAY text


)
