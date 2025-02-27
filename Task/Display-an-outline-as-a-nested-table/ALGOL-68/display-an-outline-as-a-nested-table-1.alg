BEGIN # Show an outline as a wiki or HTML table                              #
    MODE ONODE = STRUCT( STRING text, INT indent, REF ONODE next, child );
    REF ONODE nil node = NIL;
    OP   LTRIM = ( STRING s )STRING:      # returns s without leading spaces #
         BEGIN
            INT s pos := LWB s;
            WHILE IF s pos > UPB s THEN FALSE ELSE s[ s pos ] = " " FI DO s pos +:= 1 OD;
            IF s pos > UPB s THEN "" ELSE s[ s pos : ] FI
         END # LTRIM # ;
    OP   INDENTOF = ( STRING s )INT:  # returns count of leading spaces of s #
         BEGIN
            INT s pos := LWB s;
            WHILE IF s pos > UPB s THEN FALSE ELSE s[ s pos ] = " " FI DO s pos +:= 1 OD;
            s pos - LWB s
         END # INDENTOF # ;

    # count the total number of columns in tree                              #
    OP   COUNTCOLUMNS = ( REF ONODE tree )INT:
         IF   child OF tree IS nil node
         THEN 1
         ELSE INT count := 0;
              REF ONODE next := child OF tree;
              WHILE next ISNT nil node DO
                  count +:= COUNTCOLUMNS next;
                  next   := next OF next
              OD;
              count
         FI # COUNTCOLUMNS # ;

    OP   TOONODE = ( []STRING s )REF ONODE:
         IF   HEAP ONODE result;
              LWB s > UPB s
         THEN result := ( "", 0, nil node, nil node )
         ELSE result := ( s[ LWB s ], INDENTOF s[ LWB s ], nil node, nil node );
              [ 1 : ( UPB s - LWB s ) + 1 ]REF ONODE tstack;
              FOR i TO UPB tstack DO tstack[ i ] := nil node OD;
              INT s pos := LWB tstack;
              tstack[ s pos ] := result;
              FOR pos FROM LWB s + 1 TO UPB s DO
                  INT indent = INDENTOF s[ pos ];
                  WHILE indent < indent OF tstack[ s pos ] DO s pos -:= 1 OD;
                  HEAP ONODE next := ( s[ pos ], indent, nil node, nil node );
                  IF   indent > indent OF tstack[ s pos ]
                  THEN child OF tstack[ s pos ] := next;
                       tstack[ s pos +:= 1 ] := next
                  ELSE IF   next OF tstack[ s pos ] IS nil node
                       THEN next OF tstack[ s pos ] := next
                       FI;
                       tstack[ s pos ] := next
                  FI
              OD;
              result
         FI # TOONODE # ;

    PROC print tree table body = ( REF ONODE tree, STRING tr, rt, open td, close td, dt, empty td )VOID:
         BEGIN
            INT       td max := 0;      # find the maximum elements the rows #
            REF ONODE next   := tree;
            WHILE next ISNT nil node DO
                td max +:= COUNTCOLUMNS next;
                next    := next OF next
            OD;
            [ 1 : td max ]REF ONODE td;  # get the elements of the first row #
            td max := 0;
            next   := tree;
            WHILE next ISNT nil node DO
                td[ td max +:= 1 ] := next;
                next               := next OF next
            OD;
            BOOL more rows := TRUE;                      # generate the rows #
            WHILE more rows DO
                print( ( tr, newline ) );           # output the current row #
                FOR td pos TO td max DO
                    REF ONODE element = td[ td pos ];
                    IF   element IS nil node
                    THEN print( ( empty td ) )
                    ELSE INT span = COUNTCOLUMNS element;
                         print( ( open td ) );
                         IF span > 1 THEN print( ( " colspan=""", whole( span, 0 ), """" ) ) FI;
                         print( ( close td, LTRIM text OF element ) );
                         IF dt /= "" THEN print( ( "</td>" ) ) FI;
                         print( ( newline ) )
                    FI
                OD;
                IF rt /= "" THEN print( ( rt, newline ) ) FI;
                []REF ONODE prev = td[ 1 : td max ];   # replace td with the #
                INT new max := 0;    # ... child elements of the current row #
                more rows   := FALSE;
                FOR td pos TO td max DO
                    next := IF   prev[ td pos ] IS nil node
                            THEN nil node
                            ELSE child OF prev[ td pos ]
                            FI;
                    td[ new max +:= 1 ] := next;
                    IF next ISNT nil node THEN
                        more rows := TRUE;
                        WHILE ( next := next OF next ) ISNT nil node DO
                           td[ new max +:= 1 ] := next
                        OD
                    FI
                OD;
                td max := new max
            OD
         END # print tree table body # ;

    # prints tree as an HTML table                                           #
    PROC print tree as html table = ( REF ONODE tree )VOID:
         BEGIN
            print( ( "<table style=""text-align: center"" border=""1"" cellspacing=""0"">", newline ) );
            print tree table body( tree, "<tr>", "</tr>", "<td", ">", "</td>", "<td/>" );
            print( ( "</table>", newline ) )
         END # print tree as html table # ;

    # prints tree as a wiki table  b                                         #
    PROC print tree as wiki table = ( REF ONODE tree )VOID:
         BEGIN
            print( ( "{| class=""wikitable"" style=""text-align: center;""", newline ) );
            print tree table body( tree, "|-", "", "| ", " | ", "", "|  |" + REPR 10 );
            print( ( "|}", newline ) )
         END # print tree as wiki table # ;

    BEGIN
        REF ONODE ex tree
            = TOONODE []STRING( "Display an outline as a nested table."
                              , "    Parse the outline to a tree,"
                              , "        measuring the indent of each line,"
                              , "        translating the indentation to a nested structure,"
                              , "        and padding the tree to even depth."
                              , "            (happens during the output in this version)"
                              , "    count the leaves descending from each node,"
                              , "        defining the width of a leaf as 1,"
                              , "        and the width of a parent node as a sum."
                              , "            (The sum of the widths of its children)"
                              , "    and write out a table with 'colspan' values"
                              , "        either as a wiki table,"
                              , "        or as HTML."
                              );
        print tree as html table( ex tree );
        print tree as wiki table( ex tree )
    END
END
