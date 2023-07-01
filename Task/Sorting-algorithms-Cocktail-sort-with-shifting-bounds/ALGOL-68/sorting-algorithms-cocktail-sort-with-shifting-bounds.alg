BEGIN # cocktail sort with shifting bounds                                   #

    # sorts data, using a cocktail sort with shifting bounds                 #
    # a reference to the sorted data is returned                             #
    # - defined as an operator as Algol 68 has operator overloading but not  #
    # procedure overloading                                                  #
    # (similar operators with the same name could be defined for other types #
    #  of array)                                                             #
    OP   COCKTAILSORTSB = ( []INT data )REF[]INT:
         BEGIN
            # make a copy of the data                                        #
            REF[]INT a := HEAP[ LWB data : UPB data ]INT := data;
            # `beginIdx` and `endIdx` marks the first and last index to check. #
            INT begin idx := LWB a;
            INT end idx   := UPB a - 1;

            WHILE begin idx <= end idx DO
                INT new begin idx := end idx;
                INT new end idx   := begin idx;
                FOR ii FROM begin idx TO end idx DO
                    IF a[ ii ] > a[ ii + 1 ] THEN
                        INT aii      = a[ ii     ];
                        a[ ii     ] := a[ ii + 1 ];
                        a[ ii + 1 ] := aii;
                        new end idx := ii
                    FI
                OD;

                # decreases `endIdx` because the elements after `newEndIdx` are in correct order #
                end idx := new end idx - 1;

                FOR ii FROM end idx BY -1 TO begin idx DO
                    IF a[ ii ] > a[ ii + 1 ] THEN
                        INT aii      = a[ ii     ];
                        a[ ii     ] := a[ ii + 1 ];
                        a[ ii + 1 ] := aii;
                        new begin idx := ii
                    FI
                OD;

                # increases `beginIdx` because the elements before `newBeginIdx` are in correct order. #
                begin idx := new begin idx + 1
            OD;
            a
         END # COCKTAILSORTSB # ;

    # test the COCKTAILSORTSB operator                                       #
    PROC test cocktail sort with shifting bounds = ( []INT data )VOID:
         BEGIN
             REF[]INT sorted := COCKTAILSORTSB data;
             print( ( "[" ) );
             FOR i FROM LWB data   TO UPB data   DO print( ( " ", whole( data[ i ],   0 ) ) ) OD;
             print( ( " ]", newline, "    -> [" ) );
             FOR i FROM LWB sorted TO UPB sorted DO print( ( " ", whole( sorted[ i ], 0 ) ) ) OD;
             print( ( " ]", newline ) )
         END # test cocktail sort with shifting bounds # ;

    # test cases from the Action! sample                                     #
    test cocktail sort with shifting bounds( ( 1, 4, -1, 0, 3, 7, 4, 8, 20, -6 ) );
    test cocktail sort with shifting bounds( ( 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
                                             , -1, -2, -3, -4, -5, -6, -7, -8, -9, -10
                                             )
                                           );
    test cocktail sort with shifting bounds( ( 101, 102, 103, 104, 105, 106, 107, 108 ) );
    test cocktail sort with shifting bounds( ( 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1 ) );
    # additional test cases                                                  #
    test cocktail sort with shifting bounds( ( 1, 1, 1, 1, 1, 1 ) );
    test cocktail sort with shifting bounds( ( 0 ) );
    test cocktail sort with shifting bounds( () )
END
