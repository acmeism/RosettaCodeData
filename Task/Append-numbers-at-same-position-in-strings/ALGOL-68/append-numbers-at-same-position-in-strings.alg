BEGIN # form a list of strings by concatenating numbers from 3 lists #
    []INT list1 = (  1,  2,  3,  4,  5,  6,  7,  8,  9 )
        , list2 = ( 10, 11, 12, 13, 14, 15, 16, 17, 18 )
        , list3 = ( 19, 20, 21, 22, 23, 24, 25, 26, 27 )
        ;
    [ LWB list1 : UPB list1 ]STRING result;
    FOR i FROM LWB list1 TO UPB list1 DO
        result[ i ] := whole( list1[ i ], 0 ) + whole( list2[ i ], 0 ) + whole( list3[ i ], 0 )
    OD;
    STRING prefix := "[ ";
    FOR i FROM LWB result TO UPB result DO
        print( ( prefix, result[ i ] ) );
        prefix := ", "
    OD;
    print( ( " ]", newline ) )
END
