    # make all columns of tree have the same number of rows                  #
    # tree is modified and also returned as the result                       #
    OP   STANDARDISE = ( REF ONODE tree )REF ONODE:
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
            WHILE BOOL more rows := FALSE;                # balance the tree #
                  FOR td pos TO td max DO
                      REF ONODE element = td[ td pos ];
                      IF   child OF element ISNT nil node
                      THEN more rows := TRUE
                      FI
                  OD;
                  more rows
            DO    FOR td pos TO td max DO      # add "missing" child elements #
                      REF ONODE element = td[ td pos ];
                      IF   child OF element IS nil node
                      THEN HEAP ONODE new child := ( "", 0, nil node, nil node );
                           child OF element     :=  new child
                      FI
                  OD;
                  []REF ONODE prev = td[ 1 : td max ];  # replace td with the #
                  INT new max := 0;   # ... child elements of the current row #
                  FOR td pos TO td max DO
                      next := child OF prev[ td pos ];
                      td[ new max +:= 1 ] := next;
                      IF next ISNT nil node THEN
                          WHILE ( next := next OF next ) ISNT nil node DO
                             td[ new max +:= 1 ] := next
                          OD
                      FI
                  OD;
                  td max := new max
            OD;
            tree
         END # STANDARDISE # ;
