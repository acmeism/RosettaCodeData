BEGIN
    # MODE that can hold integers and strings - would need to be extended to #
    # allow for other types                                                  #
    MODE INTORSTRING = UNION( INT, STRING );
    # returns TRUE if a is an INT, FALSE otherwise #
    OP   ISINT    = ( INTORSTRING a )BOOL:   CASE a IN (INT):      TRUE OUT FALSE ESAC;
    # returns TRUE if a is an INT, FALSE otherwise #
    OP   ISSTRING = ( INTORSTRING a )BOOL:   CASE a IN (STRING):   TRUE OUT FALSE ESAC;
    # returns the integer in a or 0 if a isn't an integer #
    OP   TOINT    = ( INTORSTRING a )INT:    CASE a IN (INT i):    i    OUT 0     ESAC;
    # returns the string in a or "" if a isn't a string #
    OP   TOSTRING = ( INTORSTRING a )STRING: CASE a IN (STRING s): s    OUT ""    ESAC;
    # returns TRUE if a < b, FALSE otherwise #
    # a and b must have the same type #
    PRIO LESSTHAN = 4;
    OP   LESSTHAN = ( INTORSTRING a, b )BOOL:
        IF  ISSTRING a AND ISSTRING b THEN
            # both strings #
            TOSTRING a < TOSTRING b
        ELIF ISINT a AND ISINT b THEN
            # both integers #
            TOINT a < TOINT b
        ELSE
            # different MODEs #
            FALSE
        FI # LESSTHAN # ;
    # exchanges the values of a and b #
    PRIO SWAP = 9;
    OP   SWAP = ( REF INTORSTRING a, b )VOID: BEGIN INTORSTRING t := a; a := b; b := t END;
    # sorts a, b and c #
    PROC sort 3 = ( REF INTORSTRING a, b, c )VOID:
    BEGIN
        IF b LESSTHAN a THEN a SWAP b FI;
        IF c LESSTHAN a THEN a SWAP c FI;
        IF c LESSTHAN b THEN b SWAP c FI
    END # sort 3 # ;

    # task test cases #
    INTORSTRING x, y, z;
    x := "lions, tigers, and";
    y := "bears, oh my!";
    z := "(from the ""Wizard of OZ"")";
    sort 3( x, y, z );
    print( ( x, newline, y, newline, z, newline ) );
    x := 77444;
    y := -12;
    z := 0;
    sort 3( x, y, z );
    print( ( x, newline, y, newline, z, newline ) )
END
