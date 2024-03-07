BEGIN # range consolidation                                                  #

    MODE RANGE = STRUCT( REAL lb, ub );

    # returns a with the bounds swapped if necessary, so lb OF a <= ub OF a  #
    OP   NORMALISE = ( RANGE a )RANGE:
         ( IF lb OF a < ub OF a THEN lb OF a ELSE ub OF a FI
         , IF ub OF a > lb OF a THEN ub OF a ELSE lb OF a FI
         ) # NORMALISE # ;
    # returns a with each element normalised                                 #
    OP   NORMALISE = ( []RANGE a )[]RANGE:
         BEGIN
            [ LWB a : UPB a ]RANGE result;
            FOR a pos FROM LWB a TO UPB a DO result[ a pos ] := NORMALISE a[ a pos ] OD;
            result
         END # NORMALISE # ;
    OP   < = ( RANGE a, b )BOOL: lb OF a < lb OF b;
    OP   > = ( RANGE a, b )BOOL: lb OF a > lb OF b;

    # sorts a into order of each element's lb                                #
    OP   SORT = ( []RANGE a )[]RANGE:
         BEGIN
            # in-place quick sort an array of RANGEs from element lb         #
            #                                                  to element ub #
            PROC quicksort = ( REF[]RANGE a, INT lb, ub )REF[]RANGE:
                 IF ub <= lb
                 THEN
                    # empty array or only 1 element                          #
                    a
                 ELSE
                    # more than one element, so must sort                    #
                    INT left   := lb;
                    INT right  := ub;
                    # choosing the middle element of the array as the pivot  #
                    RANGE pivot  := a[ left + ( ( right + 1 ) - left ) OVER 2 ];
                    WHILE
                        WHILE IF left  <= ub THEN a[ left  ] < pivot ELSE FALSE FI DO left  +:= 1 OD;
                        WHILE IF right >= lb THEN a[ right ] > pivot ELSE FALSE FI DO right -:= 1 OD;
                        left <= right
                    DO
                        RANGE t    := a[ left  ];
                        a[ left  ] := a[ right ];
                        a[ right ] := t;
                        left      +:= 1;
                        right     -:= 1
                    OD;
                    quicksort( a, lb,   right );
                    quicksort( a, left, ub    );
                    a
                 FI # quicksort # ;
            quicksort( HEAP[ LWB a : UPB a ]RANGE := a, LWB a, UPB a )
         END # SORT # ;

    # returns the consolidation of the ranges in a in                        #
    OP   CONSOLIDATE = ( []RANGE a in )[]RANGE:
         IF UPB a in <= LWB a in
         THEN a in                                            # 0 or 1 range #
         ELSE                                              # multiple ranges #
            []RANGE a = SORT NORMALISE a in;
            [ 1 : 2 * ( ( UPB a - LWB a ) + 1 ) ]RANGE result;
            INT r max := 1;
            result[ r max ] := a[ LWB a ];
            FOR a pos FROM LWB a + 1 TO UPB a DO
                RANGE m = result[ r max ], n = a[ a pos ];
                IF ub OF m < lb OF n THEN
                    result[ r max +:= 1 ] := n             # distinct ranges #
                ELSE
                    result[ r max ]                     # overlapping ranges #
                        := ( IF lb OF m < lb OF n THEN lb OF m ELSE lb OF n FI
                           , IF ub OF m > ub OF n THEN ub OF m ELSE ub OF n FI
                           )
                FI
            OD;
            result[ : r max ]
         FI # CONSOLIDATE # ;

    OP   FMT = ( REAL v )STRING:   # prints v with at most 3 decimal places #
         BEGIN
            STRING result := fixed( ABS v, 0, 3 );
            IF result[ LWB result ] = "." THEN "0" +=: result FI;
            WHILE result[ UPB result ] = "0" DO result := result[ : UPB result - 1 ] OD;
            IF result[ UPB result ] = "." THEN result := result[ : UPB result - 1 ] FI;
            IF v < 0 THEN "-" ELSE "" FI + result
         END # FMT # ;

    OP   TOSTRING = ( RANGE a )STRING: "[ " + FMT lb OF a + ", " + FMT ub OF a + " ]";
    OP   TOSTRING = ( []RANGE a )STRING:
         BEGIN
            STRING result := "[";
            STRING prefix := " ";
            FOR r pos FROM LWB a TO UPB a DO
                result +:= prefix + TOSTRING a[ r pos ];
                prefix := ", "
            OD;
            result + " ]"
         END # TOSTRING # ;
    PRIO PAD = 8;                 # right pads s with blanks to w characters #
    OP   PAD = ( STRING s, INT w )STRING:
         IF   INT len = ( UPB s - LWB s ) + 1;
              len >= w
         THEN s
         ELSE s + ( ( w - len ) * " " )
         FI # PAD # ;

    # task test cases                                                        #

    PROC test = ( []RANGE a )VOID:
         BEGIN print( ( ( TOSTRING a PAD 60 ), " -> ", TOSTRING CONSOLIDATE a, newline ) ) END;
    test( []RANGE( RANGE( 1.1, 2.2 )                                         ) );
    test( ( ( 6.1, 7.2 ), (  7.2, 8.3 )                                      ) );
    test( ( ( 4,   3   ), (  2,   1   )                                      ) );
    test( ( ( 4,   3   ), (  2,   1   ), ( -1, -2 ), ( 3.9, 10 )             ) );
    test( ( ( 1,   3   ), ( -6,  -1   ), ( -4, -5 ), ( 8,    2 ), ( -6, -6 ) ) )

END
