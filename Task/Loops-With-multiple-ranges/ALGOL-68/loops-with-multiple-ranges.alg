BEGIN
    # translation of task PL/1 code, with minimal changes, semicolons required by      #
    # PL/1 but not allowed in Algol 68 removed, unecessary rounding removed            #
    # Note that in Algol 68, the loop counter is a local variable to the loop and      #
    # the value of j is not available outside the loops                                #
    PROC loop body = ( INT j )VOID:          #(below)  **  is exponentiation:  4**3=64 #
    BEGIN sum +:= ABS j;                                      #add absolute value of J.#
          IF ABS prod<2**27 AND j /= 0 THEN prod *:= j FI     #PROD is small enough & J#
                                                              # ABS(n) = absolute value#
          END;                                                #not 0, then multiply it.#
                           #SUM and PROD are used for verification of J incrementation.#
     INT  prod :=  1;                        #start with a product of unity.           #
     INT   sum :=  0;                        #  "     "  "   sum    " zero.            #
     INT     x := +5;
     INT     y := -5;
     INT     z := -2;
     INT   one :=  1;
     INT three :=  3;
     INT seven :=  7;
         FOR j FROM -three  BY  three TO      ( 3**3 )        DO loop body( j ) OD;
         FOR j FROM -seven  BY  x     TO    +seven            DO loop body( j ) OD;
         FOR j FROM    555            TO    550 - y           DO loop body( j ) OD;
         FOR j FROM     22  BY -three TO   -28                DO loop body( j ) OD;
         FOR j FROM   1927            TO  1939                DO loop body( j ) OD;
         FOR j FROM      x  BY  z     TO     y                DO loop body( j ) OD;
         FOR j FROM      ( 11**x )    TO      ( 11**x ) + one DO loop body( j ) OD;
         print((" sum= ", whole( sum,0), newline));           #display strings to term.#
         print(("prod= ", whole(prod,0), newline))            #   "       "     "   "  #
END
