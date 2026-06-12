BEGIN # convert lines of CSV to TSV #
    CHAR nul = REPR  0;
    CHAR tab = REPR  9;
    CHAR lf  = REPR 10;
    CHAR cr  = REPR 13;
    # returns s with some control characters converted to <name> #
    PROC show ctrl = ( STRING s )STRING:
         BEGIN
            STRING result := "";
            FOR i FROM LWB s TO UPB s DO
                result +:= IF   s[ i ] = nul THEN "<nul>"
                           ELIF s[ i ] = tab THEN "<tab>"
                           ELIF s[ i ] = cr  THEN "<cr>"
                           ELIF s[ i ] = lf  THEN "<lf>"
                           ELSE s[ i ]
                           FI
            OD;
            result
         END # show ctrl # ;
    # returns csv converted to TSV #
    PROC csv2tsv = ( STRING csv )STRING:
         BEGIN
             BOOL at end := FALSE;
             CHAR ch     := nul;
             # sets ch to the next character in csv, if there is one #
             PROC next = VOID: ch := IF   c pos < c max
                                     THEN csv[ c pos +:= 1 ]
                                     ELSE at end := TRUE
                                        ; nul
                                     FI;
             # skips over spaces and returns the count of skipped spaces #
             PROC spaces = INT:
                  BEGIN
                     INT s count := 0;
                     WHILE NOT at end AND ch = " " DO s count +:= 1; next OD;
                     s count
                  END # spaces # ;
             # adds ch to the TSV - converting some characters to escaped form #
             PROC add = VOID: tsv +:= IF   ch = "\" THEN "\\"
                                      ELIF ch = nul THEN "\0"
                                      ELIF ch = cr  THEN "\r"
                                      ELIF ch = lf  THEN "\n"
                                      ELIF ch = tab THEN "\t"
                                      ELSE ch
                                      FI;
             # parse the csv and generate the tsv #
             STRING tsv := "";
             INT  c pos := LWB csv - 1;
             INT  c max  = UPB csv;
             WHILE NOT at end DO
                 # spaces are not significant around quoted fields but are part of unquoted fields #
                 next;
                 INT space count := spaces;
                 IF ch = """" THEN
                     # quoted field part #
                     WHILE next;
                           WHILE NOT at end AND ch /= """" DO add; next OD;
                           IF NOT at end THEN
                               next;
                               IF ch = """" THEN
                                   # embedded quote #
                                   add
                               FI
                           FI;
                           NOT at end AND ch = """"
                     DO SKIP OD;
                     space count := spaces;
                     IF at end OR ch = "," THEN
                         # nothing significant after the quoted field part #
                         space count := 0
                     FI
                 FI;
                 # unquoted field part #
                 tsv +:= space count * " ";
                 WHILE NOT at end AND ch /= "," DO add; next OD;
                 IF ch = "," THEN
                     # have another field following this one #
                     tsv +:= tab
                 FI
             OD;
             tsv
         END # csv2tsv # ;
    # task test cases #
    []STRING tests =
        ( "a,""b"""
        , """a"",""b""""c"""
        , ""
        , ",a"
        , "a,"""
        , " a , ""b"""
        , """12"",34"
        , "a" + tab + "b, That is a TAB character"
        , "a\tb"
        , "a\n\rb"
        , "a" + nul + "b, That is a NUL character"
        , "a" + cr + "b, Be sure to change RETURN to the '\r' control character (#xd)"
        , "a\b"
        );
    FOR i FROM LWB tests TO UPB tests DO
        print( ( "    {{", show ctrl(          tests[ i ] ),   "}}", newline
               , " -> {{", show ctrl( csv2tsv( tests[ i ] ) ), "}}", newline
               )
             )
    OD
END
