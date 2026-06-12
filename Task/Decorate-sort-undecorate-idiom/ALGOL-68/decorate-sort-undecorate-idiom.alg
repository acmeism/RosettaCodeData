BEGIN # Schwartzian transform - decorate a list of strings, sort them and    #
      # undecorate them                                                      #

    # being strongly typed, Algol 68 would require different modes for each  #
    # possible decoration - here we decorate a row of strings with an        #
    # integer                                                                #

    # mode to hold a decorated string                                        #
    MODE STRINGWITHINT = STRUCT( STRING v, INT d );

    # decorates a with INT values using the dp procedure                     #
    PRIO DECORATE = 1;   # DECORATE is dyadic so need a priority: use lowest #
    OP   DECORATE = ( []STRING a, PROC( STRING )INT dp )[]STRINGWITHINT:
         BEGIN
            REF[]STRINGWITHINT result = HEAP[ LWB a : UPB a ]STRINGWITHINT;
            FOR i FROM LWB a TO UPB a DO
                result[ i ] := STRINGWITHINT( a[ i ], dp( a[ i ] ) )
            OD;
            result
         END # DECORATE # ;

    # returns a undecorated                                                  #
    OP   UNDECORATE = ( []STRINGWITHINT a )[]STRING:
         BEGIN
            REF[]STRING result = HEAP[ LWB a : UPB a ]STRING;
            FOR i FROM LWB a TO UPB a DO
                result[ i ] := v OF a[ i ]
            OD;
            result
         END # UNDECORATE # ;

    # returns TRUE if a < b                                                  #
    OP   < = ( STRINGWITHINT a, b )BOOL:
                 d OF a < d OF b OR ( d OF a = d OF b AND v OF a < v OF b );
    # returns TRUE if a > b                                                  #
    OP   > = ( STRINGWITHINT a, b )BOOL:
                 d OF a > d OF b OR ( d OF a = d OF b AND v OF a > v OF b );

    # sorts a into order of each elements d and v                            #
    OP   SORT = ( []STRINGWITHINT qsa )[]STRINGWITHINT:
         BEGIN
            # in-place quick sort an array of STRINGWITHINTs from element lb #
            #                                                  to element ub #
            PROC quicksort = ( REF[]STRINGWITHINT a, INT lb, ub )REF[]STRINGWITHINT:
                 IF ub <= lb
                 THEN
                    # empty array or only 1 element                          #
                    a
                 ELSE
                    # more than one element, so must sort                    #
                    INT left   := lb;
                    INT right  := ub;
                    # choosing the middle element of the array as the pivot  #
                    STRINGWITHINT pivot  := a[ left + ( ( right + 1 ) - left ) OVER 2 ];
                    WHILE
                        WHILE IF left  <= ub THEN a[ left  ] < pivot ELSE FALSE FI
                        DO
                            left  +:= 1
                        OD;
                        WHILE IF right >= lb THEN a[ right ] > pivot ELSE FALSE FI
                        DO
                            right -:= 1
                        OD;
                        left <= right
                    DO
                        STRINGWITHINT t := a[ left  ];
                        a[ left  ]      := a[ right ];
                        a[ right ]      := t;
                        left           +:= 1;
                        right          -:= 1
                    OD;
                    VOID( quicksort( a, lb, right ) );
                    quicksort( a, left, ub    )
                 FI # quicksort # ;
            quicksort( HEAP[ LWB qsa : UPB qsa ]STRINGWITHINT := qsa, LWB qsa, UPB qsa )
         END # SORT # ;


    # prints the elements of a enclosed in quotes with separating commas     #
    OP    SHOWQUOTED = ( []STRING a )VOID:
          BEGIN
             print( ( "[" ) );
             STRING separator := " ";
             FOR i FROM LWB a TO UPB a DO
                 print( ( separator, """", a[ i ], """" ) );
                 separator := ", "
             OD;
             print( ( " ]" ) )
          END # SHOWQUOTED # ;

    # task test case                                                         #
    SHOWQUOTED UNDECORATE SORT ( []STRING( "Rosetta", "Code", "is", "a", "programming"
                                         , "chrestomathy", "site"
                                         )
                               DECORATE ( ( STRING v )INT: ( UPB v - LWB v ) + 1 )
                               );
    print( ( newline ) )
END
