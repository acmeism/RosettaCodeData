BEGIN # sort numbers lexicographically                                        #

    # code from the Sorting algorithms/Insertion sort task                    #
    MODE DATA = STRING;

    PROC in place insertion sort = (REF[]DATA item)VOID:
    BEGIN
       INT first := LWB item;
       INT last  := UPB item;
       INT j;
       DATA value;
       FOR i FROM first + 1 TO last DO
          value := item[i];
          j := i - 1;
          WHILE ( j >= LWB item AND j <= UPB item | item[j]>value | FALSE ) DO
             item[j + 1] := item[j];
             j -:=  1
          OD;
          item[j + 1] := value
       OD
    END # in place insertion sort #;

    # end code from the Sorting algorithms/Insertion sort task                #

    # returns s converted to an integer, NB: no error checking                #
    OP   TOINT = ( STRING s )INT:
         BEGIN
            INT result := 0;
            FOR i FROM LWB s TO UPB s DO
                result *:= 10 +:= ( ABS s[ i ] - ABS "0" )
            OD;
            result
         END # TOINT # ;

    # returns a array of integers 1..n sorted lexicographically               #
    PROC lexicographic order = ( INT n )[]INT:
         BEGIN
            [ 1 : n ]STRING v; FOR i TO n DO v[ i ] := whole( i, 0 ) OD;
            in place insertion sort( v );
            [ 1 : n ]INT result;
            FOR i TO n DO result[ i ] := TOINT v[ i ] OD;
            result
         END # lexicographic order # ;

    # prints the elements of a                                                #
    PROC show int array = ( []INT a )VOID:
         BEGIN
             print( ( "[" ) );
             FOR i FROM LWB a TO UPB a DO print( ( " ", whole( a[ i ], 0 ) ) ) OD;
             print( ( " ]", newline ) )
         END # show int array # ;

    # test cases                                                              #
    show int array( lexicographic order( 13 ) );
    show int array( lexicographic order( 21 ) )

END
