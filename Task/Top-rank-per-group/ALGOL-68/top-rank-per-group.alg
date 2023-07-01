BEGIN # show the top rank salaries per department                             #
    # NODE to hold the employee data - will be the MODE that is sorted        #
    MODE SITEM = STRUCT( STRING employee name
                       , STRING employee id
                       , INT    salary
                       , STRING department
                       );
    # ---- begin code from the quicksort using a custom comparator task ----- #
    #--- Swap function ---#
    PROC swap = (REF[]SITEM array, INT first, INT second) VOID:
    (
        SITEM temp := array[first];
        array[first] := array[second];
        array[second]:= temp
    );
    #--- Quick sort partition arg function with custom comparision function ---#
    PROC quick = (REF[]SITEM array, INT first, INT last, PROC(SITEM,SITEM)INT compare) VOID:
    (
        INT   smaller := first + 1,
              larger  := last;
        SITEM pivot   := array[first];
        WHILE smaller <= larger DO
            WHILE compare(array[smaller], pivot) < 0 AND smaller < last DO
                smaller +:= 1
            OD;
            WHILE compare( array[larger], pivot) > 0 AND larger > first DO
                larger  -:= 1
            OD;
            IF smaller < larger THEN
                swap(array, smaller, larger);
                smaller +:= 1;
                larger  -:= 1
            ELSE
                smaller +:= 1
            FI
        OD;
        swap(array, first, larger);
        IF first < larger-1 THEN
            quick(array, first, larger-1, compare)
        FI;
        IF last > larger +1 THEN
            quick(array, larger+1, last, compare)
        FI
    );
    #--- Quick sort array function with custom comparison function ---#
    PROC quicksort = (REF[]SITEM array, PROC(SITEM,SITEM)INT compare) VOID:
    (
      IF UPB array > LWB array THEN
        quick(array, LWB array, UPB array, compare)
      FI
    );
    # ==== end   code from the quicksort using a custom comparator task ===== #

    # sort comparison routine - sort ascending department, descending salary  #
    PROC sort by department then salary = ( SITEM a, SITEM b )INT:
         IF   department OF a < department OF b THEN -1
         ELIF department OF a > department OF b THEN  1
         ELIF     salary OF a >     salary OF b THEN -1
         ELIF     salary OF a <     salary OF b THEN  1
         ELSE                                         0
         FI # sort by department then salary # ;

    # returns s blank padded on the right to at least w characters            #
    PROC pad right = ( STRING s, INT w )STRING:
         IF INT len = ( UPB s - LWB s ) + 1; len >= w THEN s ELSE s + ( ( w - len ) * " " ) FI;
    # shows the top n ranked salaries in each department                      #
    PROC show top rank = ( []SITEM data, INT n )VOID:
         BEGIN
            # copy the data and sort it                                       #
            [ LWB data : UPB data ]SITEM sorted data := data;
            quicksort( sorted data, sort by department then salary );
            # show the top salaries per department                            #
            INT d pos := LWB sorted data;
            WHILE d pos <= UPB sorted data DO
                STRING curr department := department OF sorted data[ d pos ];
                print( ( "Department: ", curr department, newline ) );
                INT    e count         := 0;
                WHILE IF e count < n THEN
                          print( ( "  "
                                 , employee id   OF sorted data[ d pos ]
                                 , "  "
                                 , pad right( employee name
                                                 OF sorted data[ d pos ], 24 )
                                 , "  "
                                 , whole( salary OF sorted data[ d pos ], -6 )
                                 , newline
                                 )
                               )
                      FI;
                      e count +:= 1;
                      d pos   +:= 1;
                      IF d pos > UPB sorted data
                      THEN FALSE
                      ELSE curr department = department OF sorted data[ d pos ]
                      FI
                DO SKIP OD;
                print( ( newline ) )
            OD
        END # show top rank # ;

    # employee data                                                           #
    []SITEM employees = ( ( "Tyler Bennett",   "E10297", 32000, "D101" )
                        , ( "John Rappl",      "E21437", 47000, "D050" )
                        , ( "George Woltman",  "E00127", 53500, "D101" )
                        , ( "Adam Smith",      "E63535", 18000, "D202" )
                        , ( "Claire Buckman",  "E39876", 27800, "D202" )
                        , ( "David McClellan", "E04242", 41500, "D101" )
                        , ( "Rich Holcomb",    "E01234", 49500, "D202" )
                        , ( "Nathan Adams",    "E41298", 21900, "D050" )
                        , ( "Richard Potter",  "E43128", 15900, "D101" )
                        , ( "David Motsinger", "E27002", 19250, "D202" )
                        , ( "Tim Sampair",     "E03033", 27000, "D101" )
                        , ( "Kim Arlich",      "E10001", 57000, "D190" )
                        , ( "Timothy Grove",   "E16398", 29900, "D190" )
                        );
    # show the top two salaries by department                                 #
    show top rank( employees, 2 )
END
