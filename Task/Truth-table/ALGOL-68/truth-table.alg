# prints the truth table of a boolean expression composed of the 26 lowercase variables a..z, #
# the boolean operators AND, OR, XOR and NOT and the literal values TRUE and FALSE            #
# The evaluation is done with the Algol 68G evaluate function which is an extension           #
PROC print truth table = ( STRING expr )VOID:
     BEGIN

        # recursively prints the truth table #
        PROC print line = ( INT lv )VOID:
             IF lv > UPB bv
             THEN
                 # at the end of the variables - print the line #
                 FOR le TO UPB bv DO
                     IF used[ le ] THEN print( ( " ", bv[ le ], " " ) ) FI
                 OD;
                 print( ( "     ", evaluate( expr ), newline ) )
             ELIF used[ lv ]
             THEN
                 # have another variable #
                 bv[ lv ] := TRUE;
                 print line( lv + 1 );
                 bv[ lv ] := FALSE;
                 print line( lv + 1 )
             ELSE
                 # this variable is not used #
                 print line( lv + 1 )
             FI # print line # ;

        # returns the name of the variable number #
        PROC variable name = ( INT number )CHAR: REPR ( number + ( ABS "a" - 1 ) );

        # the 26 boolean variables #
        BOOL a := FALSE, b := FALSE, c := FALSE, d := FALSE, e := FALSE, f := FALSE;
        BOOL g := FALSE, h := FALSE, i := FALSE, j := FALSE, k := FALSE, l := FALSE;
        BOOL m := FALSE, n := FALSE, o := FALSE, p := FALSE, q := FALSE, r := FALSE;
        BOOL s := FALSE, t := FALSE, u := FALSE, v := FALSE, w := FALSE, x := FALSE;
        BOOL y := FALSE, z := FALSE;
        # table of the variables allowng access by number #
        []REF BOOL bv = ( a, b, c, d, e, f, g, h, i, j, k, l, m
                        , n, o, p, q, r, s, t, u, v, w, x, y, z
                        );
        [ 26 ]BOOL used;
        BOOL at least one variable := FALSE;
        # determine which variables are used in the expression #
        FOR iv TO UPB bv DO
            used[ iv ] := char in string( variable name( iv ), NIL, expr );
            IF used[ iv ]THEN at least one variable := TRUE FI
        OD;
        # print truth table headings #
        print( ( expr, ":", newline ) );
        FOR iv TO UPB bv DO
            IF used[ iv ] THEN print( ( " ", variable name( iv ), " " ) ) FI
        OD;
        print( ( " value", newline ) );
        FOR iv TO UPB bv DO
            IF used[ iv ] THEN print( ( " - " ) ) FI
        OD;
        print( ( " -----", newline ) );
        # evaluate the expression for each cobination of variables #
        IF at least one variable
        THEN
             # the expression does not consist of literals only #
             FOR iv TO UPB bv DO bv[ iv ] := FALSE OD;
             print line( LWB bv )
        ELSE
             # the expression is constant #
             print( ( "     ", evaluate( expr ), newline ) )
        FI
     END # print truth table # ;

# print truth tables from the user's expressions #
print( ( "Please enter Boolean expressions using variables a, b, c, ..., z,",                  newline ) );
print( ( "operators AND, OR, NOT and XOR and literals TRUE and FALSE",                         newline ) );
print( ( "(Note operators and TRUE/FALSE must be uppercase and variables must be lower case)", newline ) );
print( ( "Enter a blank line to quit",                                                         newline ) );
WHILE
    STRING expr;
    print( ( "expression> " ) );
    read( ( expr, newline ) );
    expr /= ""
DO
    print truth table( expr )
OD
