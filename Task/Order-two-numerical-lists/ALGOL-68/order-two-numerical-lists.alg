BEGIN # compare lists (rows) of integers #
    # returns TRUE if there is an element in a that is < the corresponding #
    # element in b and all previous elements are equal; FALSE otherwise    #
    OP < = ( []INT a, b )BOOL:
       IF  INT  a pos  := LWB a;
           INT  b pos  := LWB b;
           BOOL equal  := TRUE;
           WHILE a pos <= UPB a AND b pos <= UPB b AND equal DO
               equal := a[ a pos ] = b[ b pos ];
               IF equal THEN
                   a pos +:= 1;
                   b pos +:= 1
               FI
           OD;
           NOT equal
       THEN
           # there is an element in a and b that is not equal #
           a[ a pos ] < b[ b pos ]
       ELSE
           # all elements are equal or one list is shorter #
           # a is < b if a has fewer elements #
           a pos > UPB a AND b pos <= UPB b
       FI # < # ;

    # tests a < b has the expected result #
    PROC test = ( STRING a name, []INT a, STRING b name, []INT b, BOOL expected )VOID:
         BEGIN
            BOOL result = a < b;
            print( ( a name, IF result THEN " <  " ELSE " >= " FI, b name
                   , IF result = expected THEN "" ELSE ", NOT as expected" FI
                   , newline
                   )
                 )
         END # test # ;

    # test cases as in the BBC basic sample #
    []INT list1 = ( 1, 2, 1, 5, 2 );
    []INT list2 = ( 1, 2, 1, 5, 2, 2 );
    []INT list3 = ( 1, 2, 3, 4, 5 );
    []INT list4 = ( 1, 2, 3, 4, 5 );
    test( "list1", list1, "list2", list2, TRUE  );
    test( "list2", list2, "list3", list3, TRUE  );
    test( "list3", list3, "list4", list4, FALSE );

    # additional test cases #
    []INT list5 = ( 9, 0, 2, 1, 0 );
    []INT list6 = ( 4, 0, 7, 7 );
    []INT list7 = ( 4, 0, 7    );
    []INT list8 = ( );
    test( "list5", list5, "list6", list6, FALSE );
    test( "list6", list6, "list7", list7, FALSE );
    test( "list7", list7, "list8", list8, FALSE );
    test( "list8", list8, "list7", list7, TRUE  )

END
